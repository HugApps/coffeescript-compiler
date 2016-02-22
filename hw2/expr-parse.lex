%{
#include "expr-parse.tab.h"
#include <stdlib.h>
extern int yylval;
%}

letter [a-zA-Z]
digit [0-9]
id  {letter}|({letter}|{digit}|\_)+

%%

"+"		{ /*printf("PLUS");*/ return PLUS;};
"*"		{return TIMES;};
"("		{return LPAREN;};
")"		{return RPAREN;};

{id}	{ yylval = yytext[0]; return ID; } /*needs to be as the decaf specification*/

%%