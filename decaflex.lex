%{
#include <stdio.h>
#define NUMBER 256
#define IDENTIFIER 257
#define ERROR 258

int linecount =0;
int charcount =0;

%}

letter [a-zA-Z]
newline [ \n]
carriage_return [ \r]
horizontal_tab [ \t]
vertical_tab [ \v]
form_feed  [ \f]
space      [' '];
digit [0-9]
number {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
whitespace [ {newline} |{ carriage_return} |{ horizontal_tab} |{ vertical_tab} |{ form_feed} |{ space} ]+
id {letter}({letter}|{digits})* | '_'*}
hex_digit {digit* |(A-F)* |(a-f)*}
decimal_digit {digit}
comment ["//"(.)*{newline}] 


%%
bool { printf("T_BOOLTYPE"); }
break { printf("T_BREAK");}
continue { printf("T_CONTINUE");}
class {printf("T_CLASS");}
else  {printf("T_ELSE");}
[.]   {charcount++;}
{newline} {linecount++; charcount=0; }
&& {printf("T_AND");}
[=]  {printf("T_ASSIGN");}
bool {printf("T_BOOLTYPE");}
[\,] {printf("T_COMMA");}
{comment} {printf("T_COMMENT");}
[\/] {printf("T_DIV");}
[\.] {printf("T_DOT");}
[==]  {printf("T_EQ");}
extends {printf("T_EXTENDS");}
extern {printf("T_EXTERN");}
false  {printf("T_FALSE");}
for    {printf("T_FOR");}
[>=]     {printf("T_GEQ");}
[\>]    {printf("T_GT");}
{id} {printf("T_ID");}
if   {printf("T_IF");}
{number}* {printf("T_INTCONSTANT");}
int {printf("T_INTTYPE");}
[\{] {printf("T_LCB");}
[<<]  {printf("T_LEFTSHIFT");}
[<=]  {printf("T_LEQ");}
[\(]  {printf("T_LPAREN");}
[\[] {printf("T_LSB");}
[<] {printf("T_LT");}
[-] {printf("T_MINUS");}
[!=] {printf("T_NEQ");}
new  {printf("T_NEW");}
[!] {printf("T_NOT");} 
null {printf("T_NULL");}
[||] {printf("T_OR");}
[+] {printf("T_PLUS");}
[}] {printf("T_RCB");} 
return {printf("T_RETURN");}
[>>] {printf("T_RIGHTSHIFT");}
[)] {printf("T_RPAREN");}
[\]] {printf("T_RSB");}
[;]  {printf("T_SEMICOLON");}
string {printf("T_STRINGTYPE");}
true {printf("T_TRUE");}
void {printf("T_VOID");}
while {printf("T_WHILE");}
{whitespace}* {printf("T_WHITESPACE");}
%%


