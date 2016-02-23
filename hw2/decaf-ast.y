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
		parent->numChildren++;
	} else {
		Node** children = (Node**) malloc(sizeof(Node*) * (parent->numChildren + 1));
		memcpy(children, parent->children, sizeof(Node*) * parent->numChildren);
		children[parent->numChildren] = childNode;
		free(parent->children);
		parent->children = children;
		parent->numChildren++;
	}
}

void printNode(Node* node) {
	printf("%s",node->pre_entry);
	int i;	
	for (i = 0; i < node->numChildren; ++i) {
		printNode(node->children[i]);
		if (i != node->numChildren - 1) {
			printf(",");
		} 
	}
	printf("%s",node->post_entry);
}

%}

%union {
	int rvalue; /* value of evaluated expression */
	int lvalue; /* index into symtbl for variable name */
	char* str_t;
	struct Node* node;	
}
%token T_STRINGTYPE T_VOID T_BOOLTYPE T_INTTYPE
%token T_CLASS T_EXTERN T_EXTENDS T_NEW T_RETURN
%token T_COMMA T_DOT T_SEMICOLON T_LPAREN T_RPAREN T_LCB T_RCB T_LSB T_RSB
%token T_BREAK T_CONTINUE T_IF T_ELSE  T_ASSIGN T_WHILE T_FOR
%token T_FALSE T_TRUE T_NULL 
%token T_NOT   
%token T_PLUS T_MINUS T_MULT T_DIV T_LEFTSHIFT T_RIGHTSHIFT T_MOD T_LT T_GT T_LEQ T_GEQ T_EQ T_NEQ T_AND T_OR 
%token T_CHARCONSTANT 

%token <str_t> T_ID T_INTCONSTANT T_STRINGCONSTANT

%type <node> class extern_list extern method_type extern_type_list extern_type decaf_type constant bool field_decl_list field_decl method_decl_list method_decl typed_symbol_list typed_symbol method_block array_decl method_call method_arg_list method_arg assign assign_list var_decl_list var_decl block
%type <node> statement_list statement expression bin_expr_1 bin_expr_2 bin_expr_3 bin_expr_4 bin_expr_5 expr_6 expr_7

%left T_PLUS T_MINUS T_MULT T_DIV T_LEFTSHIFT T_RIGHTSHIFT T_MOD T_LT T_GT T_LEQ T_GEQ T_EQ T_NEQ T_AND T_OR
%right T_NOT
%start program

%%

program: 	class { root = newNode("Program(None,", ")"); addChild(root, $1); printNode(root); }
			| extern_list class { root = newNode("Program(", ")"); addChild(root, $1); addChild(root, $2); printNode(root); }		
			;

class: 		T_CLASS T_ID T_LCB field_decl_list method_decl_list T_RCB {Node* node = newNode("Class(", ")"); addChild(node, newNode($2, "")); addChild(node, $4); addChild(node, $5); $$ = node;}
			| T_CLASS T_ID T_LCB field_decl_list T_RCB {Node* node = newNode("Class(", ",None)"); addChild(node, newNode($2, "")); addChild(node, $4); $$ = node;}
			| T_CLASS T_ID T_LCB method_decl_list T_RCB { Node* node = newNode("Class(", ")"); addChild(node, newNode($2, "")); addChild(node, newNode("None","")); addChild(node, $4); 
				$$ = node;}		
			| T_CLASS T_ID T_LCB T_RCB { Node* node = newNode("Class(", ",None,None)"); addChild(node, newNode($2, "")); $$ = node;}
			;		
		

extern_list: 	extern { $$ = $1; }
		| extern extern_list { Node* node = newNode("", ""); addChild(node, $1); addChild(node, $2); $$ = node; }
		;

extern: 	T_EXTERN method_type T_ID T_LPAREN extern_type_list T_RPAREN T_SEMICOLON { Node* node = newNode("ExternFunction(", ")"); addChild(node, newNode($3,"")); addChild(node, $2); 
				Node* varDefs = newNode("VarDef(",")"); addChild(varDefs, $5); addChild(node, varDefs); $$ = node; }
			| T_EXTERN method_type T_ID T_LPAREN T_RPAREN T_SEMICOLON { Node* node = newNode("ExternFunction(", ",None)"); addChild(node, newNode($3,"")); addChild(node, $2); $$ = node;}
			;

method_type: 	T_VOID { $$ = newNode("VoidType",""); }
		| T_INTTYPE { $$ = newNode("IntType",""); }
		| T_BOOLTYPE { $$ = newNode("BoolType",""); }
		;

extern_type_list: 	extern_type { $$ = $1; }
			| extern_type T_COMMA extern_type_list { Node* node = newNode("", ""); addChild(node, $1); addChild(node, $3); $$ =  node; }
			;

extern_type:	T_STRINGTYPE { $$ = newNode("StringType",""); }
		| decaf_type { Node* node = newNode("", ""); addChild(node, $1); $$ = node; }
		;

decaf_type:	T_INTTYPE { $$ = newNode("IntType",""); }
		| T_BOOLTYPE { $$ = newNode("BoolType",""); }
		;

constant:	T_INTCONSTANT {}
		| bool {}
		| T_CHARCONSTANT {}
		;

bool:		T_TRUE { $$ = newNode("True",""); }
		| T_FALSE { $$ = newNode("False","");}
		;

field_decl_list: 	field_decl { $$ = $1; }
			| field_decl field_decl_list { Node* node = newNode("", ""); addChild(node, $1); addChild(node, $2); $$ = node;}
			;

field_decl:	decaf_type T_ID T_SEMICOLON { Node* node = newNode("FieldDecl(",",Scalar)"); addChild(node, newNode($2,"")); addChild(node, $1); $$ = node; }
			| decaf_type T_ID array_decl T_SEMICOLON { Node* node = newNode("FieldDecl(",")"); addChild(node, newNode($2,"")); addChild(node, $1); addChild(node, $3); $$ = node;}
			;

array_decl:	T_LSB T_INTCONSTANT T_RSB { Node* node = newNode("Array(",")"); addChild(node, newNode($2,"")); $$ = node;}
			;

method_decl_list:	method_decl { $$ = $1; }
			| method_decl method_decl_list { Node* node = newNode("",""); addChild(node, $1); addChild(node, $2); $$ = node; }
			;

method_decl:	method_type T_ID T_LPAREN typed_symbol_list T_RPAREN method_block { Node* node = newNode("Method(",")"); addChild(node, newNode($2, "")); addChild(node, $1); addChild(node, $4); 
			addChild(node, $6); $$ = node;}
		| method_type T_ID T_LPAREN T_RPAREN method_block { Node* node = newNode("Method(",")"); addChild(node, newNode($2, "")); addChild(node, $1); addChild(node, $5); $$ = node;}		
		;

typed_symbol_list:	typed_symbol { $$ = $1; }
			| typed_symbol T_COMMA typed_symbol_list { Node* node = newNode("",""); addChild(node, $1); addChild(node, $3); $$ = node;}
			;

typed_symbol:	decaf_type T_ID { Node* node = newNode("VarDef(",")"); addChild(node,newNode($2,"")); addChild(node, $1); $$ = node; }
		;

method_block: 	T_LCB var_decl_list statement_list T_RCB { Node* node = newNode("MethodBlock(",")"); addChild(node, $2); addChild(node, $3); $$ = node; }
		| T_LCB statement_list T_RCB { Node* node = newNode("MethodBlock(None,",")"); addChild(node, $2); $$ = node; }
		| T_LCB var_decl_list T_RCB { Node* node = newNode("MethodBlock(",",None)"); addChild(node, $2); $$ = node; }
		| T_LCB T_RCB { $$ = newNode("MethodBlock(None,None)","");}
		;

var_decl_list:	var_decl { $$ = $1; }
		| var_decl var_decl_list { Node* node = newNode("",""); addChild(node, $1); addChild(node, $2); $$ = node;}
		;

var_decl:	decaf_type T_ID T_SEMICOLON { Node* node = newNode("VarDef(",")"); addChild(node,newNode($2,"")); addChild(node, $1); $$ = node; }
		;

statement_list:	statement { $$ = $1; }
		| statement statement_list { Node* node = newNode("",""); addChild(node,$1); addChild(node,$2); $$ = node;}
		;

statement:	T_BREAK T_SEMICOLON { $$ = newNode("BreakStmt",""); }
		| T_CONTINUE T_SEMICOLON { $$ = newNode("ContinueStmt",""); }
		| method_call T_SEMICOLON { $$ = $1; }
		| T_RETURN T_SEMICOLON { $$ = newNode("ReturnStmt(None)",""); }
		| T_RETURN T_LPAREN T_RPAREN T_SEMICOLON { $$ = newNode("ReturnStmt(None)",""); }
		| T_RETURN T_LPAREN expression T_RPAREN T_SEMICOLON { Node* node = newNode("ReturnStmt(",")"); addChild(node, $3); $$ = node; }
		| assign T_SEMICOLON { $$ = $1; }
		| T_WHILE T_LPAREN expression T_RPAREN block { Node* node = newNode("WhileStmt(",")"); addChild(node, $3); addChild(node, $5); $$ = node;}
		| T_FOR T_LPAREN assign_list T_SEMICOLON expression T_SEMICOLON assign_list T_RPAREN block { Node* node = newNode("ForStmt(",")"); addChild(node, $3); addChild(node, $5); 
			addChild(node, $7); addChild(node, $9); $$ = node; }
		;

assign_list:	assign { $$ = $1; }
		| assign T_COMMA assign_list { Node* node = newNode("",""); addChild(node,$1); addChild(node,$3); $$ = node;}
		;

assign:		T_ID T_ASSIGN expression { Node* node = newNode("AssignVar(",")"); addChild(node, newNode($1, "")); addChild(node, $3); $$ = node; }
		| T_ID T_LSB expression T_RSB T_ASSIGN expression { Node* node = newNode("AssignArrayLoc(",")"); addChild(node, newNode($1, "")); addChild(node, $3); addChild(node, $6); $$ = node; }
		;

block:		T_LCB var_decl_list statement_list T_RCB { Node* node = newNode("Block(",")"); addChild(node, $2); addChild(node, $3); $$ = node; }
		| T_LCB statement_list T_RCB { Node* node = newNode("Block(None,",")"); addChild(node, $2); $$ = node; }
		| T_LCB var_decl_list T_RCB { Node* node = newNode("Block(",",None)"); addChild(node, $2); $$ = node; }
		| T_LCB T_RCB { $$ = newNode("Block(None,None)","");}
		;

expression:	bin_expr_1 { $$ = $1; }
		;

bin_expr_1:	bin_expr_1 T_OR bin_expr_1 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Or","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_2 { $$ = $1; }
		;

bin_expr_2:	bin_expr_2 T_AND bin_expr_2 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("And","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 { $$ = $1; }
		;

bin_expr_3:	bin_expr_3 T_LT bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Lt","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 T_GT bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Gt","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 T_LEQ bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Leq","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 T_GEQ bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Geq","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 T_EQ bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Eq","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_3 T_NEQ bin_expr_3 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Neq","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_4 { $$ = $1; }
		;

bin_expr_4:	bin_expr_4 T_PLUS bin_expr_4 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Plus","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_4 T_MINUS bin_expr_4 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Minus","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_5 { $$ = $1; }
		;

bin_expr_5:	bin_expr_5 T_MULT bin_expr_5 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Mult","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_5 T_DIV bin_expr_5 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Div","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_5 T_LEFTSHIFT bin_expr_5 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Leftshift","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_5 T_RIGHTSHIFT bin_expr_5 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Rightshift","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| bin_expr_5 T_MOD bin_expr_5 { Node* node = newNode("BinaryExpr(",")"); addChild(node, newNode("Mod","")); addChild(node, $1); addChild(node, $3); $$ = node; }
		| expr_6 { $$ = $1; }
		;

expr_6:		T_NOT expr_6 { Node* node = newNode("UnaryExpr(",")"); addChild(node, newNode("Not","")); addChild(node, $2); $$ = node; }
		| T_MINUS expr_6 { Node* node = newNode("UnaryExpr(",")"); addChild(node, newNode("UnaryMinus","")); addChild(node, $2); $$ = node; }
		| expr_7 { $$ = $1; }
		;

expr_7:		T_LPAREN expression T_RPAREN { $$ = $2; }
		| T_ID { Node* node = newNode("VariableExpr(",")");  addChild(node, newNode($1,"")); $$ = node; }
		| T_ID T_LSB expression T_RSB { Node* node = newNode("ArrayLocExpr(",")");  addChild(node, newNode($1,"")); addChild(node, $3); $$ = node;}
		| method_call { $$ = $1; }
		| T_INTCONSTANT { 
			Node* node = NULL;
			char* number = $1;
			if (number[0] == '-') {
				node = newNode("UnaryExpr(UnaryMinus,Number(","))"); 
				char* positiveNum = (char*) malloc(sizeof(char) * (strlen(number) - 1));
				memcpy(positiveNum, number + 1, strlen(number));
				addChild(node, newNode(positiveNum,"")); 			
			} else {
				node = newNode("Number(",")"); 
				addChild(node, newNode(number,"")); 
			}
			
			$$ = node; 
		}
		| bool { Node* node = newNode("BoolExpr(",")"); addChild(node, $1); $$ = node; }
		;

method_call: 	T_ID T_LPAREN method_arg_list T_RPAREN { Node* node = newNode("MethodCall(",")"); addChild(node, newNode($1,"")); addChild(node, $3); $$ = node; }
		| T_ID T_LPAREN T_RPAREN { Node* node = newNode("MethodCall(",",None)"); addChild(node, newNode($1,"")); $$ = node; }
		;

method_arg_list:	method_arg { $$ = $1; }
			| method_arg T_COMMA method_arg_list { Node* node = newNode("",""); addChild(node, $1); addChild(node, $3); $$ = node;}
			;

method_arg:	T_STRINGCONSTANT { Node* node = newNode("StringConstant(",")"); addChild(node, newNode($1, "")); $$ = node; }
        	| expression { $$ = $1; }
		;

%%


