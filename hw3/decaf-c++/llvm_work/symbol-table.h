#ifndef SYMBOL_TABLE_H_
#define SYMBOL_TABLE_H_

#include <unordered_map>
#include <string>
#include <vector>
#include <assert.h>

using namespace std;

class Symbol
{
public:
	Symbol(std::string value, int lineNumber) :
		_value(value),
		_lineNumber(lineNumber)
	{
	}

	Symbol(std::string value) :
		_value(value),
		_lineNumber(-1)
	{
	}

	~Symbol()
	{
	}

	std::string getValue()
	{
		return _value;
	}

	int getLineNumber()
	{
		return _lineNumber;
	}

private:
	std::string _value;
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
		_symbols.insert(std::pair<std::string, Symbol>(key, value));
	}

	Symbol& getDefinition(std::string key)
	{
		return _symbols.at(key);
	}

	bool containsDefinition(std::string key)
	{
		std::unordered_map<std::string, Symbol>::iterator it = _symbols.find(key);
		if (it == _symbols.end())
			return false;
		else
			return true;
	}

private:
	std::unordered_map<std::string, Symbol> _symbols;
};

#endif
