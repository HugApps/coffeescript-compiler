%{
#include "expr-parse.tab.h"
#include <stdlib.h>
extern int yylval;
%}

%%

"+"		{printf("PLUS"); return PLUS;};
"*"		{printf("TIMES"); return TIMES;};
"("		{printf("LPAREN"); return LPAREN;};
")"		{printf("RPAREN"); return RPAREN;};

[a-zA-Z]    { yylval = yytext[0]; return ID; } /*needs to be as the decaf specification*/

%%