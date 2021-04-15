%{
#include <stdio.h>
#include "yacc.tab.h"
#include "helpers.h"
#include <pwd.h>

int inQuotes;

%}
CHAR            [.A-Za-z0-9!\/_-][.A-Za-z0-9!\/_-]*
ANYCHAR            [)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -][)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -]*
WORD		[A-Za-z0-9{}$_/\-.:~]
COMMAND		\"[A-Za-z0-9<>|[:space:]_/\-]+\"
%%

bye						return BYE;
cd						return CD;
alias						return ALIAS;
unalias						return UNALIAS;
setenv						return SETENV;
unsetenv					return UNSETENV;
printenv					return PRINTENV;
"|"                         return PIPE;
{WORD}+			{yylval.string = strdup(yytext); return WORD;};
"\n"						return 0;
\".*\" {
    yylval.string = (char*)calloc(strlen(yytext)-1, sizeof(char));
    strncpy(yylval.string, &yytext[1], strlen(yytext)-2);
    inQuotes = 1;
    return WORD;
}


%%

//http://westes.github.io/flex/manual/Multiple-Input-Buffers.html#Scanning-Strings
void scan_string(char* str)
{
    yy_switch_to_buffer(yy_scan_string(str));
    yyparse();
    yylex_destroy();
}