%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
char* result;
char* test(char* s1, char* s2);
char otherstring[256];
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

e : e PLUS t { printf("plus"); /*printf("%c plus %c",$1,$3); $$ = test($3);*/}
   | t { printf("e -> %s",$$); }
   ;

t : e TIMES f { printf("times"); }
   | f { printf("t->f: %s",$1); $$ = test($1, "add"); }
   ;

f : LPAREN e RPAREN { printf("paren"); }
   | ID { printf("(f (ID %s))",$1);}
   ;

%%

char* test(char* s1, char* s2){
	result = malloc(strlen(s1)+strlen(s2)+1);
	//printf("in test: %s", s1);
	strcpy(result,s1);
	strcat(result,s2);
	//printf("result %s",result);
   	return result;
}

void yyerror(char *error){
  extern char *yytext;
  extern int yylineno;
  fprintf(stderr, "ERROR: %s at symbol '%s' on line %d\n", error, yytext, yylineno);
}

/*int main(){
	yyparse();
	printf("check");
	free(result);
	return 0;
}*/