%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>

char* result;
char* result2;
char buf[1000];
char* concat(char* id, char* strbegin, char* strend);
void yyerror(char *s);
void printing();
%}

%union {
char* stringval;
}

%token ID PLUS TIMES LPAREN RPAREN

%type <stringval>ID
%type <stringval>e
%type <stringval>t
%type <stringval>f
//%type <stringval>program

%start program

%%

program: e {printf("%s\n",$1);}

e : e PLUS t { $$ = concat(concat(" (PLUS +) ",$1,$3),"(e ",")");}
  | t { $$ = concat($1,"(e ",")"); }
   ;

t : t TIMES f {$$ = concat(concat(" (TIMES *) ",$1,$3),"(t ",")");}
  | f { $$ = concat($1,"(t ",")");}
   ;

f : LPAREN e RPAREN { $$ = concat($2,"(f (LPAREN \\() "," (RPAREN \\)))"); }
   | ID { $$ = concat($1,"(f (ID ","))"); }
   ;
%%

char* concat(char* id, char* strbegin, char* strend){
	//printf("Id:%s begin:%s end:%s",id,strbegin,strend);
	result = malloc(strlen(id)+strlen(strbegin)+strlen(strend)+1);
	strcpy(result,strbegin);
	strcat(result,id);
	strcat(result,strend);
  strcpy(buf,result);
 	return result;
}

void printing(){
  printf("%s\n",buf);
}

/*void yyerror(char *error){
  extern char *yytext;
  extern int yylineno;
  fprintf(stderr, "ERROR: %s at symbol '%s' on line %d\n", error, yytext, yylineno);
}*/

int main(){
	yyparse();
	free(result);
	return 0;
}