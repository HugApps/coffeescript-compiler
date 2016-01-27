%{
#include <stdio.h>
#define SINGLELINE 262
#define CMT 263
#define STR 264

%}

%%

\/\*((\n+)|\*+[^*/])*\*+\/ {return CMT;}
\/\/.*	{return SINGLELINE;}
\"(.)*\" {return STR;}

%%

int main () {
  int token, start;
  start = 0; 
  
  while ((token = yylex())) {
  	if(token == STR){
  		print(yytext);
  	}else if(token == CMT){
		int i;
		for(i=0; i < yyleng; i++){
		  printf("*");
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
