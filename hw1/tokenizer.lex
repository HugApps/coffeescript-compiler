%{
#define T_A  256
#define T_B  257
#define T_C  258
%}

%%
a     {return T_A;}
abb   {return T_B;}
a*b+  {return T_C;}
.     {return -1;}
%%

int main () {
int token;
int first = 1;
while(token = yylex()){
if(!first)
{
printf("\n");
}
else
{
first = 0;
}
switch(token){
case T_A: printf("T_A %s", yytext); break;
case T_B: printf("T_B %s", yytext);  break;
case T_C: printf("T_C %s", yytext);  break;
default: printf("ERROR %s", yytext);   break;
 }

}
exit(0);
}
