%{ 
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
char* result;
char* test(char* s1, char* s2);
char* f_IDConcat(char* id);
char* t_fConcat(char* id);
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

%start e

%%

e : e PLUS t { printf("(e (%s plus %s))",$1,$3);}
   | t { printf("(e %s)",$$); }
   ;

t : e TIMES f { printf("times"); }
   | f { $$ = t_fConcat($1); }
   ;

f : LPAREN e RPAREN { printf("paren"); }
   | ID { $$ =f_IDConcat($1);}
   ;

%%

char* f_IDConcat(char* id){
	char fIDstringBegin[] = "(f (ID ";
	char fIDstringEnd[] = "))";
	result = malloc(strlen(id)+strlen(fIDstringBegin)+strlen(fIDstringEnd)+1);
	//printf("in test: %s", id);
	strcpy(result,fIDstringBegin);
	strcat(result,id);
	strcat(result,fIDstringEnd);
	//printf("result %s",result);
   	return result;
}

char* t_fConcat(char* id){
	char stringBegin[] = "(t ";
	char stringEnd[] = ")";
	result = malloc(strlen(id)+strlen(stringBegin)+strlen(stringEnd)+1);
	//printf("in test: %s", id);
	strcpy(result,stringBegin);
	strcat(result,id);
	strcat(result,stringEnd);
	//printf("result %s",result);
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