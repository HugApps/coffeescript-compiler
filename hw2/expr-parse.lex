%{

#include <stdlib.h>

%}

[a-z]    { return ID; } /*needs to be as the decaf specification*/


%%

{whitespc} 	{ }

{digit}		{
		  yylval=atof(yytext);
		  return(NUMBER);
		}

"+"		return(PLUS);
"*"		return(TIMES);
"("		return(LPAREN);
")"		return(RPAREN);

/*"\n"	return(END);*/