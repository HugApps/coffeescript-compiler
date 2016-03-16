%{
#include <iostream>
#include <ostream>
#include <string>
#include <cstdlib>
#include "decafast-defs.h"
#include "ast.cpp"


int yylex(void);
int yyerror(char *);

using namespace std;
using namespace AST;

// Head Scope


bool printAST = true;
Node* root = NULL;

%}

%union{
    class Node* node;
    std::string* sval;
    int decaftype;
 }

%token T_AND T_ASSIGN T_BREAK T_CLASS T_COMMENT T_COMMA T_CONTINUE T_DIV T_DOT T_ELSE T_EQ T_EXTENDS T_EXTERN
%token T_FOR T_GEQ T_GT T_IF T_LCB T_LEFTSHIFT T_LEQ T_LPAREN T_LSB T_LT T_MINUS T_MOD T_MULT T_NEQ T_NEW T_NOT
%token T_NULL T_OR T_PLUS T_RCB T_RETURN T_RIGHTSHIFT T_RPAREN T_RSB T_SEMICOLON T_STRINGTYPE
%token T_VOID T_WHILE T_WHITESPACE
%token T_INTTYPE T_BOOLTYPE

%token <sval> T_ID T_STRINGCONSTANT T_CHARCONSTANT T_INTCONSTANT T_FALSE T_TRUE

%type <node> type method_type extern_type
%type <node> rvalue expr constant bool_constant method_call method_arg method_arg_list assign assign_comma_list
%type <node> block method_block statement statement_list var_decl_list var_decl var_list param_list param_comma_list
%type <node> method_decl method_decl_list field_decl_list field_decl field_list extern_type_list extern_defn
%type <node> extern_list decafclass

%left T_OR
%left T_AND
%left T_EQ T_NEQ T_LT T_LEQ T_GEQ T_GT
%left T_PLUS T_MINUS
%left T_MULT T_DIV T_MOD T_LEFTSHIFT T_RIGHTSHIFT
%left T_NOT
%right UMINUS

%%

start: program

program: extern_list decafclass
    {
    	root = new ProgramNode();
        root->addChild($1);       	
        root->addChild($2);

	printf("%s\n", root->toString().c_str());
    }

extern_list: extern_list extern_defn
    { $$ = new Node(); $$->addChild($1); $$->addChild($2); }
    | /* extern_list can be empty */
    { $$ = NULL; }
    ;

extern_defn: T_EXTERN method_type T_ID T_LPAREN extern_type_list T_RPAREN T_SEMICOLON
    { $$ = new ExternNode(); $$->addChild($2); $$->addChild(new Node(ID, $3)); $$->addChild($5); }
    | T_EXTERN method_type T_ID T_LPAREN T_RPAREN T_SEMICOLON
    { $$ = new ExternNode(); $$->addChild($2); $$->addChild(new Node(ID, $3)); }
    ;

extern_type_list: extern_type
    { $$ = $1; }
    | extern_type T_COMMA extern_type_list
    { $$ = new Node(); $$->addChild($1); $$->addChild($3); }
    ;

extern_type: T_STRINGTYPE
    { $$ = new Node(TYPE, "string"); }
    | type
    { $$ = $1; }
    ;

decafclass: T_CLASS T_ID T_LCB field_decl_list method_decl_list T_RCB
    { $$ = new ClassNode(); $$->addChild(new Node(ID, $2)); $$->addChild($4); $$->addChild($5); }
    | T_CLASS T_ID T_LCB field_decl_list T_RCB
    { $$ = new ClassNode(); $$->addChild(new Node(ID, $2)); $$->addChild($4); }
    ;

field_decl_list: field_decl_list field_decl
    { $$ = new Node(); $$->addChild($1); $$->addChild($2); }
    | /* empty */
    { $$ = NULL; }
    ;

field_decl: field_list T_SEMICOLON
    { $$ = $1; }
    | type T_ID T_ASSIGN constant T_SEMICOLON
    { $$ = new FieldDeclNode(lineno); $$->addChild($1); $$->addChild(new Node(ID, $2)); $$->addChild($4); }
    ;

field_list: field_list T_COMMA T_ID
    { $$ = new Node(FIELD_DECL, lineno); $$->addChild($1);  $$->addChild(new Node(ID, $3));}
    | field_list T_COMMA T_ID T_LSB T_INTCONSTANT T_RSB
    { 
    	$$ = new Node(); $$->addChild($1); 
    	Node* node = new Node(FIELD_DECL_ARRAY, lineno); $$->addChild(new Node(ID, $3)); $$->addChild(new Node(CONSTANT, $5));
    	$$->addChild(node);
    }
    | type T_ID
    { $$ = new Node(FIELD_DECL, lineno); $$->addChild($1); $$->addChild(new Node(ID, $2)); }
    | type T_ID T_LSB T_INTCONSTANT T_RSB
    { $$ = new Node(FIELD_DECL_ARRAY, lineno); $$->addChild($1); $$->addChild(new Node(ID, $2)); $$->addChild(new Node(CONSTANT, $4));}
    ;

method_decl_list: method_decl_list method_decl
    { $$ = new Node(); $$->addChild($1); $$->addChild($2); }
    | method_decl
    { $$ = $1; }
    ;

method_decl: T_VOID T_ID T_LPAREN param_list T_RPAREN method_block
    { $$ = new MethodDeclNode(); $$->addChild(new Node(TYPE, "void")); $$->addChild(new Node(ID, $2)); $$->addChild($4); $$->addChild($6);  }
    | type T_ID T_LPAREN param_list T_RPAREN method_block
    { $$ = new MethodDeclNode(); $$->addChild($1); $$->addChild(new Node(ID, $2)); $$->addChild($4); $$->addChild($6); }
    ;

method_type: T_VOID
    { $$ = new Node(TYPE, "void"); }
    | type
    { $$ = $1; }
    ;

param_list: param_comma_list
    { $$ = $1; }
    | /* empty */
    { $$ = NULL; }
    ;

param_comma_list: type T_ID T_COMMA param_comma_list
    { $$ = new Node(); Node* node = new Node(PARAM, lineno); node->addChild($1); node->addChild(new Node(ID, $2)); $$->addChild(node); $$->addChild($4);}
    | type T_ID
    { $$ = new Node(PARAM, lineno); $$->addChild($1); $$->addChild(new Node(ID, $2)); }
    ;

type: T_INTTYPE
    { $$ = new Node(TYPE, "int"); }
    | T_BOOLTYPE
    { $$ = new Node(TYPE, "bool"); }
    ;

block: T_LCB var_decl_list statement_list T_RCB
    { $$ = new Node(BLOCK); $$->addChild($2); $$->addChild($3); }

method_block: T_LCB var_decl_list statement_list T_RCB
    { $$ = new Node(BLOCK); $$->addChild($2); $$->addChild($3); }

var_decl_list: var_decl var_decl_list
    { $$ = new Node(); $$->addChild($1); $$->addChild($2); }
    | /* empty */
    { $$ = NULL; }
    ;

var_decl: var_list T_SEMICOLON
    { $$ = $1; }

var_list: var_list T_COMMA T_ID
    { $$ = new Node(); $$->addChild($1); $$->addChild(new Node(ID, $3)); }
    | type T_ID
    { $$ = new Node(); $$->addChild($1); $$->addChild(new Node(ID, $2)); }
    ;

statement_list: statement statement_list
    { $$ = new Node(); $$->addChild($1); $$->addChild($2); }
    | /* empty */
    { $$ = NULL; }
    ;

statement: assign T_SEMICOLON
    { $$ = $1; }
    | method_call T_SEMICOLON
    { $$ = $1; }
    | T_IF T_LPAREN expr T_RPAREN block T_ELSE block
    { $$ = new Node(IF_STATEMENT); $$->addChild($3); $$->addChild($5); $$->addChild($7);}
    | T_IF T_LPAREN expr T_RPAREN block
    { $$ = new Node(IF_STATEMENT); $$->addChild($3); $$->addChild($5); }
    | T_WHILE T_LPAREN expr T_RPAREN block
    { $$ = new Node(WHILE_STATEMENT); $$->addChild($3); $$->addChild($5); }
    | T_FOR T_LPAREN assign_comma_list T_SEMICOLON expr T_SEMICOLON assign_comma_list T_RPAREN block
    { $$ = new Node(FOR_STATEMENT); $$->addChild($3); $$->addChild($5); $$->addChild($7); $$->addChild($9); }
    | T_RETURN T_LPAREN expr T_RPAREN T_SEMICOLON
    { $$ = new Node(RETURN_STATEMENT); $$->addChild($3); }
    | T_RETURN T_LPAREN T_RPAREN T_SEMICOLON
    { $$ = new Node(RETURN_STATEMENT); }
    | T_RETURN T_SEMICOLON
    { $$ = new Node(RETURN_STATEMENT); }
    | T_BREAK T_SEMICOLON
    { $$ = new Node(BREAK_STATEMENT); }
    | T_CONTINUE T_SEMICOLON
    { $$ = new Node(CONTINUE_STATEMENT); }
    | block
    { $$ = $1; }
    ;

assign: T_ID T_ASSIGN expr
    { $$ = new Node(ASSIGN_STATEMENT); $$->addChild(new Node(ID, $1)); $$->addChild($3); }
    | T_ID T_LSB expr T_RSB T_ASSIGN expr
    { $$ = new Node(ASSIGN_STATEMENT); $$->addChild(new Node(ID, $1)); $$->addChild($3); $$->addChild($6); }
    ;

method_call: T_ID T_LPAREN method_arg_list T_RPAREN
    { $$ = new Node(METHOD_CALL); $$->addChild(new Node(ID, $1)); $$->addChild($3); }
    | T_ID T_LPAREN T_RPAREN
    { $$ = new Node(METHOD_CALL); $$->addChild(new Node(ID, $1)); }
    ;

method_arg_list: method_arg
    { $$ = $1; }
    | method_arg T_COMMA method_arg_list
    { $$ = new Node(); $$->addChild($1); $$->addChild($3); }
    ;

method_arg: expr
    { $$ = $1; }
    | T_STRINGCONSTANT
    { $$ = new Node(CONSTANT, $1); }
    ;

assign_comma_list: assign
    { $$ = $1; }
    | assign T_COMMA assign_comma_list
    { $$ = new Node(); $$->addChild($1); $$->addChild($3); }
    ;

rvalue: T_ID
    { $$ = new Node(); $$->addChild(new Node(ID, $1)); }
    | T_ID T_LSB expr T_RSB
    { $$ = new Node(); $$->addChild(new Node(ID, $1)); $$->addChild($3); }
    ;

expr: rvalue
    { $$ = $1; }
    | method_call
    { $$ = $1; }
    | constant
    { $$ = $1; }
    | expr T_PLUS expr
    { $$ = new Node(BINARY_EXPR, "+"); $$->addChild($1); $$->addChild($3); }
    | expr T_MINUS expr
    { $$ = new Node(BINARY_EXPR, "-"); $$->addChild($1); $$->addChild($3); }
    | expr T_MULT expr
    { $$ = new Node(BINARY_EXPR, "*"); $$->addChild($1); $$->addChild($3); }
    | expr T_DIV expr
    { $$ = new Node(BINARY_EXPR, "//"); $$->addChild($1); $$->addChild($3); }
    | expr T_LEFTSHIFT expr
    { $$ = new Node(BINARY_EXPR, "<<"); $$->addChild($1); $$->addChild($3); }
    | expr T_RIGHTSHIFT expr
    { $$ = new Node(BINARY_EXPR, ">>"); $$->addChild($1); $$->addChild($3); }
    | expr T_MOD expr
    { $$ = new Node(BINARY_EXPR, "%"); $$->addChild($1); $$->addChild($3); }
    | expr T_LT expr
    { $$ = new Node(BINARY_EXPR, "<"); $$->addChild($1); $$->addChild($3); }
    | expr T_GT expr
    {$$ = new Node(BINARY_EXPR, ">"); $$->addChild($1); $$->addChild($3); }
    | expr T_LEQ expr
    { $$ = new Node(BINARY_EXPR, "<="); $$->addChild($1); $$->addChild($3); }
    | expr T_GEQ expr
    { $$ = new Node(BINARY_EXPR, ">="); $$->addChild($1); $$->addChild($3); }
    | expr T_EQ expr
    { $$ = new Node(BINARY_EXPR, "="); $$->addChild($1); $$->addChild($3); }
    | expr T_NEQ expr
    { $$ = new Node(BINARY_EXPR, "!="); $$->addChild($1); $$->addChild($3); }
    | expr T_AND expr
    { $$ = new Node(BINARY_EXPR, "&&"); $$->addChild($1); $$->addChild($3); }
    | expr T_OR expr
    { $$ = new Node(BINARY_EXPR, "||"); $$->addChild($1); $$->addChild($3); }
    | T_MINUS expr %prec UMINUS
    { $$ = new Node(UNARY_EXPR, "-"); $$->addChild($2); }
    | T_NOT expr
    { $$ = new Node(UNARY_EXPR, "!"); $$->addChild($2); }
    | T_LPAREN expr T_RPAREN
    { $$ = $2; }
    ;

constant: T_INTCONSTANT
    { $$ = new Node(CONSTANT, $1); }
    | T_CHARCONSTANT
    { $$ = new Node(CONSTANT, $1); }
    | bool_constant
    { $$ = $1; }
    ;

bool_constant: T_TRUE
    { $$ = new Node(CONSTANT, "true"); }
    | T_FALSE
    { $$ = new Node(CONSTANT, "false"); }
    ;

%%

int main() {
  // Intialize LLVM module
  //LLVMContext &Context = getGlobalContext();
  //TheModule = new Module("?",Context);
  // parse the input and create the abstract syntax tree
  int retval = yyparse();
  return(retval >= 1 ? 1 : 0);
}
