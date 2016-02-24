%{
#include "expr-parse.tab.h"
#include <stdlib.h>
#include <stdio.h>

%}

letter [a-zA-Z]
digit [0-9]
id  {letter}|({letter}|{digit}|\_)+

%%

"+"		{ /*printf("PLUS");*/ return PLUS;};
"*"		{return TIMES;};
"("		{return LPAREN;};
")"		{return RPAREN;};
"\n"	/* ignore newlines */
" "		/* ignore spaces */

{id}	{ yylval.stringval = strdup(yytext); return ID; } /*needs to be as the decaf specification*/

%%