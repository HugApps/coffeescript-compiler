%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#define Index 100
double  symb[Index];
int  IsSymbDouble[Index];
int  IsDouble =0;
int  IsExpressionDouble=0;
%}

%union { int  rvalue; double  dvalue; }

%token <dvalue> T_NUMBER
%token <dvalue> T_DOUBLE
%token <rvalue> T_NAME 
%token T_SQRT T_EXP

%type <dvalue> expression
%left '+' '-' T_LOG
%right '='

%%
statement_list: statement | statement '\n' | statement '\n' statement_list | statement_list statement ;

statement: expression {printf("%f\n", $1); IsExpressionDouble = 0 ;}
         |T_NAME '='  expression{ symb[$1]=$3; IsSymbDouble[$1]=IsExpressionDouble;  }
        ;

expression:  expression '+' T_NUMBER   { $$ = $1 + $3; IsDouble= 0; }
	   | expression '-' T_NUMBER   { $$ = $1 - $3; IsDouble= 0; }
	   | expression '+' T_DOUBLE   { $$ = $1 + $3; IsDouble= 1; }
	   | expression '-' T_DOUBLE   { $$ = $1 - $3; IsDouble= 1; }
           | expression '+' T_NAME     { $$ = $1 + symb[$3]; IsDouble= 1; }
           | expression '-' T_NAME     { $$ = $1 - symb[$3]; IsDouble= 1; }
           | T_NAME   { $$ = symb[$1]; IsDouble =IsSymbDouble[$1]; }
           | T_NUMBER  { $$ = $1; IsDouble= 0; }
           | T_DOUBLE  { $$ = $1; IsDouble= 1; }
           | '(' expression ')'  { $$ = $2 ; IsDouble = IsExpressionDouble;}  
           | T_EXP '(' expression ')'  { $$ = exp($3);}
           | T_SQRT '(' expression ')' { $$ = sqrt($3);}
           | T_LOG '(' expression ')'  { $$ = log($3);}
   ;
%%




