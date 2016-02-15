%{ 
#include <stdio.h> 
%}

%token ID PLUS TIMES LPAREN RPAREN

%%

e : e PLUS t 
   | t
   ;

t : t TIMES f
   | f
   ;

f : LPAREN e RPAREN
   | ID { fprintf('ID'%d,$1); }
   ;

%%

void yyerror(char *s) {
   fprintf(stderr, "%s\n", s);
}

int main(void) {
   yyparse();
   return 0;
}

