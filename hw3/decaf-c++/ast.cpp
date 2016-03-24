#ifndef AST_H_
#define AST_H_

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sstream>
#include <vector>
#include "Scope.h"
#include "llvm-3.3/llvm/IR/IRBuilder.h"
#include "llvm-3.3/llvm/IR/LLVMContext.h"
#include "llvm-3.3/llvm/IR/Module.h"
#include "llvm-3.3/llvm/IR/DerivedTypes.h"
//#include "llvm-3.3/Analysis/Verifier.h"

//LLVM stuff
using namespace llvm;

static Module *TheModule;
static IRBuilder<> Builder(getGlobalContext());

std::string to_string(int num)
{
	std::ostringstream convert;
	convert << num;
	return convert.str();
}

char* append(char* str1, char* str2)
{
	size_t length = strlen(str1) + strlen(str2) + 1;
    	char* final_str = (char*) malloc(length);
	strcat(strcat(final_str, str1), str2);
	return final_str;
}


namespace AST
{
enum Type
{
	PROGRAM,
	EXTERN,
	CLASS,
	ID,
	TYPE,
	FIELD_DECL,
	FIELD_DECL_ARRAY,
	METHOD_DECL,
	METHOD_ARG,
	DECL,
	VAR_DECL,
	PARAM,
	CONSTANT,
	BLOCK,
	ASSIGN_STATEMENT,
	METHOD_CALL,
	IF_STATEMENT,
	WHILE_STATEMENT,
	FOR_STATEMENT,
	RETURN_STATEMENT,
	BREAK_STATEMENT,
	CONTINUE_STATEMENT,
	RVALUE,
	BINARY_EXPR,
	UNARY_EXPR,
	BRACKET_EXPR,
	LIST,
	LIST_NO_SPACES,
	NONE
};

static int currentBlockDepth = 0;

std::string indentation()
{
	std::string indent = "";
	for(int i = 0; i < currentBlockDepth * 4; i++)
	{
		indent += " ";
	}

	return indent;
}

class Node
{
	public:
		Node(Type type, std::string value) :
			type(type),
			value(value),
			lineNumber(-1)
		{
		}

		Node(Type type, std::string* value) :
			type(type),
			value(*value),
			lineNumber(-1)
		{
		}

		Node(Type type, int lineNum) :
			type(type),
			value(""),
			lineNumber(lineNum)
		{
		}

		Node(Type type) :
			type(type),
			value(""),
			lineNumber(-1)
		{
		}

		Node() :
			type(NONE),
			value(""),
			lineNumber(-1)
		{
		}

		~Node()
		{
		}

		virtual void generateSymbols()
		{
			for(int i = 0; i < children.size(); i++)
			{
				children[i]->generateSymbols();
			}
		}

		virtual std::string toString()
		{
			std::string nodeStr = "";
			std::string separator = "";

			if(type == LIST)
			{
				separator = ", ";
			}
			else if(type == LIST_NO_SPACES)
			{
				separator = ",";
			}

			for(int i = 0; i < children.size(); i++)
			{
				nodeStr += children[i]->toString();
				if(i != children.size() - 1)
				{
					nodeStr += separator;
				}
			}

			return nodeStr;
		}

        virtual Value* codegen()
        {

            return llvm::BasicBlock::Create(getGlobalContext(),"GeneralBlock",1,0);
        }

		void addChild(Node* child)
		{
			if(child != NULL)
			{
				children.push_back(child);
			}
		}

		Type type;
		int lineNumber;
		std::string value;
		std::vector<Node*> children;
};

void flattenList(Node* parent, Node* node)
{
	for(int i = 0; i < node->children.size(); i ++)
	{
		if(node->children[i]->type == LIST || node->children[i]->type == LIST_NO_SPACES)
		{
			flattenList(parent, node->children[i]);
		}
		else
		{
			parent->children.push_back(node->children[i]);
		}
	}
}

class ProgramNode : public Node
{
	public:
		ProgramNode() : Node(PROGRAM)
		{
		}

		std::string toString()
		{
			std::string nodeStr = "";
			for(int i = 0; i < children.size(); i++)
			{
				nodeStr += children[i]->toString() + "";
			}
			return nodeStr;
		}

};

class ExternNode : public Node
{
	public:
		ExternNode() : Node(EXTERN)
		{
		}

		std::string toString()
		{
			if(children.size() == 3)
			{
				return "extern " + children[0]->toString() + " " + children[1]->toString() + "(" + children[2]->toString() + ");\n";
			}
			else
			{
				return "extern " + children[0]->toString() + " " + children[1]->toString() + "(" + ");\n";
			}
		}
};

class ClassNode : public Node
{
	public:
		ClassNode() : Node(CLASS)
		{
		}

		void generateSymbols()
		{
			SCOPE::enterNewScope();
			Node::generateSymbols();
			SCOPE::leaveScope();
		}

		std::string toString()
		{
			SCOPE::enterScope();
			currentBlockDepth++;

			std::string nodeStr = "class " + children[0]->toString() + " {\n" + children[1]->toString();
			if(children.size() == 3)
			{
				nodeStr += children[2]->toString();
			}
			currentBlockDepth--;
			SCOPE::leaveScope();
			nodeStr += "}";
			return nodeStr;
		}

		// Gets the Inode string of
		std::string getClassName()
		{
			return children[0]->toString();
		}

		Value* codegen(){
			//TheModule = new Module(ClassNode::ClassName(),getGlobalContext());
			//BasicBlock* ClassBlock = BasicBlock::BasicBlock();
			//return ClassBlock;
			return NULL;
		}
};

class FieldDeclNode : public Node
{
	public:
		FieldDeclNode(int lineNumber) : Node(FIELD_DECL, lineNumber)
		{
		}

		void generateSymbols()
		{
			if(children.size() == 1)
			{
				SCOPE::addDefinition(children[0]->toString(), Symbol("", lineNumber));
			}
			else if(children.size() == 2)
			{
				SCOPE::addDefinition(children[1]->toString(), Symbol("", lineNumber));
			}
			else
			{
				SCOPE::addDefinition(children[1]->toString(), Symbol(children[2]->toString(), lineNumber));
			}
		}

		std::string toString()
		{
			if(children.size() == 1)
			{
				return children[0]->toString();
			}
			else if(children.size() == 2)
			{
				return children[0]->toString() + " " + children[1]->toString();
			}
			else
			{
				return children[0]->toString() + " " + children[1]->toString() + " = " + children[2]->toString();
			}
		}
};

class FieldArrayDeclNode : public Node
{
	public:
		FieldArrayDeclNode(int lineNumber) : Node(FIELD_DECL_ARRAY, lineNumber)
		{
		}

		void generateSymbols()
		{
			SCOPE::addDefinition(children[0]->toString(), Symbol("", lineNumber));
		}

		std::string toString()
		{
			if(children.size() == 3)
			{
				return children[0]->toString() + " " + children[1]->toString() + "[" + children[2]->toString() + "]";
			}
			else
			{
				return children[0]->toString()+ "[" + children[1]->toString() + "]";
			}
		}
};

class MethodDeclNode : public Node
{
	public:
		MethodDeclNode() : Node(METHOD_DECL)
		{
		}

		void generateSymbols()
		{
			SCOPE::enterNewScope();
			Node::generateSymbols();
			SCOPE::leaveScope();
		}

		std::string toString()
		{
			SCOPE::enterScope();
			std::string nodeStr = indentation() + children[0]->toString() + " " + children[1]->toString() + "(";
			if(children.size() == 4)
			{
				nodeStr += children[2]->toString();
				nodeStr += ") ";
				nodeStr += children[3]->toString();
			}
			else
			{
				nodeStr += ") ";
				nodeStr += children[2]->toString();
			}
			SCOPE::leaveScope();
			SCOPE::nextScope();
			return nodeStr;
		}
};

class TypeNode : public Node
{
public:
	TypeNode(std::string value) : Node(TYPE, value)
	{
	}

	TypeNode(std::string* value) : Node(TYPE, value)
	{
	}

	std::string toString()
	{
		return value;
	}

	Value* codegen()
	{
		return NULL;
	}

	static llvm::Type* getLLVMType(TypeNode* t) {
		 /*switch (t->value) {
		 	case "Void": return Builder.getVoidTy();
		 	case "int": return Builder.getInt32Ty();
		 	case "bool": return Builder.getInt1Ty();
		 	case "string": return Builder.getInt8PtrTy();
		  default: throw runtime_error("unknown type");*/
		 return NULL;
	 }

};

class IdNode : public Node
{
public:
	IdNode(std::string value) : Node(ID, value)
	{
	}

	IdNode(std::string* value) : Node(ID, value)
	{
	}

	std::string toString()
	{
		return value;
	}
};

class ConstantNode : public Node
{
public:
	ConstantNode(std::string value) : Node(CONSTANT, value)
	{
	}

	ConstantNode(std::string* value) : Node(CONSTANT, value)
	{
	}

	std::string toString()
	{
		return value;
	}

	Value* codegen() {


	//contents taken from LLVM cheat sheet
    const char *s = value.c_str();
    llvm::Value *GS =Builder.CreateGlobalString(s, "globalstring");
    return Builder.CreateConstGEP2_32(GS, 0, 0, "cast");




	}
};

class MethodParamNode : public Node
{
	public:
		MethodParamNode(int lineNumber) : Node(PARAM, lineNumber)
		{
		}

		void generateSymbols()
		{
			SCOPE::addDefinition(children[1]->toString(), Symbol("", lineNumber));
		}

		std::string toString()
		{
			return children[0]->toString() + " " + children[1]->toString();
		}
};

class BlockNode : public Node
{
	public:
		BlockNode() : Node(BLOCK), startOnNewLine(false)
		{
		}

		void generateSymbols()
		{
			SCOPE::enterNewScope();
			Node::generateSymbols();
			SCOPE::leaveScope();
		}

		std::string toString()
		{
			SCOPE::enterScope();

			std::string nodeStr = "";
			if(startOnNewLine)
			{
				nodeStr = indentation() + "{\n";
			}
			else
			{
				nodeStr = "{\n";
			}

			currentBlockDepth++;
			for(int i = 0; i < children.size(); i++)
			{
				nodeStr += children[i]->toString();
			}
			currentBlockDepth--;
			SCOPE::leaveScope();
			SCOPE::nextScope();
			nodeStr += indentation() + "}\n";

			return nodeStr;
		}

		bool startOnNewLine;
};

class DeclarationNode : public Node
{
	public:
		DeclarationNode(int lineNumber) : Node(DECL, lineNumber)
		{
		}

		std::string toString()
		{
			return indentation() + children[0]->toString() + ";\n";
		}
};


class VarDeclNode : public Node
{
	public:
		VarDeclNode(int lineNumber) : Node(VAR_DECL, lineNumber)
		{
		}

		void generateSymbols()
		{
			if(children.size() == 2)
			{
				SCOPE::addDefinition(children[1]->toString(), Symbol("", lineNumber));
			}
			else
			{
				SCOPE::addDefinition(children[0]->toString(), Symbol("", lineNumber));
			}
		}

		std::string toString()
		{
			if(children.size() == 2)
			{
				return children[0]->toString() + " " + children[1]->toString();
			}
			else
			{
				return children[0]->toString();
			}
		}

		Value* codegen(){
			//Value *V ; // Get from hash table
			// temp variable without hashtable
			/*Value *V = 10;
			if (!V){return ErrorV("unknown variable");

			}

			return Builder.CreateLoad(V,Name);*/
			return NULL;
		}
};

class AssignStatementNode : public Node
{
	public:
		AssignStatementNode() : Node(ASSIGN_STATEMENT)
		{
		}

		std::string toString()
		{
			std::string comment = "";
			if(SCOPE::containsDefinition(children[0]->toString()))
			{
				int lineNumber = SCOPE::getDefinition(children[0]->toString()).getLineNumber();
				comment = "// using decl on line: " + to_string(lineNumber);
			}

			if(children.size() == 2)
			{
				return indentation() + children[0]->toString() + " = " + children[1]->toString() + "; " + comment + "\n";
			}
			else
			{
				return indentation() + children[0]->toString() + "[" + children[1]->toString() + "] = " + children[2]->toString() + "; " + comment + "\n";
			}
		}
};

class MethodCallNode : public Node
{
	public:
		MethodCallNode() : Node(METHOD_CALL)
		{
		}

		std::string toString()
		{

			if(children.size() == 1)
			{
				return indentation() + children[0]->toString() + "();\n";
			}
			else
			{
				Node* list = new Node();
				flattenList(list, children[1]);

				std::string nodeStr = indentation() + children[0]->toString() + "(";
				if(list->children.size() == 1 && list->children[0]->type == ID)
				{
					std::string comment = "";
					if(SCOPE::containsDefinition(list->children[0]->toString()))
					{
						int lineNumber = SCOPE::getDefinition(list->children[0]->toString()).getLineNumber();
						comment = "// using decl on line: " + to_string(lineNumber);
					}

					nodeStr += list->children[0]->toString() + ") " + comment + ";\n";

					return nodeStr;
				}
				else if(list->children.size() == 3 && list->children[0]->type == RVALUE)
				{
					for(int i = 0; i < list->children.size(); i++)
					{
						std::string comment = "";
						if(SCOPE::containsDefinition(list->children[i]->toString()))
						{
							int lineNumber = SCOPE::getDefinition(list->children[i]->toString()).getLineNumber();
							comment = "// using decl on line: " + to_string(lineNumber);
						}

						if(i == 2)
						{
							nodeStr += list->children[i]->toString() + ") " + comment + ";\n";
							break;
						}

						nodeStr += list->children[i]->toString() + ", " + comment;
					}
					return nodeStr;
				}
				return indentation() + children[0]->toString() + "(" + children[1]->toString() + ");\n";
			}
		}
};


class IfStatementNode : public Node
{
	public:
		IfStatementNode() : Node(IF_STATEMENT)
		{
		}

		std::string toString()
		{
			std::string nodeStr = indentation() + "if(" + children[0]->toString() + ")";
			if(children.size() == 2)
			{
				nodeStr += children[1]->toString();
			}
			else
			{
				nodeStr += children[1]->toString() + children[2]->toString();
			}
			return nodeStr;
		}
};

class WhileStatementNode : public Node
{
	public:
		WhileStatementNode() : Node(WHILE_STATEMENT)
		{
		}

		std::string toString()
		{

			return indentation() + "for(" + children[0]->toString() + ")" + children[1]->toString();
		}
};

class ForStatementNode : public Node
{
	public:
		ForStatementNode() : Node(FOR_STATEMENT)
		{
		}

		void generateSymbols()
		{
			SCOPE::enterNewScope();
			Node::generateSymbols();
			SCOPE::leaveScope();
		}

		std::string toString()
		{
			SCOPE::enterScope();
			std::string nodeStr = indentation() + "while(" + children[0]->toString() + ";"
				+ children[1]->toString() + ";" + children[2]->toString() + ")" + children[3]->toString();
			SCOPE::leaveScope();
			SCOPE::nextScope();
			return nodeStr;
		}
};

class ReturnStatementNode : public Node
{
	public:
		ReturnStatementNode(bool withParentheses) : Node(RETURN_STATEMENT), withParentheses(withParentheses)
		{
		}

		ReturnStatementNode() : Node(RETURN_STATEMENT), withParentheses(true)
		{
		}

		std::string toString()
		{
			std::string nodeStr = indentation() + "return";
			if(children.size() == 1)
			{
				nodeStr += " (" + children[0]->toString() + ");\n";
			}
			else if(withParentheses)
			{
				nodeStr += " ();\n";
			}
			else
			{
				nodeStr += ";\n";
			}
			return nodeStr;
		}

	private:
		bool withParentheses;
};

class BreakStatementNode : public Node
{
	public:
		BreakStatementNode() : Node(BREAK_STATEMENT)
		{
		}

		std::string toString()
		{
			return indentation() + "break;\n";
		}
};

class ContinueStatementNode : public Node
{
	public:
		ContinueStatementNode() : Node(CONTINUE_STATEMENT)
		{
		}

		std::string toString()
		{
			return indentation() + "continue;\n";
		}
};

class RValueNode : public Node
{
	public:
		RValueNode() : Node(RVALUE)
		{
		}

		std::string toString()
		{
			std::string nodeStr = children[0]->toString();
			if(children.size() == 2)
			{
				nodeStr += "[" + children[1]->toString() + "]";
			}
			return nodeStr;
		}
};

class BinaryExprNode : public Node
{
	public:
		BinaryExprNode(std::string value) : Node(BINARY_EXPR, value)
		{
		}

		std::string toString()
		{
			return children[0]->toString() + " " + value + " " + children[0]->toString();
		}
};

class BracketExprNode : public Node
{
	public:
		BracketExprNode() : Node(BRACKET_EXPR)
		{
		}

		std::string toString()
		{
			return "(" + children[0]->toString() + ")";
		}
};

class UnaryExprNode : public Node
{
	public:
		UnaryExprNode(std::string value) : Node(UNARY_EXPR, value)
		{
		}

		std::string toString()
		{
			return value + children[0]->toString();
		}
};

//LLVM Codegen methods


//llvm::Value *ErrorV(const char *Str) { Error(Str); return 0; }

//Codegen implementation for All the ASTs
/*


Value *ExternAST::codegen(){
llvm::Type externtype = *getLLVMType(ReturnType);



//Binary Operations:
llvm:: Value *BinaryExprAST::codegen() {
  Value *L = LHS->codegen();
  Value *R = RHS->codegen();
  if (L == 0 || R == 0) return 0;

  switch (Op) {
  case '+': return Builder.CreateFAdd(L, R, "addtmp"); break;
  case '-': return Builder.CreateFSub(L, R, "subtmp"); break;
  case '*': return Builder.CreateFMul(L, R, "multmp"); break;
  case '/': return BUilder.CreateFDiv(L, R, "divtmp"); break;
  case '%': return Builder.CreateFMod(L,R,"modtmp");   break;

  case '<<':  return Builder.CreateShl(L,R,"<<");break;
  case '>>':  return Builder.CreateShr(L,R,">>");break;

  case '<':
    L = Builder.CreateFCmpULT(L, R, "cmptmp");
    // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
    break;
  case '<=':
    L=Builder.CreateCmpULTE(L,R,"cmptmp");
     // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
     break;
  case '>':
    L = Builder.CreateFCmpUGT(L, R, "cmptmp");
    // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
  case '>=':
    L=Builder.CreateCmpUGE(L,R,"cmptmp");
     // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
      break;
  case '==':
    L = Builder.CreateFCmpUEQ(L, R, "cmptmp");
    // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
      break;
  case '!=':
      L = Builder.CreateFCmpUNE(L, R, "cmptmp");
    // Convert bool 0/1 to double 0.0 or 1.0
    return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
      break;
  case '&&':
     return Builder.CreateAnd(L,R,"andtmp");
     // Convert bool 0/1 to double 0.0 or 1.0
    //return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");

  case '||':
      return Builder.CreateOr(L,R,"ortmp");
     // Convert bool 0/1 to double 0.0 or 1.0
    //return Builder.CreateUIToFP(L, Type::getDoubleTy(getGlobalContext()),
                                "booltmp");
       break;
  default: return ErrorV("invalid binary operator");
}

//expr
llvm:: Value *ExprAST::codegen() {


}


// function to convert decafType to llvm Type




llvm::Value Type *ExternAST::codgen(){

	return *getLLVMType(ReturnType);
}




 static llvm::Value *StringConstAST::Codegen() {
  const char *s = StringConst.c_str();
   llvm::Value *GS =
		    Builder.CreateGlobalString(s, "globalstring");
  return Builder.CreateConstGEP2_32(GS, 0, 0, "cast");
}


llvm::Type *BooleanAST::codgen(){

//depends on implementation of string constant and boolean
	return *getLLVMType(ReturnType);
}



// Declare a block of code
llvm::Value*BlockAST::codegen(){
    // BasicBlock is a Value type, used for branching, automatically execute statements in between, 1 = attach to parent block, 0 = at the end of the block
    return llvm::BasicBlock::Create(getGlobalContext(),"BlockAST",1,0);

}




// Does methodcall using llvm when methodcall AST is created
llvm:Value *MethodCallAST::codegen(){

    // Check Module hash table to see if function is already declared
    Function *ExistingFunc = TheModule->getFunction(Name);
    // If not declared throw error
    if(!ExistingFunc){

        return ErrorV("Function is undeclared");
    }
    // if argument numbers are not accurate  throw error
        if(ExistingFunc->args_size() !=args.size()){

            return ErrorV("Error: does not contain the required arguments");




    }
    // Handle arguments passed in
    std::vector<Value *> Params;
    // Code from llvm.org tutorial to handle pararamters

    for (unsigned i = 0, e = Params.size(); i !=e; ++i){

        Params.push_back(Params[i]->codegen());
            if (!Params.back())
                return nullptr;


    }
    // Create the function call
    return Builder.CreateCall(ExistingFunc,Params,"calltemp");





}
// codgen for function declaration
llvm::Value *MethodDeclCAST::Codegen(){
    // Convert return type to llvm type

	TypedSymbolListAST *FunctionArgs;
	MethodBlockAST *Block;
	// Before creating function declartion, we must check to see if its previously declared ,if null = brand new function
	// if not null create function, otherwise check for body



	Function *ExistingFunc = TheModule->getFunction(Name);
	// Create new Function
	if(!ExistingFunc){
    llvm::Type newType = *getLLVMType(ReturnType);
    // convert argument list to llvm typed list
    std::vector<llvm::Type*> args;
    FunctionType ft = get(newType,args,false);
    Function *F - Function::Create(ft,Function::ExternalLinkage,Name,TheModule);

	//Create a block for the function
	llvm::BasicBlock *BB = BasicBlock::Create(getGlobalContext(),Name,F);
	BUilder.SetInsertPoint(BB);

	// Add all arguments into hash table - * awaiing final implementation for Hash table

	// Add return value to block?

	if (Value *newType = Body->codegen()){

        Builder.CreateRet(newType);

        return F;


	}

	// If error

	F->eraseFromParent();
	return null;




        }





}
//Codegen for return statemetn
llvm::Value *ReturnStmtAST::codegen(){
    // Should return the codegen of whatever is created inside that value , expr
    // Not sure if should handle blocks and scopes

    decafAST v = ReturnStmtAST.Value
    return Builder.CreateRet(v.codegen());


}


// Codegen for variable assignment

llvm::Value *AssignVarAST::codegen(){










}

Check if variable is declared in current scope table.

    if( Hash table has variable already declared){
         P8 :Create Variable with address location + assign the new value}
         P2: Print out line number of where its first declared
    else if(recursively check previous scope for declaration, use declaration from scope that its decalred) {

        P8:Create Variable with address location + value from global
        P2: Print out line number of where its first declared
        }

    if( Hash tables does not contain declaration ){
       throw error;}

}

Value *NumberExprAST::codegen() {

	return constantFP::get(getGlobalContext(),APfloat(val));
}

static llvm::Constant *StringConstAST::Codegen() {
	//contents taken from LLVM cheat sheet
  const char *s = StringConst.c_str();
   llvm::Value *GS =
		    Builder.CreateGlobalString(s, "globalstring");
  return Builder.CreateConstGEP2_32(GS, 0, 0, "cast");
}

static llvm::Constant *CharConstAST::Codegen() {
  const char c = CharConst;//needs to be whichever var is in the 'CharConst' class - may not need that c_str function since its just referencing a char
   llvm::Value *GS =
		    Builder.CreateGlobalString(c, "globalcharacter");
  return Builder.CreateConstGEP2_32(GS, 0, 0, "cast");//not sure what this is doing, or if the vars need to be changed
}
*/
/*Might not need this since numberexprast is doing the same. Keeping this for reference.
static llvm::ConstantInt *IntConstAST::Codegen() {
  return Builder.getInt32(intValue);//needs to get passsed in the local value found in IntConstAST...
  //IRBuilder::getInt32 returns a ConstantInt
}


static llvm::Constant *BoolExprAST::codgen(){
	return Builder.getInt1(Val);
	//IRBuilder::getInt1 returns a ConstantInt, but we can use Constant as per her LLVM cheatsheet
}
*/






}

#endif
