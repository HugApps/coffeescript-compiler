%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>

char* result;
char* concat(char* id, char* strbegin, char* strend);
void yyerror(char *s);

%}

%union {
char* stringval;
}

%token ID PLUS TIMES LPAREN RPAREN

%type <stringval>ID
%type <stringval>e
%type <stringval>t
%type <stringval>f

%%

e : e PLUS t { printf("(e %s (PLUS +) %s)",$1,$3);}
   | t { $$ = concat($1,"(e ",")"); printf("%s",$$); }
   ;

t : e TIMES f { printf("times"); }
   | f { $$ = concat($1,"(t ",")");}
   ;

f : LPAREN e RPAREN { $$ = concat($2,"(LPAREN \\( ","(RPAREN \\)"); }
   | ID { $$ = concat($1,"(f (ID ","))"); }
   ;

%%

char* concat(char* id, char* strbegin, char* strend){
	//printf("Id:%s begin:%s end:%s",id,strbegin,strend);
	result = malloc(strlen(id)+strlen(strbegin)+strlen(strend)+1);
	strcpy(result,strbegin);
	strcat(result,id);
	strcat(result,strend);
   	return result;
}

void yyerror(char *error){
  extern char *yytext;
  extern int yylineno;
  fprintf(stderr, "ERROR: %s at symbol '%s' on line %d\n", error, yytext, yylineno);
}

int main(){
	yyparse();
	free(result);
	return 0;
}