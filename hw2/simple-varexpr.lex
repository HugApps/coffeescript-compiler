%{
#include "simple-varexpr.tab.h"
#include <math.h>
%}

%%
[0-9]+    { yylval.rvalue = atoi(yytext); return INTEGER; } /* convert NUMBER token value to integer */
\n        { return NEWLINE;}
[ \t\n]   ;  /* ignore whitespace */
[a-z]     { yylval.lvalue = yytext[0] - 'a'; return VARIABLE; } /* convert NAME token into index */
.  return yytext[0];
%%
