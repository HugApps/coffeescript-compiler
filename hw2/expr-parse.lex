%{
#include "expr-parse.tab.h"
#include <stdlib.h>
#include <stdio.h>

%}

letter [a-zA-Z]
digit [0-9]
newline [\n]
id  {letter}|({letter}|{digit}|\_)+

%%

"+"		{ /*printf("PLUS");*/ return PLUS;};
"*"		{return TIMES;};
"("		{return LPAREN;};
")"		{return RPAREN;};

{id}	{ yylval.stringval = strdup(yytext); return ID; } /*needs to be as the decaf specification*/

%%