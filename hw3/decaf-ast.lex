%{
#include "decaf-ast.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define ERROR 256
int linecount = 1;
int charcount = 0;

char* process_string (const char *s) {
  
  	size_t len = strlen(s);
	char* ns = (char*) malloc(sizeof(char) * len);

	int i, j;
	  for (i = 0, j = 0; i < len; i++, j++) {
	    if (s[i] == '\\') {
	      i++;
	      switch(s[i]) {
	      case 't': ns[j] = '\t'; break;
	      case 'v': ns[j] = '\v'; break;
	      case 'r': ns[j] = '\r'; break;
	      case 'n': ns[j] = '\n'; break;
	      case 'a': ns[j] = '\a'; break;
	      case 'f': ns[j] = '\f'; break;
	      case 'b': ns[j] = '\b'; break;
	      case '\\': ns[j] = '\\'; break;
	      case '\'': ns[j] = '\''; break;
	      case '\"': ns[j] = '\"'; break;
	      default: 
		ns[j] = s[i];
	      }
	    } else {
	      ns[j] = s[i];
	    }
	  }
	  return ns;
}



%}

squote \'
dquote \"

stringlit {dquote}.*{dquote}
stringescape {dquote}(escape_char){dquote}

charlit ({squote}(.){squote})+
charwithescape {squote}{escape_char}{squote}

illegal  ^{dquote}$|^{number}$|^{squote}$
letter [a-zA-Z]
newline [\n]
carriage_return [\r]
horizontal_tab [\t]
vertical_tab [\v]
form_feed  [\f]
escape_char \\([ftvnrab'"\\])
space   [' ']
digit [0-9]
number {digit}+
whitespace [ ^\n\r\t\v\f]*
id  {letter}({letter}|{digit}|\_)*
hex_digit [ {digit* |(A-F)* |(a-f)*}]
decimal_digit {digit}
comment ((\/\/)(.)+\n) 


%%

bool 		{ charcount= charcount + yyleng; return T_BOOLTYPE; }
break 		{ charcount= charcount + yyleng;  return T_BREAK; }
continue 	{ charcount= charcount + yyleng; return T_CONTINUE; }
class 		{ charcount= charcount + yyleng; return T_CLASS;}
else  		{ charcount= charcount + yyleng; return T_ELSE; }
\Z    		;

extern 		{  return T_EXTERN; }

{whitespace}+ 	{ }

"&&" 		{charcount= charcount + yyleng; 	return T_AND; }
"=" 		{charcount= charcount + yyleng; 	return T_ASSIGN; }
"," 		{charcount= charcount + yyleng; 	return T_COMMA; }
{comment} 	{charcount= charcount + yyleng;linecount++;}

"/" 		{charcount= charcount + yyleng; 	return T_DIV; }
"." 		{charcount= charcount + yyleng; 	return T_DOT; }
"=="  		{charcount= charcount + yyleng; 	return T_EQ; }
extends 	{charcount= charcount + yyleng; return T_EXTENDS; }
extern 		{charcount= charcount +yyleng; 	return T_EXTERN; }
false  		{charcount= charcount + yyleng; 	return T_FALSE; }
for    		{charcount= charcount + yyleng; 	return T_FOR; }
int 		{charcount= charcount + yyleng; return T_INTTYPE; }
"\*" 		{charcount= charcount + yyleng; 	return T_MULT; }
"%"  		{charcount =charcount + yyleng; 	return T_MOD; }
">=" 		{charcount= charcount + yyleng; 	return T_GEQ; }
">" 		{charcount= charcount + yyleng; 	return T_GT; }
return 		{charcount= charcount + yyleng; 	return T_RETURN; }
if   		{charcount= charcount + yyleng; 	return T_IF; }
new  		{charcount= charcount + yyleng; 	return T_NEW; }
null 		{charcount= charcount + yyleng; 	return T_NULL; }
string 		{charcount= charcount + yyleng; return T_STRINGTYPE; }
true 		{charcount= charcount + yyleng;	return T_TRUE; }
{number} 	{charcount= charcount + yyleng; yylval.str_t = strdup(yytext); return T_INTCONSTANT; }
void 		{charcount= charcount + yyleng;	return T_VOID; }
while 		{charcount= charcount + yyleng; 	return T_WHILE; }
{id} 		{charcount= charcount + yyleng;	yylval.str_t = strdup(yytext); return T_ID; }

(\{) 		{charcount= charcount + yyleng;	return T_LCB; }
"<<"  		{charcount= charcount + yyleng; return T_LEFTSHIFT; }
"<="  		{charcount= charcount + yyleng;	return T_LEQ; }

"("  		{charcount= charcount + yyleng;	return T_LPAREN; }
"[" 		{charcount= charcount + yyleng;	return T_LSB; }

"<" 		{charcount= charcount + yyleng;	return T_LT; }
"-" 		{charcount= charcount + yyleng;	return T_MINUS; }
"!=" 		{charcount= charcount + yyleng;	return T_NEQ; }

"!" 		{charcount= charcount + yyleng;	return T_NOT; } 

"||" 		{charcount= charcount + yyleng;	return T_OR; }
"+" 		{charcount= charcount + yyleng;	return T_PLUS; }
"}"  		{charcount= charcount + yyleng;	return T_RCB; } 

">>" 		{charcount= charcount + yyleng;	return T_RIGHTSHIFT; }
")" 		{charcount= charcount + yyleng;		return T_RPAREN; }
"]" 		{charcount= charcount + yyleng;		return T_RSB; }
";"  		{charcount= charcount + yyleng;	return T_SEMICOLON; }


{stringescape} 	{charcount= charcount + yyleng; return T_STRINGCONSTANT; }

{dquote}\\[^nbtrvab'"\\]{dquote} 	{return ERROR;}
{dquote}\\{dquote} 			{return ERROR;}


{stringlit} 	{ yylval.str_t = process_string(yytext); charcount= charcount + yyleng; return T_STRINGCONSTANT; }

{squote}\\{squote} 			{return ERROR;}
({charlit})|({charwithescape}) 		{charcount= charcount + yyleng; return T_CHARCONSTANT;}
 

('') 		{ return ERROR;}

{squote}..{squote} 			{return ERROR;} 
(.) 		{return ERROR;}
%%



/*int main (){
	int token;
	int position;
	while((token = yylex())){
		position=position+token;
	}
	printf("%d",position);
}
      
*/
