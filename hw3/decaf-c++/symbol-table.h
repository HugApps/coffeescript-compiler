#ifndef SYMBOL_TABLE_H_
#define SYMBOL_TABLE_H_

#include <unordered_map>
#include <string>

class SymbolTable
{
public:
	SymbolTable()
	{
		
	}
	
	~SymbolTable()
	{
		
	}
	
	void addDefinition(std::string key, std::string value)
	{
		_definitions.push(std::pair<std::string, std::string>(key, value));
	}
	
private:
	std::unordered_map<std::string, std::string> _definitions;
};

#endif