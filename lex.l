%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include "y.tab.h"
#include <string.h>
#include "helpers.h"

%}
%array
%option noyywrap
%x string_condition

CHAR            [.A-Za-z0-9!\/_-][.A-Za-z0-9!\/_-]*
ANYCHAR            [)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -][)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -]*
WORD		[A-Za-z0-9{}$_/\-]
COMMAND		\"[A-Za-z0-9<>|[:space:]_/\-]+\"

%%

<string_condition>{ANYCHAR}+     { yylval.string = strdup(yytext); return STRING;}
<string_condition>[\"]          {BEGIN(INITIAL);}

[ ]		            { }
bye                 { return BYE; }
cd		            { return CD;}
alias		        { return ALIAS; }
unalias		        { return UNALIAS; }
\n          return NEW_LINE;
[\"]                 { BEGIN(string_condition); }
[..]    { return DOT_DOT; }
{COMMAND}		{yylval.string = strdup(yytext); return COMMAND;};
{WORD}+			{yylval.string = strdup(yytext); return WORD;};
%%

