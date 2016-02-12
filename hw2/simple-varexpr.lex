%{
#include "simple-varexpr.tab.h"
#include <math.h> 
%}

%%
[0-9]+ { yylval.dvalue = atoi(yytext); return T_NUMBER; } 
(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+)) { yylval.dvalue = atoi(yytext); return T_DOUBLE; } 
[ \t\n]     /* ignore whitespace */    
\n         { return *yytext; }
exp   { return T_EXP; }
sqrt  { return T_SQRT; }
log   { return T_LOG;  } 
[a-z]      { yylval.rvalue=yytext[0]-'a' ; return T_NAME; }
.     return yytext[0];
%%



