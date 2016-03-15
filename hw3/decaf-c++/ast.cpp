#ifndef AST_H_
#define AST_H_

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <vector>

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
	NONE
};

class Node
{
	public:
		Node(Type type, std::string value) :
			type(type),
			value(value)
		{
		}
		
		Node(Type type, std::string* value) :
			type(type),
			value(*value)
		{
		}
		
		Node(Type type, int value) :
			type(type),
			value(std::to_string(value))
		{
		}
		
		Node(Type type) :
			type(type),
			value("")
		{
		}
		
		Node() :
			type(NONE),
			value("")
		{
		}
		
		~Node()
		{
		}
		
		std::string toString()
		{
			if(type == NONE)
				return "";
				
			return "Unknown Node";
		}
		
		void addChild(Node* child)
		{
			if(child != NULL)
			{
				children.push_back(child);
			}
		}
		
	private:
		Type type;
		std::string value;
		std::vector<Node*> children;
};

}

#endif
