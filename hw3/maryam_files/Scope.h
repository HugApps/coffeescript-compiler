#ifndef SCOPE_H_
#define SCOPE_H_

#include <unordered_map>
#include <vector>
#include <assert.h>
#include "llvm-3.3/llvm/IR/IRBuilder.h"
#include "llvm-3.3/llvm/IR/LLVMContext.h"
#include "llvm-3.3/llvm/IR/Module.h"
#include "llvm-3.3/llvm/IR/DerivedTypes.h"

class Symbol
{
public:
	Symbol(llvm::Value* value, int lineNumber) :
		_value(value),
		_lineNumber(lineNumber)
	{
	}

	Symbol(llvm::Value* value) :
		_value(value),
		_lineNumber(-1)
	{
	}

	~Symbol()
	{
	}

	llvm::Value* getValue()
	{
		return _value;
	}

        int getLine()
	{
		return _lineNumber;
	}

private:
	llvm::Value* _value;
	int _lineNumber;
};

class SymbolTable
{
public:
	SymbolTable()
	{
	}

	~SymbolTable()
	{
	}

	void addDefinition(std::string key, Symbol value)
	{
		if(this->containsDefinition(key)){
			_symbols.erase(key); 		
		
		}
		_symbols.insert(std::pair<std::string, Symbol>(key, value));
		//need to check if symbol is already in there and remove that, and continue with inserting
	}

	Symbol& getDefinition(std::string key)
	{
		return _symbols.at(key);
	}

	bool containsDefinition(std::string key)
	{
		std::unordered_map<std::string, Symbol>::const_iterator it = _symbols.find(key);
		if (it == _symbols.end())
			return false;
		else
			return true;
	}

private:
	std::unordered_map<std::string, Symbol> _symbols;
};

namespace SCOPE
{
	class Scope
	{
	public:
		Scope(Scope* parent)
		{
			_parentScope = parent;
			_currentChild = 0;
		}

		~Scope()
		{
		}

		Scope* getParentScope()
		{
			return _parentScope;
		}

		void addChildScope(Scope* scope)
		{
			_childScopes.push_back(scope);
		}

		Scope* getCurrentChildScope()
		{
			if (_currentChild < _childScopes.size())
			{
				return _childScopes[_currentChild];
			}
			else
			{
				return NULL;
			}
		}

		void nextChildScope()
		{
			if (_currentChild < _childScopes.size() - 1)
			{
				_currentChild++;
			}
		}

		void previousChildScope()
		{
			if (_currentChild > 0)
			{
				_currentChild--;
			}
		}

		SymbolTable& getSymbolTable()
		{
			return _symbolTable;
		}

	private:
		Scope* _parentScope;
		std::vector<Scope*> _childScopes;
		SymbolTable _symbolTable;		
		int _currentChild;
	};

	static Scope* currentScope = NULL;

	static void enterNewScope()
	{
		Scope* scope = new Scope(currentScope);
		if (currentScope != NULL)
		{
			currentScope->addChildScope(scope);
		}
		currentScope = scope;
	}

	static Scope* getCurrentScope()
	{
		return currentScope;
	}

	static void enterScope()
	{
		if (currentScope != NULL)
		{
			currentScope = currentScope->getCurrentChildScope();
		}		
	}

	static void leaveScope()
	{
		if (currentScope == NULL)
			return;

		currentScope = currentScope->getParentScope();
	}

	static void addDefinition(std::string key, Symbol value)
	{
		currentScope->getSymbolTable().addDefinition(key, value);
	}

	static bool containsDefinition(std::string key)
	{
		Scope* scope = currentScope;
		do
		{
			if (scope->getSymbolTable().containsDefinition(key))
			{
				return true;
			}
			scope = scope->getParentScope();
		} while (scope != NULL);
		return false;
	}

	static Symbol& getDefinition(std::string key)
	{
		Scope* scope = currentScope;
		do
		{
			if (scope->getSymbolTable().containsDefinition(key))
			{
				return scope->getSymbolTable().getDefinition(key);
			}
			scope = scope->getParentScope();
		} while (scope != NULL);
		assert(false);
	}
}

#endif
