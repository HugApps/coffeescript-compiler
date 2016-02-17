%{
#define YYDEBUG 1
#include <stdio.h>
#include <stdbool.h>
int symtbl[26];
bool issym[26];

%}

%union {
  int rvalue; /* value of evaluated expression */
  int lvalue; /* index into symtbl for variable name */
  char* str_t;
}
%token T_STRINGTYPE T_VOID T_BOOLTYPE T_INTTYPE
%token T_CLASS T_EXTERN T_EXTENDS T_NEW T_RETURN
%token T_COMMA T_DOT T_SEMICOLON T_LPAREN T_RPAREN T_LCB T_RCB T_LSB T_RSB
%token T_BREAK T_CONTINUE T_ELSE T_AND T_ASSIGN T_DIV T_EQ 
%token T_FALSE T_FOR T_MULT T_MOD T_GEQ T_GT T_IF T_NULL T_TRUE
%token T_WHILE T_LEFTSHIFT T_LEQ T_LT T_MINUS T_NEQ T_NOT T_OR T_PLUS T_RIGHTSHIFT
%token T_STRINGCONSTANT T_CHARCONSTANT 

%token <rvalue> T_INTCONSTANT
%token <str_t> T_ID 

%start program

%%

program: 	T_CLASS {printf("Class only\n");}
		| T_CLASS class {printf("Entering class\n");};

class: 		//T_CLASS T_ID T_LCB field_decl_list method_decl_list T_RCB {}
		//| T_CLASS T_ID T_LCB field_decl_list T_RCB {}
		//| T_CLASS T_ID T_LCB method_decl_list T_RCB {}
		
		T_ID T_LCB T_RCB {printf("Class %s\n", $1);}
		;
/*		
		| extern_list class {printf("Class with extern\n");}		
		;

extern_list: 	extern {}
		| extern extern_list {}
		;

extern: 	T_EXTERN method_type T_ID T_LPAREN extern_type_list T_RPAREN T_SEMICOLON {}
		| T_EXTERN method_type T_ID T_LPAREN T_RPAREN T_SEMICOLON {}
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

constant:	T_INTCONSTANT {}
		| bool {}
		| T_CHARCONSTANT {}
		;

bool:		T_TRUE {}
		| T_FALSE {}
		;

field_decl_list: 	field_decl {}
			| field_decl field_decl_list {}
			;

field_decl:	decaf_type field_list T_SEMICOLON {}
		| decaf_type field_assign T_SEMICOLON {}
		;

field_list:	field {}
		| field T_COMMA field_list {}
		;

field:		T_ID {}
		| T_ID T_LSB T_INTCONSTANT T_RSB {}
		;

field_assign:	T_ID T_EQ constant {}
		;

method_decl_list:	method_decl {}
			| method_decl method_decl_list {}
			;

method_decl:	method_type T_ID T_LPAREN typed_symbol_list T_RPAREN method_block {}
		method_type T_ID T_LPAREN T_RPAREN method_block {}		
		;

typed_symbol_list:	typed_symbol {}
			| typed_symbol T_COMMA typed_symbol_list {}
			;

typed_symbol:	decaf_type T_ID {}
		;

method_block: 	T_LCB typed_symbol_list statement_list T_RCB {}
		T_LCB statement_list T_RCB {}
		T_LCB typed_symbol_list T_RCB {}
		T_LCB T_RCB {}
		;

statement_list:	statement {}
		| statement statement_list {}
		;

statement:	T_SEMICOLON {};



expression:	T_SEMICOLON {};
*/
/*method_call: 	T_ID T_LPAREN method_arg_list T_RPAREN {}
		;

method_arg_list:	method_arg {}
			| method_arg T_COMMA method_arg_list {}
			;

method_arg:	T_STRINGCONSTANT {}
        	| expression {}
		;

binary_operator:	T_PLUS {}
			| T_MINUS {}
			| T_MULT {}
			| T_DIV {}
			| T_LEFTSHIFT {}
			| T_RIGHTSHIFT {}
			| T_MOD {}
			| T_LT {}
			| T_GT {}
			| T_LEQ {}
			| T_GEQ {}
			| T_EQ {}
			| T_NEQ {}
			| T_AND {}
			| T_OR {}
			;

unary_operator:		T_NOT {};
*/

%%

