%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define ERROR 256
int linecount = 1;
int charcount = 0;
%}

squote \'
dquote \"

stringlit ({dquote}(.*)+{dquote})
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
number (\+|\-)?{digit}+
whitespace [ \n\r\t\v\f]
id  {letter}({letter}|{digit}|\_)*
hex_digit [ {digit* |(A-F)* |(a-f)*}]
decimal_digit {digit}
comment ((\/\/)(.)+{newline}) 


%%

bool { printf("T_BOOLTYPE %s %d\n",yytext,charcount+yyleng);charcount= charcount + yyleng; }
break { printf("T_BREAK %s\n",yytext);charcount= charcount + yyleng;}
continue { printf("T_CONTINUE %s\n",yytext);charcount= charcount + yyleng;}
class {printf("T_CLASS %s\n",yytext);charcount= charcount + yyleng;}
else  {printf("T_ELSE %s\n",yytext);charcount= charcount + yyleng;}
\Z    {return 0;}

extern {printf("T_EXTERN %s\n",yytext);}

^{whitespace}+ {
                        linecount=linecount+yyleng;charcount=0;
                        int numNewLine = strlen(yytext);
        
			printf("T_WHITESPACE ");
			int i;
			for(i = 0 ; i < numNewLine; ++i){	
				printf("\\n");
	                }
			printf("\n");
			
               }

{whitespace} {printf("T_WHITESPACE \\n\n");}

"&&" {printf("T_AND %s\n",yytext);charcount= charcount + yyleng;}
"=" {printf("T_ASSIGN %s\n",yytext);charcount= charcount + yyleng;}
"," {printf("T_COMMA %s\\n\n",yytext);charcount= charcount + yyleng;}
{comment} {printf("T_COMMENT %s\\n\n",yytext);charcount= charcount + yyleng;}
"/" {printf("T_DIV %s\n",yytext);charcount= charcount + yyleng;}
"." {printf("T_DOT %s\n",yytext);charcount= charcount + yyleng;}
"=="  {printf("T_EQ %s\n",yytext);charcount= charcount + yyleng;}
extends {printf("T_EXTENDS %s\n",yytext);charcount= charcount + yyleng;}
extern {printf("T_EXTERN %s\n",yytext);charcount= charcount +yyleng;}
false  {printf("T_FALSE %s\n",yytext);charcount= charcount + yyleng;}
for    {printf("T_FOR %s\n",yytext);charcount= charcount + yyleng;}
int {printf("T_INTTYPE %s\n",yytext);charcount= charcount + yyleng;}
"\*" {printf("T_MULT %s\n", yytext);charcount= charcount + yyleng;}
"%"  {printf("T_MOD %s\n", yytext); charcount =charcount + yyleng;}
">=" {printf("T_GEQ %s\n",yytext);charcount= charcount + yyleng;}
">" {printf("T_GT %s\n",yytext);charcount= charcount + yyleng;}
return {printf("T_RETURN %s\n",yytext);charcount= charcount + yyleng; }
if   {printf("T_IF %s\n",yytext);charcount= charcount + yyleng;}
new  {printf("T_NEW %s\n",yytext);charcount= charcount + yyleng;}
null {printf("T_NULL %s\n",yytext);charcount= charcount + yyleng;}
string {printf("T_STRINGTYPE %s\n",yytext);charcount= charcount + yyleng;}
true {printf("T_TRUE %s\n",yytext);charcount= charcount + yyleng;}
{number} {printf("T_INTCONTSANT %s\n",yytext);charcount= charcount + yyleng;}
void {printf("T_VOID %s\n",yytext);charcount= charcount + yyleng;}
while {printf("T_WHILE %s\n",yytext);charcount= charcount + yyleng;}
{id} {printf("T_ID %s\n",yytext); charcount= charcount + yyleng;}

(\{) {printf("T_LCB %s\n",yytext);charcount= charcount + yyleng;}
"<<"  {printf("T_LEFTSHIFT %s\n",yytext);charcount= charcount + yyleng;}
"<="  {printf("T_LEQ %s\n",yytext);charcount= charcount + yyleng;}

"("  {printf("T_LPAREN %s\n",yytext);charcount= charcount + yyleng;}
"[" {printf("T_LSB %s\n",yytext);charcount= charcount + yyleng;}

"<" {printf("T_LT %s\n",yytext);charcount= charcount + yyleng;}
"-" {printf("T_MINUS %s\n",yytext);charcount= charcount + yyleng;}
"!=" {printf("T_NEQ %s\n",yytext);charcount= charcount + yyleng;}

"!" {printf("T_NOT %s\n",yytext);charcount= charcount + yyleng;} 

"||" {printf("T_OR %s\n",yytext);charcount= charcount + yyleng;}
"+" {printf("T_PLUS %s\n",yytext);charcount= charcount + yyleng;}
"}"  {printf("T_RCB %s\n",yytext);charcount= charcount + yyleng;} 

">>" {printf("T_RIGHTSHIFT %s\n",yytext);charcount= charcount + yyleng;}
")" {printf("T_RPAREN %s\n",yytext);charcount= charcount + yyleng;}
"]" {printf("T_RSB %s\n",yytext);charcount= charcount + yyleng;}
";"  {printf("T_SEMICOLON %s\n",yytext);charcount= charcount + yyleng;}

{stringlit} {printf("T_STRINGCONSTANT %s\n",yytext);charcount= charcount + yyleng;}


({charlit})|({charwithescape}) {printf("T_CHARCONSTANT %s\n",yytext);charcount= charcount + yyleng;}
 

('') {fprintf(stdout,"Empty char constant at line %i and position %i\n",linecount,charcount + yyleng); return ERROR;}

{squote}..{squote} {printf("Invalid char constant length at line %i and position %i\n",linecount,charcount + yyleng);return ERROR;} 
(.) {fprintf(stdout,"ERROR at line %i position %i \n",linecount, charcount + yyleng);return ERROR;}
%%



int main (){
int token;
int position;
int line=1;

fflush(stdout);
 if(yylex() == ERROR){exit(1);}
 else{exit(0);}
        
	


}

        

