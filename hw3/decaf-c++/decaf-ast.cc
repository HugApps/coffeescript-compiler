
#include "decafast-defs.h"
#include <list>
#include <ostream>
#include <iostream>
#include <sstream>

#ifndef YYTOKENTYPE
#include "decaf-ast.tab.h"
#endif

using namespace std;

typedef enum { voidTy, intTy, boolTy, stringTy, } decafType;

string TyString(decafType x) {
	switch (x) {
		case voidTy: return string("void");
		case intTy: return string("int");
		case boolTy: return string("bool");
		case stringTy: return string("string");
		default: throw runtime_error("unknown type in TyString call");
	}
}

string BinaryOpString(int Op) {
	switch (Op) {
		case T_PLUS: return string("Plus");
  		case T_MINUS: return string("Minus");
  		case T_MULT: return string("Mult");
  		case T_DIV: return string("Div");
  		case T_LEFTSHIFT: return string("Leftshift");
  		case T_RIGHTSHIFT: return string("Rightshift");
  		case T_MOD: return string("Mod");
  		case T_LT: return string("Lt");
  		case T_GT: return string("Gt");
  		case T_LEQ: return string("Leq");
  		case T_GEQ: return string("Geq");
  		case T_EQ: return string("Eq");
  		case T_NEQ: return string("Neq");
  		case T_AND: return string("And");
  		case T_OR: return string("Or");
		default: throw runtime_error("unknown type in BinaryOpString call");
	}
}

string UnaryOpString(int Op) {
	switch (Op) {
  		case T_MINUS: return string("UnaryMinus");
  		case T_NOT: return string("Not");
		default: throw runtime_error("unknown type in UnaryOpString call");
	}
}

string convertInt(int number) {
	stringstream ss;
	ss << number;
	return ss.str();
}

/// decafAST - Base class for all abstract syntax tree nodes.
class decafAST {
public:
  virtual ~decafAST() {}
  virtual string str() { return string(""); }
};

string getString(decafAST *d) {
	if (d != NULL) {
		return d->str();
	} else {
		return string("None");
	}
}

string buildString1(const char *Name, decafAST *a) {
	return string(Name) + "" + getString(a);
}

string buildString1(const char *Name, string a) {
	return string(Name) + "" + a ;
}

string buildString2(const char *Name, decafAST *a, decafAST *b) {
	return string(Name) + "(" + getString(a) + "," + getString(b) + ")";
}

string buildString2(const char *Name, string a, decafAST *b) {
	return string(Name) + "(" + a + "," + getString(b) + ")";
}

string buildString2(const char *Name, string a, string b) {
	return string(Name) + "(" + a + "," + b + ")";
}

string buildString2(string a, string b, decafAST *c) {
	return a + b + getString(c);
}

string buildString3(const char *Name, decafAST *a, decafAST *b, decafAST *c) {
	return string(Name) + "(" + getString(a) + "," + getString(b) + "," + getString(c) + ")";
}

string buildString3(const char *Name, string a, decafAST *b, decafAST *c) {
	return string(Name) + "(" + a + "," + getString(b) + "," + getString(c) + ")";
}

string buildString3(const char *Name, string a, string b, decafAST *c) {
	return string(Name) + "(" + a + "," + b + "," + getString(c) + ")";
}

string buildString3(const char *Name, string a, string b, string c) {
	return string(Name) + "(" + a + "," + b + "," + c + ")";
}

string buildString3(string a, string b, decafAST *c, string d) {
	return a + b + getString(c) + d;
}

string buildString3(decafType Ty, string cm ,string a, string cmm ,string b, string cmmm, decafAST *c, string d) {
	return TyString(Ty) + cm + a + cmm+ b + cmmm+ getString(c) + d;
}

string buildString4(const char *Name, string a, decafAST *b, decafAST *c, decafAST *d) {
	return string(Name) + "(" + a + "," + getString(b) + "," + getString(c) + "," + getString(d) + ")";
}

string buildString4(const char *Name, string a, string b, decafAST *c, decafAST *d) {
	return string(Name) + "(" + a + "," + b + "," + getString(c) + "," + getString(d) + ")";
}

string buildString4(const char *Name, decafAST *a, decafAST *b, decafAST *c, decafAST *d) {
	return string(Name) + "(" + getString(a) + "," + getString(b) + "," + getString(c) + "," + getString(d) + ")";
}

template <class T>
string commaList(list<T> vec, bool isType) {
	string s("");
	for (typename list<T>::iterator i = vec.begin(); i != vec.end(); i++) {
		s = s + (s.empty() ? string("") : string(isType ? "!!!!!!!!!!!!" : "\n")) + (*i)->str();
	}
	if (s.empty()) {
		s = string("None");
	}
	return s;
}

class TypedSymbol {
	string Sym;
	decafType Ty;
public:
	TypedSymbol(string s, decafType t) : Sym(s), Ty(t) {}
	string str() {
		if (Sym.empty()) {
			return "VarDef(" + TyString(Ty) + ")"; //Dunno about this...
		} else {
			return TyString(Ty) + " " + Sym;
		}
	}
	//virtual string getName();
};

class TypedSymbolListAST : public decafAST {
	list<class TypedSymbol *> arglist;
	decafType listType; // this variable is used if all the symbols in the list share the same type
private:
    bool isType;

public:
	TypedSymbolListAST() {}
	TypedSymbolListAST(string sym, decafType ty) {
		TypedSymbol *s = new TypedSymbol(sym, ty);
		arglist.push_front(s);
		listType = ty;
	}
	~TypedSymbolListAST() {
		for (list<class TypedSymbol *>::iterator i = arglist.begin(); i != arglist.end(); i++) {
			delete *i;
		}
	}
	void push_front(string sym, decafType ty) {
		TypedSymbol *s = new TypedSymbol(sym, ty);
		arglist.push_front(s);
	}
	void push_back(string sym, decafType ty) {
		TypedSymbol *s = new TypedSymbol(sym, ty);
		arglist.push_back(s);
	}
	void new_sym(string sym) {
		if (arglist.empty()) {
			throw runtime_error("Error in AST creation: insertion into empty typed symbol list\n");
		}
		TypedSymbol *s = new TypedSymbol(sym, listType);
		arglist.push_back(s);
	}
	void setType(bool type){
        this->isType = type;
	}
	string str() { return commaList<class TypedSymbol *>(arglist,isType); }
};

/// decafStmtList - List of Decaf statements
class decafStmtList : public decafAST {
	list<decafAST *> stmts;

private:
    bool isType;
public:
	decafStmtList() {}
	~decafStmtList() {
		for (list<decafAST *>::iterator i = stmts.begin(); i != stmts.end(); i++) {
			delete *i;
		}
	}
	int size() { return stmts.size(); }
	void push_front(decafAST *e) { stmts.push_front(e); }
	void push_back(decafAST *e) { stmts.push_back(e); }
	void setType(bool type){
        this->isType = type;
        //printf("istype value: %d \n",type);
	}
	string str() { /*printf("indecafstatmentlist %d \n", isType);*/ return commaList<class decafAST *>(stmts,isType); }
};

/// NumberExprAST - Expression class for integer numeric literals like "12".
class NumberExprAST : public decafAST {
	int Val;
public:
	NumberExprAST(int val) : Val(val) {}
	string str() { return buildString1("", convertInt(Val)); }
};

/// StringConstAST - string constant
class StringConstAST : public decafAST {
	string StringConst;
public:
	StringConstAST(string s) : StringConst(s) {}
	string str() { return buildString1("StringConstant", "\"" + StringConst + "\""); }
};

/// BoolExprAST - Expression class for boolean literals: "true" and "false".
class BoolExprAST : public decafAST {
	bool Val;
public:
	BoolExprAST(bool val) : Val(val) {}
	string str() { return buildString1("", Val ? string("true") : string("false")); }
};

/// VariableExprAST - Expression class for variables like "a".
class VariableExprAST : public decafAST {
	string Name;
public:
	VariableExprAST(string name) : Name(name) {}
	string str() { return buildString1("VariableExpr", Name); }
	//const std::string &getName() const { return Name; }
};

/// MethodCallAST - call a function with some arguments
class MethodCallAST : public decafAST {
	string Name;
	decafStmtList *Args;
public:
	MethodCallAST(string name, decafStmtList *args) : Name(name), Args(args) {/*printf("in method call ast\n");*/ if(Args != NULL) Args->setType(true);}
	~MethodCallAST() { delete Args; }
	string str() { return buildString2("MethodCall", Name, Args); }
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public decafAST {
	int Op; // use the token value of the operator
	decafAST *LHS, *RHS;
public:
	BinaryExprAST(int op, decafAST *lhs, decafAST *rhs) : Op(op), LHS(lhs), RHS(rhs) {}
	~BinaryExprAST() { delete LHS; delete RHS; }
	string str() { return buildString3("BinaryExpr", BinaryOpString(Op), LHS, RHS); }
};

/// UnaryExprAST - Expression class for a unary operator.
class UnaryExprAST : public decafAST {
	int Op; // use the token value of the operator
	decafAST *Expr;
public:
	UnaryExprAST(int op, decafAST *expr) : Op(op), Expr(expr) {}
	~UnaryExprAST() { delete Expr; }
	string str() { return buildString2("UnaryExpr", UnaryOpString(Op), Expr); }
};

/// AssignVarAST - assign value to a variable
/// Should insert variable value, key into current symbol table
class AssignVarAST : public decafAST {
	string Name; // location to assign value
	decafAST *Value;
public:
	AssignVarAST(string name, decafAST *value) : Name(name), Value(value) {}
	~AssignVarAST() {
		if (Value != NULL) { delete Value; }
	}
	string str() { return buildString3(Name, " = ", Value, ";"); }
};

/// AssignArrayLocAST - assign value to a variable
class AssignArrayLocAST : public decafAST {
	string Name; // name of array variable
    decafAST *Index;  // index for assignment of value
	decafAST *Value;
public:
	AssignArrayLocAST(string name, decafAST *index, decafAST *value) : Name(name), Index(index), Value(value) {}
	~AssignArrayLocAST() { delete Index; delete Value; }
	string str() { return buildString3("AssignArrayLoc", Name, Index, Value); }
};

/// ArrayLocExprAST - access an array location
class ArrayLocExprAST : public decafAST {
	string Name;
    decafAST *Expr;
public:
	ArrayLocExprAST(string name, decafAST *expr) : Name(name), Expr(expr) {}
	~ArrayLocExprAST() {
		if (Expr != NULL) { delete Expr; }
	}
	string str() { return buildString2("ArrayLocExpr", Name, Expr); }
};

/// BlockAST - block
class BlockAST : public decafAST {
	decafStmtList *Vars;
	decafStmtList *Statements;
public:
	BlockAST(decafStmtList *vars, decafStmtList *s) : Vars(vars), Statements(s) {if(Vars != NULL) Vars->setType(false); if(Statements != NULL) Statements->setType(false);}
	~BlockAST() {
		if (Vars != NULL) { delete Vars; }
		if (Statements != NULL) { delete Statements; }
	}
	decafStmtList *getVars() { return Vars; }
	decafStmtList *getStatements() { return Statements; }
	string str() { return buildString2("Block", Vars, Statements); }
};

/// MethodBlockAST - block for methods
class MethodBlockAST : public decafAST {
	decafStmtList *Vars;
	decafStmtList *Statements;
public:
	MethodBlockAST(decafStmtList *vars, decafStmtList *s) : Vars(vars), Statements(s) {if(Vars != NULL) Vars->setType(false); if(Statements != NULL) Statements->setType(false);}
	~MethodBlockAST() {
		if (Vars != NULL) { delete Vars; }
		if (Statements != NULL) { delete Statements; }
	}
	string str() { return buildString2("MethodBlock", Vars, Statements); }
};

/// IfStmtAST - if statement
class IfStmtAST : public decafAST {
	decafAST *Cond;
	BlockAST *IfTrueBlock;
	BlockAST *ElseBlock;
public:
	IfStmtAST(decafAST *cond, BlockAST *iftrue, BlockAST *elseblock) : Cond(cond), IfTrueBlock(iftrue), ElseBlock(elseblock) {}
	~IfStmtAST() {
		delete Cond;
		delete IfTrueBlock;
		if (ElseBlock != NULL) { delete ElseBlock; }
	}
	string str() { return buildString3("IfStmt", Cond, IfTrueBlock, ElseBlock); }
};

/// WhileStmtAST - while statement
class WhileStmtAST : public decafAST {
	decafAST *Cond;
	BlockAST *Body;
public:
	WhileStmtAST(decafAST *cond, BlockAST *body) : Cond(cond), Body(body) {}
	~WhileStmtAST() { delete Cond; delete Body; }
	string str() { return buildString2("WhileStmt", Cond, Body); }
};

/// ForStmtAST - for statement
class ForStmtAST : public decafAST {
	decafStmtList *InitList;
	decafAST *Cond;
	decafStmtList *LoopEndList;
	BlockAST *Body;
public:
	ForStmtAST(decafStmtList *init, decafAST *cond, decafStmtList *end, BlockAST *body) :
		InitList(init), Cond(cond), LoopEndList(end), Body(body) {if(InitList != NULL) InitList->setType(false); if(LoopEndList != NULL) LoopEndList->setType(false);}
	~ForStmtAST() {
		delete InitList;
		delete Cond;
		delete LoopEndList;
		delete Body;
	}
	string str() { return buildString4("ForStmt", InitList, Cond, LoopEndList, Body); }
};

/// ReturnStmtAST - return statement
class ReturnStmtAST : public decafAST {
	decafAST *Value;
public:
	ReturnStmtAST(decafAST *value) : Value(value) {}
	~ReturnStmtAST() {
		if (Value != NULL) { delete Value; }
	}
	string str() { return buildString1("ReturnStmt", Value); }
};

/// BreakStmtAST - break statement
class BreakStmtAST : public decafAST {
public:
	BreakStmtAST() {}
	string str() { return string("BreakStmt"); }
};

/// ContinueStmtAST - continue statement
class ContinueStmtAST : public decafAST {
public:
	ContinueStmtAST() {}
	string str() { return string("ContinueStmt"); }
};

/// MethodDeclAST - function definition
class MethodDeclAST : public decafAST {
	decafType ReturnType;
	string Name;
	TypedSymbolListAST *FunctionArgs;
	MethodBlockAST *Block;
public:
	MethodDeclAST(decafType rtype, string name, TypedSymbolListAST *fargs, MethodBlockAST *block)
		: ReturnType(rtype), Name(name), FunctionArgs(fargs), Block(block) { if(FunctionArgs != NULL) FunctionArgs->setType(true);}
	~MethodDeclAST() {
		delete FunctionArgs;
		delete Block;
	}
	string str() { return buildString4("Method", Name, TyString(ReturnType), FunctionArgs, Block); }
};

/// AssignGlobalVarAST - assign value to a global variablei
/// Add Variable to symbol table of root scope
class AssignGlobalVarAST : public decafAST {
	decafType Ty;
	string Name; // location to assign value
	decafAST *Value;
public:
	AssignGlobalVarAST(decafType ty, string name, decafAST *value) : Ty(ty), Name(name), Value(value) {}
	~AssignGlobalVarAST() {
		if (Value != NULL) { delete Value; }
	}
	string str() { return buildString3(Ty, " ", Name, " ","="," ", Value ,";"); }
};

/// FieldDecl - field declaration aka Decaf global variable
class FieldDecl : public decafAST {
	string Name;
	decafType Ty;
	int Size; // -1 for scalars and size value for arrays, size 0 array is an error
public:
	FieldDecl(string name, decafType ty, int size) : Name(name), Ty(ty), Size(size) {}
	string str() { return buildString3("FieldDecl", Name, TyString(Ty), (Size == -1) ? "Scalar" : "Array(" + convertInt(Size) + ")"); }
};

class FieldDeclListAST : public decafAST {
	list<class decafAST *> arglist;
	decafType listType; // this variable is used if all the symbols in the list share the same type

private:
    bool isType;

public:
	FieldDeclListAST() {}
	FieldDeclListAST(string sym, decafType ty, int sz) {
		FieldDecl *s = new FieldDecl(sym, ty, sz);
		arglist.push_front(s);
		listType = ty;
	}
	~FieldDeclListAST() {
		for (list<class decafAST *>::iterator i = arglist.begin(); i != arglist.end(); i++) {
			delete *i;
		}
	}
	void push_front(string sym, decafType ty, int sz) {
		FieldDecl *s = new FieldDecl(sym, ty, sz);
		arglist.push_front(s);
	}
	void push_back(string sym, decafType ty, int sz) {
		FieldDecl *s = new FieldDecl(sym, ty, sz);
		arglist.push_back(s);
	}
	void new_sym(string sym, int sz) {
		if (arglist.empty()) {
			throw runtime_error("Error in AST creation: insertion into empty field list\n");
		}
		FieldDecl *s = new FieldDecl(sym, listType, sz);
		arglist.push_back(s);
	}

	void setType(bool type){
        this->isType = type;
	}
	string str() { return commaList<class decafAST *>(arglist,isType); }
};

class ClassAST : public decafAST {
	string Name;
	FieldDeclListAST *FieldDeclList;
	decafStmtList *MethodDeclList;
public:
	ClassAST(string name, FieldDeclListAST *fieldlist, decafStmtList *methodlist)
		: Name(name), FieldDeclList(fieldlist), MethodDeclList(methodlist) { /*printf("in classast\n");*/ if(FieldDeclList != NULL) FieldDeclList->setType(false); if(MethodDeclList != NULL) MethodDeclList->setType(false);}
	~ClassAST() {
		if (FieldDeclList != NULL) { delete FieldDeclList; }
		if (MethodDeclList != NULL) { delete MethodDeclList; }
	}
	string str() { return buildString3("Class", Name, FieldDeclList, MethodDeclList); }
};

/// ExternAST - extern function definition
class ExternAST : public decafAST {
	decafType ReturnType;
	string Name;
	TypedSymbolListAST *FunctionArgs;
public:
	ExternAST(decafType r, string n, TypedSymbolListAST *fargs) : ReturnType(r), Name(n), FunctionArgs(fargs) {if (FunctionArgs != NULL) FunctionArgs->setType(true);}

	~ExternAST() {
	delete FunctionArgs;

	}
	string str() { return buildString3("ExternFunctione", Name, TyString(ReturnType), FunctionArgs); }
};

/// ProgramAST - the decaf program
/// Creates the roote scope and global symbol table
class ProgramAST : public decafAST {
	decafStmtList *ExternList;
	ClassAST *ClassDef;
public:
	ProgramAST(decafStmtList *externs, ClassAST *c) : ExternList(externs), ClassDef(c) {if (ExternList != NULL){ ExternList->setType(false);}}
	~ProgramAST() {
		if (ExternList != NULL) { delete ExternList; }
		if (ClassDef != NULL) { delete ClassDef; }
	}
	string str() { return buildString2("Program", ExternList, ClassDef); }
};

