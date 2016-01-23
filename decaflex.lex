%{

#include <stdio.h>
#include <string.h>

int linecount = 1;
int charcount = 1;
%}

squote \'
dquote \"
stringlit {dquote}(.)+{dquote}
charlit ({squote}(.){squote})+
illegal  ^{dquote}$|^{number}$|^{squote}$|{space}
letter [a-zA-Z]
newline [ \n]
carriage_return [ \r]
horizontal_tab [ \t]
vertical_tab [ \v]
form_feed  [ \f]
space   [' ']
digit [0-9]
number (\+|\-)?{digit}+
whitespace [" " \n\r\t\v\f]+ 
id  {letter}({letter}|{digit}|\_)+
hex_digit [ {digit* |(A-F)* |(a-f)*}]
decimal_digit {digit}
comment ((\/\/)(.)+{newline}) 


%%
bool { printf("T_BOOLTYPE %s\n",yytext);charcount= charcount + strlen (yytext); return charcount; }
break { printf("T_BREAK %s\n",yytext);charcount= charcount + strlen (yytext);}
continue { printf("T_CONTINUE %s\n",yytext);charcount= charcount + strlen (yytext);}
class {printf("T_CLASS %s\n",yytext);charcount= charcount + strlen (yytext);}
else  {printf("T_ELSE %s\n",yytext);charcount= charcount + strlen (yytext);}
\Z    {return 0;}
extern {printf("T_EXTERN %s\n",yytext);}
{newline} {linecount++;charcount=0;}

"&&" {printf("T_AND %s\n",yytext);charcount= charcount + strlen (yytext);}
"=" {printf("T_ASSIGN %s\n",yytext);charcount= charcount + strlen (yytext);}
"," {printf("T_COMMA %s\n",yytext);charcount= charcount + strlen (yytext);}
{comment} {printf("T_COMMENT %s\n",yytext);charcount= charcount + strlen (yytext);}
"/" {printf("T_DIV %s\n",yytext);charcount= charcount + strlen (yytext);}
"." {printf("T_DOT %s\n",yytext);charcount= charcount + strlen (yytext);}
"=="  {printf("T_EQ %s\n",yytext);charcount= charcount + strlen (yytext);}
extends {printf("T_EXTENDS %s\n",yytext);charcount= charcount + strlen (yytext);}
extern {printf("T_EXTERN %s\n",yytext);charcount= charcount + strlen (yytext);}
false  {printf("T_FALSE %s\n",yytext);charcount= charcount + strlen (yytext);}
for    {printf("T_FOR %s\n",yytext);charcount= charcount + strlen (yytext);}
">=" {printf("T_GEQ %s\n",yytext);charcount= charcount + strlen (yytext);}
">" {printf("T_GT %s\n",yytext);charcount= charcount + strlen (yytext);}
{id} {printf("T_ID %s\n",yytext); charcount= charcount + strlen (yytext);}
{letter} {printf("T_ID %s\n" ,yytext);charcount= charcount + strlen (yytext);}
if   {printf("T_IF %s\n",yytext);charcount= charcount + strlen (yytext);}
{number} {printf("T_INTCONSANT %s\n",yytext);charcount= charcount + strlen (yytext);}
int {printf("T_INTTYPE %s\n",yytext);charcount= charcount + strlen (yytext);}
(\{) {printf("T_LCB %s\n",yytext);charcount= charcount + strlen (yytext);}
"<<"  {printf("T_LEFTSHIFT %s\n",yytext);charcount= charcount + strlen (yytext);}
"<="  {printf("T_LEQ %s\n",yytext);charcount= charcount + strlen (yytext);}

"("  {printf("T_LPAREN %s\n",yytext);charcount= charcount + strlen (yytext);}
"[" {printf("T_LSB %s\n",yytext);charcount= charcount + strlen (yytext);}

"<" {printf("T_LT %s\n",yytext);charcount= charcount + strlen (yytext);}
"-" {printf("T_MINUS %s\n",yytext);charcount= charcount + strlen (yytext);}
"!=" {printf("T_NEQ %s\n",yytext);charcount= charcount + strlen (yytext);}
new  {printf("T_NEW %s\n",yytext);charcount= charcount + strlen (yytext);}
"!" {printf("T_NOT %s\n",yytext);charcount= charcount + strlen (yytext);} 
null {printf("T_NULL %s\n",yytext);charcount= charcount + strlen (yytext);}
"||" {printf("T_OR %s\n",yytext);charcount= charcount + strlen (yytext);}
"+" {printf("T_PLUS %s\n",yytext);charcount= charcount + strlen (yytext);}
"}"  {printf("T_RCB %s\n",yytext);charcount= charcount + strlen (yytext);} 
return {printf("T_RETURN %s\n",yytext);return strlen (yytext);charcount= charcount + strlen (yytext); }
">>" {printf("T_RIGHTSHIFT %s\n",yytext);charcount= charcount + strlen (yytext);}
")" {printf("T_RPAREN %s\n",yytext);charcount= charcount + strlen (yytext);}
"]" {printf("T_RSB %s\n",yytext);charcount= charcount + strlen (yytext);}
";"  {printf("T_SEMICOLON %s\n",yytext);charcount= charcount + strlen (yytext);}
string {printf("T_STRINGTYPE %s\n",yytext);charcount= charcount + strlen (yytext);}
{stringlit} {printf("T_STRINGCONSTANT %s\n",yytext);charcount= charcount + strlen (yytext);}
true {printf("T_TRUE %s\n",yytext);charcount= charcount + strlen (yytext);}
void {printf("T_VOID %s\n",yytext);charcount= charcount + strlen (yytext);}
while {printf("T_WHILE %s\n",yytext);charcount= charcount + strlen (yytext);}
{whitespace} {printf("T_WHITESPACE '\n' \n ");}
{charlit}  {printf("T_CHARCONSTANT %s\n",yytext);charcount= charcount + strlen (yytext);}
(.) {printf("error in line  %d position %d \n",linecount,charcount= charcount + strlen(yytext));}

%%



int main (){
int token;
int position;
while((token = yylex())){
        position=position+token;
	


}
printf("%d",position);
        
}
