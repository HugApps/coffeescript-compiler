%{
#define YYDEBUG 1
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

char* append(char* str1, char* str2) {
	size_t length = strlen(str1) + strlen(str2) + 1;
    char* final_str = (char*) malloc(length);
	strcat(strcat(final_str, str1), str2);
	return final_str;
}


typedef struct Node {
	char* pre_entry;
	char* post_entry;
	struct Node** children;
	int numChildren;
} Node;

Node* root = NULL;
Node* currNode = NULL;

Node* newNode(char* pre, char* post) {
	Node* node = (Node*) malloc(sizeof(struct Node));

	node->pre_entry = pre;
	node->post_entry = post;
	node->children = NULL;
	node->numChildren = 0;

	return node;
}

void addChild(Node* parent, Node* childNode) {
	if (parent->numChildren == 0) {
		parent->children = (Node**) malloc(sizeof(Node*));
		parent->children[0] = childNode;

	} else {
		Node** children = (Node**) malloc(sizeof(Node*) * (parent->numChildren + 1));
		memcpy(children, parent->children, sizeof(Node*) * parent->numChildren);
		children[parent->numChildren] = childNode;
		parent->numChildren++;
	}
}

void printNode(Node* node) {
	printf("%s",node->pre_entry);
	printf("%s",node->post_entry);
}

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

%type <str_t> class extern_list extern method_type extern_type_list extern_type decaf_type constant bool field_decl_list field_decl
%type <str_t> field_list field field_assign method_decl_list method_decl typed_symbol_list typed_symbol method_block
%type <str_t> statement_list statement expression

%start program

%%

program: 	class { root = newNode("Program(None,", ")"); printNode(root); }
		| extern_list class {printf("Class with extern\n");}		
		;

class: 		T_CLASS T_ID T_LCB field_decl_list method_decl_list T_RCB {}
		| T_CLASS T_ID T_LCB field_decl_list T_RCB {}
		| T_CLASS T_ID T_LCB method_decl_list T_RCB {}
		
		| T_CLASS T_ID T_LCB T_RCB {printf("Class %s\n", $2);}
		;		
		

extern_list: 	extern {printf("One extern\n");}
		| extern extern_list {printf("Extern list\n");}
		;

extern: 	T_EXTERN method_type T_ID T_LPAREN extern_type_list T_RPAREN T_SEMICOLON {printf("Extern method with params: %s\n", $3);}
		| T_EXTERN method_type T_ID T_LPAREN T_RPAREN T_SEMICOLON {printf("Extern method without params: %s\n", $3);}
		;

method_type: 	T_VOID {printf("Void method\n");}
		| decaf_type {printf("method returning a value");}
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


