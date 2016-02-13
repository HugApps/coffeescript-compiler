%{

#include <stdlib.h>

%}

whitespc	[ \t]+
digit		[0-9]+


%%

{whitespc} 	{ }

{digit}		{
		  yylval=atof(yytext);
		  return(NUMBER);
		}

"+"		return(PLUS);
"-"		return(MINUS);

"*"		return(TIMES);
"/"		return(DIVIDE);

"^"		return(POWER);

"("		return(LEFT_PAREN);
")"		return(RIGHT_PAREN);

"\n"	return(END);