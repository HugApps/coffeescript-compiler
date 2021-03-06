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
/*number (\+|\-)?{digit}+*/
number {digit}+
whitespace [ ^\n\r\t\v\f]*
id  {letter}({letter}|{digit}|\_)*
hex_digit [ {digit* |(A-F)* |(a-f)*}]
decimal_digit {digit}
comment ((\/\/)(.)+\n) 


%%

bool 		{ printf("T_BOOLTYPE %s\n %d",yytext,charcount+yyleng);charcount= charcount + yyleng; return T_BOOLTYPE; }
break 		{ printf("T_BREAK %s\n",yytext);charcount= charcount + yyleng;  return T_BREAK; }
continue 	{ printf("T_CONTINUE %s\n",yytext);charcount= charcount + yyleng; return T_CONTINUE; }
class 		{ printf("T_CLASS %s\n",yytext);charcount= charcount + yyleng; return T_CLASS;}
else  		{ printf("T_ELSE %s\n",yytext);charcount= charcount + yyleng; return T_ELSE; }
\Z    		;

extern 		{ printf("T_EXTERN %s\n",yytext); return T_EXTERN; }

{whitespace}+ {
    int i ;
    printf("T_WHITESPACE ");
	for(i = 0;i<yyleng;i++) {
		if(yytext[i] == '\n') {
			printf("\\n");
		}else {
			printf("%c",yytext[i]);
		}
	}
	printf("\n");	
   }

"&&" 		{printf("T_AND %s\n",yytext);charcount= charcount + yyleng; 	return T_AND; }
"=" 		{printf("T_ASSIGN %s\n",yytext);charcount= charcount + yyleng; 	return T_ASSIGN; }
"," 		{printf("T_COMMA %s\n",yytext);charcount= charcount + yyleng; 	return T_COMMA; }
{comment} 	{printf("T_COMMENT ");charcount= charcount + yyleng;linecount++;
  	int x;
	for(x=0;x< strlen(yytext)-1;x++){
		printf("%c",yytext[x]);
	}
	printf("\\n\n");
}

"/" 		{printf("T_DIV %s\n",yytext);charcount= charcount + yyleng; 	return T_DIV; }
"." 		{printf("T_DOT %s\n",yytext);charcount= charcount + yyleng; 	return T_DOT; }
"=="  		{printf("T_EQ %s\n",yytext);charcount= charcount + yyleng; 	return T_EQ; }
extends 	{printf("T_EXTENDS %s\n",yytext);charcount= charcount + yyleng; return T_EXTENDS; }
extern 		{printf("T_EXTERN %s\n",yytext);charcount= charcount +yyleng; 	return T_EXTERN; }
false  		{printf("T_FALSE %s\n",yytext);charcount= charcount + yyleng; 	return T_FALSE; }
for    		{printf("T_FOR %s\n",yytext);charcount= charcount + yyleng; 	return T_FOR; }
int 		{printf("T_INTTYPE %s\n",yytext);charcount= charcount + yyleng; return T_INTTYPE; }
"\*" 		{printf("T_MULT %s\n", yytext);charcount= charcount + yyleng; 	return T_MULT; }
"%"  		{printf("T_MOD %s\n", yytext); charcount =charcount + yyleng; 	return T_MOD; }
">=" 		{printf("T_GEQ %s\n",yytext);charcount= charcount + yyleng; 	return T_GEQ; }
">" 		{printf("T_GT %s\n",yytext);charcount= charcount + yyleng; 	return T_GT; }
return 		{printf("T_RETURN %s\n",yytext);charcount= charcount + yyleng; 	return T_RETURN; }
if   		{printf("T_IF %s\n",yytext);charcount= charcount + yyleng; 	return T_IF; }
new  		{printf("T_NEW %s\n",yytext);charcount= charcount + yyleng; 	return T_NEW; }
null 		{printf("T_NULL %s\n",yytext);charcount= charcount + yyleng; 	return T_NULL; }
string 		{printf("T_STRINGTYPE %s\n",yytext);charcount= charcount + yyleng; return T_STRINGTYPE; }
true 		{printf("T_TRUE %s\n",yytext);charcount= charcount + yyleng;	return T_TRUE; }
{number} 	{printf("T_INTCONSTANT %s\n",yytext);charcount= charcount + yyleng; 
		yylval.str_t = strdup(yytext); return T_INTCONSTANT; }
void 		{printf("T_VOID %s\n",yytext);charcount= charcount + yyleng;	return T_VOID; }
while 		{printf("T_WHILE %s\n",yytext);charcount= charcount + yyleng; 	return T_WHILE; }
{id} 		{printf("T_ID %s\n",yytext); charcount= charcount + yyleng;	
		yylval.str_t = strdup(yytext); return T_ID; }

(\{) 		{printf("T_LCB %s\n",yytext);charcount= charcount + yyleng;	return T_LCB; }
"<<"  		{printf("T_LEFTSHIFT %s\n",yytext);charcount= charcount + yyleng; return T_LEFTSHIFT; }
"<="  		{printf("T_LEQ %s\n",yytext);charcount= charcount + yyleng;	return T_LEQ; }

"("  		{printf("T_LPAREN %s\n",yytext);charcount= charcount + yyleng;	return T_LPAREN; }
"[" 		{printf("T_LSB %s\n",yytext);charcount= charcount + yyleng;	return T_LSB; }

"<" 		{printf("T_LT %s\n",yytext);charcount= charcount + yyleng;	return T_LT; }
"-" 		{printf("T_MINUS %s\n",yytext);charcount= charcount + yyleng;	return T_MINUS; }
"!=" 		{printf("T_NEQ %s\n",yytext);charcount= charcount + yyleng;	return T_NEQ; }

"!" 		{printf("T_NOT %s\n",yytext);charcount= charcount + yyleng;	return T_NOT; } 

"||" 		{printf("T_OR %s\n",yytext);charcount= charcount + yyleng;	return T_OR; }
"+" 		{printf("T_PLUS %s\n",yytext);charcount= charcount + yyleng;	return T_PLUS; }
"}"  		{printf("T_RCB %s\n",yytext);charcount= charcount + yyleng;	return T_RCB; } 

">>" 		{printf("T_RIGHTSHIFT %s\n",yytext);charcount= charcount + yyleng;	return T_RIGHTSHIFT; }
")" 		{printf("T_RPAREN %s\n",yytext);charcount= charcount + yyleng;		return T_RPAREN; }
"]" 		{printf("T_RSB %s\n",yytext);charcount= charcount + yyleng;		return T_RSB; }
";"  		{printf("T_SEMICOLON %s\n",yytext);charcount= charcount + yyleng;	return T_SEMICOLON; }


{stringescape} 	{printf("T_STRINGCONSTANT %s\n",yytext);charcount= charcount + yyleng; return T_STRINGCONSTANT; }

{dquote}\\[^nbtrvab'"\\]{dquote} 	{fprintf(stderr,"ERROR: Invalid escape character in string constant");return ERROR;}
{dquote}\\{dquote} 			{fprintf(stderr,"ERROR: Invalid escape character in string constant");return ERROR;}


{stringlit} 	{printf("T_STRINGCONSTANT %s\n",yytext); yylval.str_t = process_string(yytext); charcount= charcount + yyleng; return T_STRINGCONSTANT; }

{squote}\\{squote} 			{fprintf(stderr,"ERROR: Invalid escape in char constant");return ERROR;}
({charlit})|({charwithescape}) 		{printf("T_CHARCONSTANT %s\n",yytext);charcount= charcount + yyleng; return T_CHARCONSTANT;}
 

('') 		{fprintf(stderr,"Empty char constant at line %i and position %i\n",linecount,charcount + yyleng); return ERROR;}

{squote}..{squote} 			{fprintf(stderr,"Invalid char constant length at line %i and position %i\n",linecount,charcount + yyleng);return ERROR;} 
(.) 		{fprintf(stderr,"ERROR at line %i position %i \n",linecount, charcount + yyleng);return ERROR;}
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
