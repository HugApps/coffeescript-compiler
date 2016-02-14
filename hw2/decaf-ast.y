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
%token T_BOOLTYPE T_BREAK T_CONTINUE T_CLASS T_ELSE T_EXTERN T_AND T_ASSIGN T_COMMA T_DIV T_DOT T_EQ T_EXTENDS
%token T_FALSE T_FOR T_INTTYPE T_MULT T_MOD T_GEQ T_GT T_RETURN T_IF T_NEW T_NULL T_STRINGTYPE T_TRUE
%token T_VOID T_WHILE T_LCB T_LEFTSHIFT T_LEQ T_LPAREN T_LSB T_LT T_MINUS T_NEQ T_NOT T_OR T_PLUS T_RCB T_RIGHTSHIFT T_RPAREN
%token T_RSB T_SEMICOLON T_STRINGCONSTANT T_CHARCONSTANT 

%token <rvalue> T_INTCONSTANT
%token <lvalue> T_ID 

%type <rvalue> expression

%%
statement: T_ID '=' expression { symtbl[$1] = $3; issym[$1] = true; }
         | expression  { printf("%d\n", $1); }
         ;

expression: expression '+' T_INTCONSTANT { $$ = $1 + $3; }
         | expression '-' T_INTCONSTANT { $$ = $1 - $3; }
         | T_INTCONSTANT { $$ = $1; }
         ;
%%

