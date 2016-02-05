%{
#include <stdio.h>
#include <stdbool.h>
int symtbl[26];
bool issym[26];
%}

%union {
  int rvalue; /* value of evaluated expression */
  int lvalue; /* index into symtbl for variable name */
}

%token <rvalue> INTEGER 
%token <lvalue> VARIABLE 
%token NEWLINE

%type <rvalue> expression

%left '-' '+' '=' 

%%

statements: statement| statement NEWLINE | statements statement NEWLINE |  statement statements  ;


statement: expression  { printf("%d\n", $1); }
         | VARIABLE '=' expression { symtbl[$1] = $3; issym[$1] = true; }
         ;

expression: INTEGER 
	 | VARIABLE                 { $$ = symtbl[$1]; }
	 | expression '+' INTEGER   { $$ = $1 + $3; }
         | expression '-' INTEGER   { $$ = $1 - $3; } 
	 | expression '+' VARIABLE   { $$ = $1 + symtbl[$3] ;}
         | expression '-' VARIABLE   { $$ = $1 - symtbl[$3]; }
         ;
%%

