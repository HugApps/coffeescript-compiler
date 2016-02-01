%{
#include <stdio.h>
#define NUMBER     256
#define BEGINEXP   257
#define WHITESPC   258
#define ENDEXP     259
#define LALPH      260
#define UALPH      261

%}

num [0-9]

%%

{num}   {return NUMBER;}
\/\*	{return BEGINEXP;}
[ \t]   {return WHITESPC;}
[a-z]	{return LALPH;}
[A-Z]	{return UALPH;}
\*\/	{return ENDEXP;}
%%

int main () {
  int token, start;
  start = 0; 
  
  while ((token = yylex())) {
    if(token == BEGINEXP && !start){
    	start = 1;
    	printf("  ");
    }else if(token == ENDEXP && start){
    	start = 0;
    	printf("  ");
    }else if(start){
    	printf(" ");
    }else{
    	printf("%s",yytext);
    }
  }
  exit(0);
}