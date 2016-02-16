%{

#include <stdlib.h>
#include <string.h>
#define ID 256
%}



%%

"+"		{printf("PLUS");};
"*"		{printf("TIMES");};
"("		{printf("LPAREN");};
")"		{printf("RPAREN");};

[a-zA-Z][a-zA-Z0-9]*    { return ID; } /*needs to be as the decaf specification*/

%%

int main(void) {
  int token;
  while ((token = yylex())) {
    switch (token) {
      case ID: printf("ID %s", yytext); break;
      default: printf("Error: %s not recognized\n", yytext);
    }
  }
  exit(0);
}
