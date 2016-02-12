%{ 
#include <stdio.h> 
%}

%token NAME NUMBER NEWLINE


%%
statements: statement| statement NEWLINE | statements statement NEWLINE |  statement statements;

statement: NAME '=' expression { printf("%c = %d\n", $1, $3); }
     | expression  { printf("%d\n", $1); }
     ;

expression: expression '+' NUMBER { $$ = $1 + $3; }
     | expression '-' NUMBER { $$ = $1 - $3; }
     | NUMBER '-' NUMBER { $$ = $1 - $3; }
     | NUMBER '+' NUMBER { $$ = $1 + $3; }
     | NUMBER { $$ = $1; }
     ;
%%

