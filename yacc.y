%{#include <stdio.h>
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

void yyerror(const char *str){
    fprintf(stderr, "error: %s\n",str);
}

int yywrap(){
    return 1;
}

%}
%token SETENV PRINTENV UNSETENV CD LS NEW_LINE ALIAS UNALIAS BYE FLAG WORD COMMAND STRING FILEPATH
%token HOME ROOT DOT_DOT

%union
{
        int number;
        char* string;
}

%token <string> WORD
%token <string> COMMAND
%token <string> DOT_DOT

%%

commands:
     | commands command{
     printf("%s$ ",PWD);
     };

command:
    cd|new_line|alias_case|unalias_case|setenv|printenv|unsetenv|bye;

cd:
    |CD NEW_LINE{
        printf("Set directory to Home\n");
        chdir(getenv("HOME"));
        setenv("PWD", getenv("HOME"), 1);

    }

    |CD HOME NEW_LINE{
        printf("Set directory to Home\n");
        chdir(getenv("HOME"));
        setenv("PWD", getenv("HOME"), 1);

    }

     |CD ROOT NEW_LINE{
     	printf("\tSet Directory to Root");
        chdir("/");
    }

    |CD WORD NEW_LINE{

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
    }
    //fix
//    |CD DOT_DOT NEW_LINE{
//    printf("TEST");
//    chdir("/..");
//                char pwd[4096];
//                getcwd(pwd, sizeof(pwd));
//                setenv("PWD", pwd, 1);
//}
    ;

new_line:
    NEW_LINE {

    };

alias_case:
    ALIAS NEW_LINE{
	listalias();
    }
    | ALIAS WORD WORD NEW_LINE{
          addalias($2, $3);
          };

unalias_case:
    UNALIAS WORD{
    unalias($2);
    };

setenv:
    SETENV NEW_LINE{
        printf("Error: No variable or value was entered\n");
    };
    |SETENV WORD NEW_LINE{
        printf("Error: No value entered for variable %s. Nothing was added.\n", $2);
    };
    |SETENV WORD WORD NEW_LINE{
        char* variable = $2;
        char* value = $3;
        addEnv(variable,value);
    };
printenv:
    PRINTENV NEW_LINE{
        printEnv();
    }
unsetenv:
    UNSETENV NEW_LINE{
        printf("error: no variable entered to remove\n");
    }
    |UNSETENV WORD NEW_LINE{
        unSetEnv($2);
    }

bye:
	BYE
	{
		printf("Shutting Down\n");
		exit(0);
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
    	}
        	return 0;
}