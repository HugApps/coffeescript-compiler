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
   | ID { printf("ID %d",$1); }
   ;

%%
