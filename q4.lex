%{
#include <stdio.h>
#include <math.h>
#include <string.h>
#define T_AND 256
#define T_ASSIGN 257
#define T_BOOLTYPE 258
#define T_BREAK 259
#define T_CHARCONSTANT 260
#define T_CLASS 261
#define T_COMMENT 262
#define T_COMMA 263
#define T_CONTINUE 264
#define T_DIV 265
#define T_DOT 266
#define T_ELSE 267
#define T_EQ 268
#define T_EXTENDS 269
#define T_EXTERN 270
#define T_FALSE 271
#define T_FOR 272
#define T_GEQ 273
#define T_GT 274
#define T_IF 275
#define T_INTCONSTANT 276
#define T_INTTYPE 277
#define T_LCB 278
#define T_LEFTSHIFT 279
#define T_LEQ 280
#define T_LPAREN 281
#define T_LSB 282
#define T_LT 283
#define T_MINUS 284
#define T_MOD 285
#define T_MULT 286
#define T_NEQ 287
#define T_NEW 288
#define T_NOT 289
#define T_NULL 290
#define T_OR 291
#define T_PLUS 292
#define T_RCB 293
#define T_RETURN 294
#define T_RIGHTSHIFT 295
#define T_RPAREN 296
#define T_RSB 297
#define T_SEMICOLON 298
#define T_STRINGTYPE 299
#define T_STRINGCONSTANT 300
#define T_TRUE 301
#define T_VOID 302
#define T_WHILE 303
#define T_ID 304
#define T_WHITESPACE 305
%}

squote \'
dquote \"
id   [A-Za-z0-9_]+
num [0-9]+
stringlit {dquote}(.*)+{dquote}
charlit ({squote}(.*){squote})+

%%
"&&"  {return T_AND;}
"="  {return T_ASSIGN;}
bool  {return T_BOOLTYPE;}
break     {return T_BREAK;}
{charlit}    {return T_CHARCONSTANT;}
class   {return T_CLASS;}
"{"[^}\n]*"}"  {return T_COMMENT;}
","     {return T_COMMA;}
continue     {return T_CONTINUE;}
"/"   {return T_DIV;}
"."  {return T_DOT;}
else     {return T_ELSE;}
"=="      {return T_EQ ;}
extends {return T_EXTENDS;}
extern  {return T_EXTERN;}
false     {return T_FALSE;}
for     {return T_FOR;}
">="   {return T_GEQ;}
">" {return T_GT;}
if     {return T_IF ;}
{num}    {return T_INTCONSTANT;}
int  {return T_INTTYPE;}
(\{)  {return T_LCB;}
"["    {return T_LSB ; }
[(]     { return T_LPAREN;} 
"<"    {return T_LT;}
"-"  {return T_MINUS;}
"*" {return T_MULT;}
"!=" {return T_NEQ;}
new    {return T_NEW;}
"!"     {return T_NOT ;}
"||"  {return T_OR;}
[\+]  {return T_PLUS;}
(\})     {return T_RCB ;}
return   {return T_RETURN;}
">>"  {return T_RIGHTSHIFT;}
"<<"	{return T_LEFTSHIFT;}	
[)]     {return T_RPAREN ;}
"]"    {return T_RSB;}
";"   {return T_SEMICOLON ;}
string {return T_STRINGTYPE;}
{stringlit}     {return T_STRINGCONSTANT;}
true     {return T_TRUE;}
void   {return T_VOID ;}
{id}  {return T_ID ;}
"while"  {return T_WHILE;}	
[ \n\t\r]+  {return T_WHITESPACE ;}
. {return -1;}
%%


int main (){
int token;
while((token = yylex())){
switch(token){
case T_AND: {printf("T_AND %s\n",yytext);} break;
case T_ASSIGN: {printf("T_ASSIGN %s\n",yytext);} break;
case T_BOOLTYPE: {printf("T_BOOLTYPE %s\n",yytext);} break;
case T_BREAK: {printf("T_BREAK %s\n",yytext);} break;
case T_CHARCONSTANT: {printf("T_CHARCONSTANT %s\n",yytext);} break;
case T_CLASS: {printf("T_CLASS %s\n",yytext);} break;
case T_COMMA: {printf("T_COMMA %s\n",yytext);} break;
case T_CONTINUE: {printf("T_CONTINUE %s\n",yytext);} break;
case T_DIV: {printf("T_DIV %s\n",yytext);} break;
case T_DOT: {printf("T_DOT %s\n",yytext);} break;
case T_ELSE: {printf("T_ELSE %s\n",yytext);} break;
case T_EQ: {printf("T_EQ %s\n",yytext);} break;
case T_EXTENDS: {printf("T_EXTENDS %s\n",yytext);} break;
case T_FALSE: {printf("T_FALSE %s\n",yytext);} break;
case T_FOR: {printf("T_FOR %s\n",yytext);} break;
case T_GEQ: {printf("T_GEQ %s\n",yytext);} break;
case T_GT: {printf("T_GT %s\n",yytext);} break; 
case T_IF: {printf("T_IF %s\n",yytext);} break;
case T_INTCONSTANT: {printf("T_INTCONSTANT %s\n",yytext);} break;
case T_INTTYPE: {printf("T_INTTYPE %s\n",yytext);} break;
case T_LCB: {printf("T_LCB %s\n",yytext);} break;
case T_LEFTSHIFT: {printf("T_LEFTSHIFT %s\n",yytext);} break;
case T_LEQ: {printf("T_LEQ %s\n",yytext);} break;
case T_LPAREN: {printf("T_LPAREN %s\n",yytext);} break;
case T_LSB: {printf("T_LSB %s\n",yytext);} break;
case T_RPAREN: {printf("T_RPAREN %s\n",yytext);} break;
case T_MOD: {printf("T_MOD %s\n",yytext);} break;
case T_MULT: {printf("T_MULT %s\n",yytext);} break;
case T_MINUS: {printf("T_MINUS %s\n",yytext);} break;
case T_NEQ: {printf("T_NEQ %s\n",yytext);} break;
case T_NEW: {printf("T_NEW %s\n",yytext);} break;
case T_NOT: {printf("T_NOT %s\n",yytext);} break;
case T_NULL: {printf("T_NULL %s\n",yytext);} break;
case T_OR: {printf("T_OR %s\n",yytext);} break;
case T_PLUS: {printf("T_PLUS %s\n",yytext);} break;
case T_RCB: {printf("T_RCB %s\n",yytext);} break;
case T_RIGHTSHIFT: {printf("T_RIGHTSHIFT %s\n",yytext);} break;
case T_SEMICOLON: {printf("T_SEMICOLON %s\n",yytext);} break;
case T_STRINGCONSTANT: {printf("T_STRINGCONSTANT %s\n",yytext);} break;
case T_TRUE: {printf("T_TRUE %s\n",yytext);} break;
case T_VOID: {printf("T_VOID %s\n",yytext);} break;
case T_WHILE: {printf("T_WHILE %s\n",yytext);} break;
case T_ID: {printf("T_ID %s\n",yytext);} break;
case T_WHITESPACE: {printf("T_WHITESPACE %s\n",yytext);}break; 
default: printf("Error: %s not recognized\n", yytext);
}    
}
exit(0);
}
