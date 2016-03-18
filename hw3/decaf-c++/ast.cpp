#ifndef AST_H_
#define AST_H_

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sstream>
#include <vector>

std::string to_string(int num)
{
	std::ostringstream convert;
	convert << num;
	return convert.str();
}

namespace AST
{
    char* append(char* str1, char* str2) {
	size_t length = strlen(str1) + strlen(str2) + 1;
    	char* final_str = (char*) malloc(length);
	strcat(strcat(final_str, str1), str2);
	return final_str;
}

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
	LIST,
	LIST_NEW_LINE,
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
		
		virtual std::string toString()
		{			
			std::string nodeStr = "";
			if(type == LIST_NEW_LINE)
			{
				for(int i = 0; i < children.size(); i++)
				{
					nodeStr += children[i]->toString();
					if(i != children.size() - 1)
					{
						nodeStr += "\n";
					}
				}
			}
			else if(type == LIST)
			{
				for(int i = 0; i < children.size(); i++)
				{
					nodeStr += children[i]->toString();
					if(i != children.size() - 1)
					{
						nodeStr += ",";
					}
				}
			}
			else
			{
				for(int i = 0; i < children.size(); i++)
				{
					nodeStr += children[i]->toString();
				}
			}
			
			return nodeStr;
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

		std::string toString()
		{
			currentBlockDepth++;

			std::string nodeStr = "class " + children[0]->toString() + " {\n" + children[1]->toString();
			if(children.size() == 3)
			{
				nodeStr += children[2]->toString();
			}
			currentBlockDepth--;
			nodeStr += "}";
			return nodeStr;
		}
};

class FieldDeclNode : public Node
{
	public:
		FieldDeclNode(int lineNumber) : Node(FIELD_DECL, lineNumber)
		{
		}

		std::string toString()
		{
			return indentation() + children[0]->toString() + " " + children[1]->toString() + " = " + children[2]->toString() + ";\n";
		}
};

class FieldArrayDeclNode : public Node
{
	public:
		FieldArrayDeclNode(int lineNumber) : Node(FIELD_DECL_ARRAY, lineNumber)
		{
		}

		std::string toString()
		{
			return indentation() + children[0]->toString() + " " + children[1]->toString() + " = " + children[2]->toString() + ";\n";
		}
};

class MethodDeclNode : public Node
{
	public:
		MethodDeclNode() : Node(METHOD_DECL)
		{
		}

		std::string toString()
		{
			std::string nodeStr = indentation() + children[0]->toString() + " " + children[1]->toString() + "(";
			if(children.size() == 4)
			{
				nodeStr += children[2]->toString();
				nodeStr += ")";
				nodeStr += children[3]->toString();
			}
			else
			{
				nodeStr += ") ";
				nodeStr += children[2]->toString();
			}
			
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
};

class MethodParamNode : public Node
{
	public:
		MethodParamNode(int lineNumber) : Node(PARAM, lineNumber)
		{
		}

		std::string toString()
		{
			return children[0]->toString() + " " + children[1]->toString();
		}
};

class BlockNode : public Node
{
	public:
		BlockNode() : Node(BLOCK)
		{
		}

		std::string toString()
		{
			currentBlockDepth++;
			std::string nodeStr = "{\n"; 
			for(int i = 0; i < children.size(); i++)
			{
				nodeStr += children[i]->toString() + "\n";
			}
			currentBlockDepth--;
			nodeStr += indentation() + "}\n";
			
			return nodeStr;
		}
};

class VarDeclNode : public Node
{
	public:
		VarDeclNode(int lineNumber) : Node(VAR_DECL, lineNumber)
		{
		}

		std::string toString()
		{
			return indentation() + children[0]->toString() + " " + children[1]->toString() + ";";
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
			if(children.size() == 2)
			{
				return indentation() + children[0]->toString() + " = " + children[1]->toString() + ";";
			}
			else
			{
				return indentation() + children[0]->toString() + "[" + children[1]->toString() + "] = " + children[2]->toString() + ";";
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
				return indentation() + children[0]->toString() + "();";
			}
			else
			{
				return indentation() + children[0]->toString() + "(" + children[1]->toString() + ");";
			}
		}
};

}

#endif
