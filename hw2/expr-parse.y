%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
char* result;
char* test(char* s1, char* s2);
char* concat(char* id, char* strbegin, char* strend);
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

e : e PLUS t { printf("(e (%s plus %s))",$1,$3);}
   | t { $$ = concat($1,"(e ",")"); printf("%s",$$); }
   ;

t : e TIMES f { printf("times"); }
   | f { $$ = concat($1,"(t ",")");}
   ;

f : LPAREN e RPAREN { printf("paren"); }
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