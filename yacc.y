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

void yyerror(const char *str){
    fprintf(stderr, "error: %s\n",str);
}

int yywrap(){
    return 1;
}
%}

%union {
    int number;
    char *string;
}

%token <i> LT GT AMP PIPE PRINTENV SETENV UNSETENV NEW_LINE
%token <i> CD BYE ALIAS UNALIAS PwD
%token <string> WORD VARIABLE STRING

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
	char* input = $2;
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
        };

    bye :
        BYE
	{
		printf("Shutting Down\n");
		exit(0);
	};



    argument :
    //check if external command
        WORD
        {
        //not built in
	commandTable[currentCommand].checkExternal = 1;
	//command is word
	commandTable[currentCommand].commandName = $1;
        }
        |
        //recursive call for arguments after the command (i.e. -a, -l, etc)
        command WORD
        {
            //get num argurments of current command
            int count = commandTable[currentCommand].numArgs;
            //set at count to the args
            commandTable[currentCommand].atptr[count] = $2;
            //increase num of args
            commandTable[currentCommand].numArgs++;
        }
        |
        command PIPE WORD
        {
        printf("MADE");
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
	}|
        ALIAS WORD WORD
        {
        addalias($2,$3);
        };

    unalias_case :
        UNALIAS WORD
        {
        unalias($2);
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
            	while(1){
            	if (isatty(fileno(stdin)))
            	printf("%s$ ",PWD);
            	yyparse();
            	//execute non built in/alias functions
            	executeOther();
            	}
                	return 0;
        }