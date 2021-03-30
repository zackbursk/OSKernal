/*
    Lex File.  The Lexical analyzer separates input into tokens. It will read the characters one by one
    from the standard input and form a token that will be passed to the parser
*/
%{
#include <stdio.h>
#include "y.tab.h"
%}
%%

cd          	return CD;
bye				return BYE;
\n              return NEW_LINE;

%%