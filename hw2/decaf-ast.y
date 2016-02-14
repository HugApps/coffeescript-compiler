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
%token T_STRINGTYPE T_VOID T_BOOLTYPE T_INTTYPE
%token T_CLASS T_EXTERN T_EXTENDS T_NEW T_RETURN
%token T_COMMA T_DOT T_SEMICOLON T_LPAREN T_RPAREN T_LCB T_RCB T_LSB T_RSB
%token T_BREAK T_CONTINUE T_ELSE T_AND T_ASSIGN T_DIV T_EQ 
%token T_FALSE T_FOR T_MULT T_MOD T_GEQ T_GT T_IF T_NULL T_TRUE
%token T_WHILE T_LEFTSHIFT T_LEQ T_LT T_MINUS T_NEQ T_NOT T_OR T_PLUS T_RIGHTSHIFT
%token T_STRINGCONSTANT T_CHARCONSTANT 

%token <rvalue> T_INTCONSTANT
%token <lvalue> T_ID 


%%

program: 	class {}
		| extern_list class {}		
		;

extern_list: 	extern {}
		| extern extern_list {}
		;

extern: 	T_EXTERN method_type T_ID T_LPAREN extern_type_list T_RPAREN T_SEMICOLON {}
		;

class: 		T_CLASS T_ID T_LCB field_decl_list method_decl_list T_RCB {}
		;

method_type: 	T_VOID {}
		| decaf_type {}
		;

extern_type_list: 	extern_type {}
			| extern_type T_COMMA extern_type_list {}
			;

extern_type:	T_STRINGTYPE {}
		| decaf_type {}
		;

decaf_type:	T_INTTYPE {}
		| T_BOOLTYPE {}
		;

field_decl_list: 	field_decl {}
			| field_decl field_decl_list {}
			;

field_decl:	T_SEMICOLON {};

method_decl_list:	method_decl {}
			| method_decl method_decl_list {}
			;

method_decl:	T_SEMICOLON {};


%%

