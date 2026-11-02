
%{
#include <stdio.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);
%}

%define parse.error verbose

%union {
    double number;
}

%token <number> NUMBER
%token EOL INVALID

%type <number> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

input:
      %empty
    | input line
    ;

line:
      EOL
    | expr EOL {
          if (isnan($1))
              printf("Error: Division by zero\n");
          else
              printf("Result: %g\n", $1);
      }
    | error EOL {
          printf("Invalid expression. Try again.\n");
          yyerrok;
      }
    ;

expr:
      NUMBER {
          $$ = $1;
      }

    | expr '+' expr {
          $$ = $1 + $3;
      }

    | expr '-' expr {
          $$ = $1 - $3;
      }

    | expr '*' expr {
          $$ = $1 * $3;
      }

    | expr '/' expr {
          if ($3 == 0)
              $$ = NAN;
          else
              $$ = $1 / $3;
      }

    | '-' expr %prec UMINUS {
          $$ = -$2;
      }

    | '(' expr ')' {
          $$ = $2;
      }

    | '|' expr '|' {
          $$ = fabs($2);
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main(void) {
    return yyparse();
}
