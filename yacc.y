%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pwd.h>

#define PWD getenv("PWD")

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
        return 1;
}

int main()
{
	//alias_list = create_linked_list();
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

%}
%token CD BYE

%%

bye:
	BYE
	{
		printf("Shutting Down\n");
		exit(0);
	};
%%