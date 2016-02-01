%{
#include <stdio.h>
#define SINGLELINE 262
#define CMT 263
#define STRING 264

%}

%%

\/\*([^.*]|\*+[^*/])*\*+\/ {return CMT;}
\/\/.*	{return SINGLELINE;}
\"(.)*\" {return STRING;}

%%

int main () {
  int token, start;
  start = 0; 
  
  while ((token = yylex())) {
  	if(token == STRING){
  		printf("%s",yytext);
  	}else if(token == CMT){
	int i;
	for(i=0; i < yyleng; i++){
	  printf(" ");
	}
	
    }else if(token == SINGLELINE){
    	int i;
	for(i=0; i < yyleng; i++){
	  printf(" ");
	}
    }else{
	printf("%s",yytext);
     }
}
  exit(0);
}
