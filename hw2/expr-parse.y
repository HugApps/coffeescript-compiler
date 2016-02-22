%{ 
#include <stdio.h> 
#include <string.h>
int test();
char otherstring[256];
void yyerror(char *s);
%}

%token ID PLUS TIMES LPAREN RPAREN

%%

e : e PLUS t { printf("plus"); /*printf("%c plus %c",$1,$3); $$ = test($3);*/}
   | t { printf("e -> t"); }
   ;

t : t TIMES f { printf("times"); }
   | f { printf("t->f: %c",$1); $$ = test($1); }
   ;

f : LPAREN e RPAREN { printf("paren"); }
   | ID { printf("(f (ID %c))",$1); }
   ;

%%

int test(int str){
	printf("in test: %c", str);
   	return 99;
}

void yyerror(char *error){
  extern char *yytext;
  extern int yylineno;
  fprintf(stderr, "ERROR: %s at symbol '%s' on line %d\n", error, yytext, yylineno);
}