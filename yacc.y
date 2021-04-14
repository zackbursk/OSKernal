%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <string.h>
#include <limits.h>
#include <sys/file.h>

#include "helpers.h"
#include "helpers.c"

#define PWD getenv("PWD")
#define WRITE_END	1
#define READ_END	0

extern int inQuotes;

void yyerror(const char *str){
    fprintf(stderr, "error: %s\n",str);
}

int yywrap(){
    return 1;
}

char * expTilde(char * input)
{
    char * expand = input;
    int i;
    if (strlen(expand) == 1) {
	char *test = expand += 1;
	return getenv("HOME");
    }
    if (expand[0] == '~', expand[1] == '/') {
	char *test = expand += 2;
	char tmp[256];
	char *tmp2 = "";
	strcat(tmp,getenv("HOME"));
	strcat(tmp,"/");
	strcat(tmp,test);
	tmp2 = strdup(tmp);
	return tmp2;
    }
    if (expand[0] == '~' && strlen(expand) > 1){
        expand++;
        if(getpwnam(expand) == NULL){
            printf("\"%s\" is not a valid username.\n",expand);
        }
        else{
        //look up the substring in /etc/passwd using getpwnam
        //https://www.mkssoftware.com/docs/man5/struct_passwd.5.asp
            struct passwd *p = getpwnam(expand);
            char tmp[5000];
            strcpy(tmp, "/home/");
            return strcat(tmp, p->pw_name);
        }
    }
    return expand;
}

char * expEnv(char* input) {
    	char * expand = input;
    	int i;
    	for (i = 0; i < strlen(expand); i++)
    	{
		if(expand[i] == '$' && expand[i+1] == '{') {
		char* a = expand += 2;
		char *test;
		a[strlen(a)-1] = 0;
		if(getenv(a) != "(null)"){
			test=getenv(a);
			expand = test;
		}
		for (int i = 0; i < envCount; i++) {
		if(strcmp(envTable[i][0], a) == 0){
			test = envTable[i][1];
			expand = test;
		}
		}
	}
	return expand;
    	}
}

%}

%union {
    int number;
    char *string;
}

%token <i> LT GT AMP PIPE PRINTENV SETENV UNSETENV NEW_LINE
%token <i> CD BYE ALIAS UNALIAS PwD
%token <string> WORD VARIABLE STRING

%type <string> argument

%%

commands :
| commands command{
};

command :
    cd|alias_case|unalias_case|setenv|printenv|unsetenv|bye|argument;

    cd :
        CD
        {
	printf("Set directory to Home\n");
	chdir(getenv("HOME"));
	setenv("PWD", getenv("HOME"), 1);
        }
        |
        CD WORD
        {
        if(inQuotes == 1){
        char* input = expEnv($2);
        	if(chdir(input) == -1){
        	    printf("%s is not a valid directory\n", input);
        	}
        	else{
        		printf("Set directory to %s\n", input);
        		free($2);
        	    }
        	    char pwd[4096];
        	    getcwd(pwd, sizeof(pwd));
        	    setenv("PWD", pwd, 1);
        }
        else{
	char* input = expEnv(expTilde($2));
	if(chdir(input) == -1){
	    printf("%s is not a valid directory\n", input);
	}
	else{
		printf("Set directory to %s\n", input);
		free($2);
	    }
	    char pwd[4096];
	    getcwd(pwd, sizeof(pwd));
	    setenv("PWD", pwd, 1);
	    }
        };

    bye :
        BYE
	{
		printf("Shutting Down\n");
		exit(0);
	};



    argument :
        WORD
        {
        //not built in
	commandTable[currentCommand].checkExternal = 1;
	//command is word
	commandTable[currentCommand].name = expEnv($1);

        }
        |
        //recursive call for arguments after the command (i.e. -a, -l, etc)
        command WORD
        {
            //get num argurments of current command
            int count = commandTable[currentCommand].numArgs;
            //set at count to the args
            commandTable[currentCommand].atThis[count] = expEnv($2);
            //increase num of args
            commandTable[currentCommand].numArgs++;
        };
        /* NOT WORKING :( */
        |
        argument PIPE WORD
        {
        //so it doesn't crash
        return;
//
//        int count = commandTable[currentCommand].numArgs;
//        int count2 = commandTable[currentCommand].numCommands;
//
//        char *firstCom=$1;
//        char *secondCom = $3;
//
//        char *firstArg = commandTable[currentCommand].atThis[count-2];
//        char *sargs = commandTable[currentCommand].atThis[count-1];
//
//	char tmp[256];
//	char temp2[255];
//
//	char *path = strcpy(tmp, getenv("PATH"));
//
//	char *token = strtok(path, ":");
//	strcpy(temp2, "/bin/");
//	strcat(temp2, firstCom);
//
//        pid_t pid;
//	int fd[2];
//	pipe(fd);
//	pid = fork();
//
//	if(pid==0)
//	{
//	    dup2(fd[WRITE_END], STDOUT_FILENO);
//	    close(fd[READ_END]);
//	    execl(temp2,firstCom,firstArg,(char *)0);
//	}
//	else
//	{
//
//	pid=fork();
//	char tmp3[256];
//	char temp4[255];
//	char *token = strtok(path, ":");
//	strcpy(temp4, "/bin/");
//	strcat(temp4, secondCom);
//	char *sargs = commandTable[currentCommand].atThis[count];
//	    if(pid==0)
//	    {
//		dup2(fd[READ_END], STDIN_FILENO);
//		close(fd[WRITE_END]);
//		execl(temp4, secondCom, sargs, (char *)0);
//	    }
//	    break;
//        }
//        break;
        };


    printenv :
        PRINTENV
        {
            printEnv();
        };

    setenv :
        SETENV WORD WORD
        {
            addEnv($2,$3);
        };

    unsetenv :
        UNSETENV WORD
        {
            unSetEnv($2);
        };

    alias_case :
    	ALIAS
	{
	listalias();
	}
	|
        ALIAS WORD WORD
        {
        addalias($2,$3);
        };

    unalias_case :
        UNALIAS WORD
        {
        unalias(expEnv($2));
        };


%%

        int main()
        {
            printf("UUUUUUUU     UUUUUUUUFFFFFFFFFFFFFFFFFFFFFF\n");
                printf("U::::::U     U::::::UF::::::::::::::::::::F\n");
                printf("U::::::U     U::::::UF::::::::::::::::::::F\n");
                printf("UU:::::U     U:::::UUFF::::::FFFFFFFFF::::F\n");
                printf(" U:::::U     U:::::U   F:::::F       FFFFFF\n");
                printf(" U:::::D     D:::::U   F:::::F\n");
                printf(" U:::::D     D:::::U   F::::::FFFFFFFFFF\n");
                printf(" U:::::D     D:::::U   F:::::::::::::::F\n");
                printf(" U:::::D     D:::::U   F:::::::::::::::F\n");
                printf(" U:::::D     D:::::U   F::::::FFFFFFFFFF\n");
                printf(" U:::::D     D:::::U   F:::::F\n");
                printf(" U::::::U   U::::::U   F:::::F\n");
                printf(" U:::::::UUU:::::::U FF:::::::FF\n");
                printf("  UU:::::::::::::UU  F::::::::FF\n");
                printf("    UU:::::::::UU    F::::::::FF\n");
                printf("      UUUUUUUUU      FFFFFFFFFFF\n");
                printf("       Welcome to the Kernal     \n");
                signal(SIGINT, SIG_IGN);
            	while(1){
            	if (isatty(fileno(stdin)))
            	printf("%s$ ",PWD);
            	yyparse();
            	//execute non built in/alias functions
            	executeOther();
            	}
                	return 0;
        }