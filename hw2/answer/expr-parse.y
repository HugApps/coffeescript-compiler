%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>

char* result;
char* concat(char* id, char* strbegin, char* strend);
%}

%union {
char* stringval;
}

%token ID PLUS TIMES LPAREN RPAREN

%type <stringval>ID
%type <stringval>e
%type <stringval>t
%type <stringval>f

%start program

%%

program: e {printf("%s\n",$1);}

e : e PLUS t { $$ = concat(concat(" (PLUS +) ",$1,$3),"(e ",")");}
   |t { $$ = concat($1,"(e ",")"); }
   ;

t : t TIMES f {$$ = concat(concat(" (TIMES *) ",$1,$3),"(t ",")");}
   | f { $$ = concat($1,"(t ",")");}
   ;

f : LPAREN e RPAREN { $$ = concat($2,"(f (LPAREN \\() "," (RPAREN \\)))"); }
   | ID { $$ = concat($1,"(f (ID ","))"); }
   ;
%%

char* concat(char* id, char* strbegin, char* strend){
	result = malloc(strlen(id)+strlen(strbegin)+strlen(strend)+1);
	strcpy(result,strbegin);
	strcat(result,id);
	strcat(result,strend);
 	return result;
}


int main(){
  int val = yyparse();
  free(result);
  return(val >= 1 ? 1 : 0);
}