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
number (\+|\-)?{digit}+
whitespace [ ^\n\r\t\v\f]*
id  {letter}({letter}|{digit}|\_)*
hex_digit [ {digit* |(A-F)* |(a-f)*}]
decimal_digit {digit}
comment ((\/\/)(.)+\n) 


%%

bool { printf("T_BOOLTYPE %s\n %d",yytext,charcount+yyleng);charcount= charcount + yyleng; }
break { printf("T_BREAK %s\n",yytext);charcount= charcount + yyleng;}
continue { printf("T_CONTINUE %s\n",yytext);charcount= charcount + yyleng;}
class {printf("T_CLASS %s\n",yytext);charcount= charcount + yyleng;}
else  {printf("T_ELSE %s\n",yytext);charcount= charcount + yyleng;}
\Z    {return 0;}

extern {printf("T_EXTERN %s\n",yytext);}

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

"&&" {printf("T_AND %s\n",yytext);charcount= charcount + yyleng;}
"=" {printf("T_ASSIGN %s\n",yytext);charcount= charcount + yyleng;}
"," {printf("T_COMMA %s\n",yytext);charcount= charcount + yyleng;}
{comment} {printf("T_COMMENT ");charcount= charcount + yyleng;linecount++;
  	int x;
	for(x=0;x< strlen(yytext)-1;x++){
		printf("%c",yytext[x]);
	}
	printf("\\n\n");
}
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
{number} {printf("T_INTCONSTANT %s\n",yytext);charcount= charcount + yyleng;}
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


{stringescape} {printf("T_STRINGCONSTANT %s\n",yytext);charcount= charcount + yyleng;}

{dquote}\\[^nbtrvab'"\\]{dquote} {fprintf(stderr,"ERROR: Invalid escape character in string constant");return ERROR;}
{dquote}\\{dquote} {fprintf(stderr,"ERROR: Invalid escape character in string constant");return ERROR;}


{stringlit} {printf("T_STRINGCONSTANT %s\n",yytext);charcount= charcount + yyleng;}

{squote}\\{squote} {fprintf(stderr,"ERROR: Invalid escape in char constant");return ERROR;}
({charlit})|({charwithescape}) {printf("T_CHARCONSTANT %s\n",yytext);charcount= charcount + yyleng;}
 

('') {fprintf(stderr,"Empty char constant at line %i and position %i\n",linecount,charcount + yyleng); return ERROR;}

{squote}..{squote} {fprintf(stderr,"Invalid char constant length at line %i and position %i\n",linecount,charcount + yyleng);return ERROR;} 
(.) {fprintf(stderr,"ERROR at line %i position %i \n",linecount, charcount + yyleng);return ERROR;}
%%



int main (){
int token;
int position;
int line=1;

 
 if(yylex() == ERROR){exit(1);}
 else{exit(0);}
        
	


}

	        

