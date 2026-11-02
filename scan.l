
%{
#include <stdio.h>
#include <stdlib.h>
#include "pars.tab.h"
%}

%option noyywrap

%%

[0-9]+(\.[0-9]+)?  {
    yylval.number = atof(yytext);
    return NUMBER;
}

"+"       { return '+'; }
"-"       { return '-'; }
"*"       { return '*'; }
"/"       { return '/'; }

"("       { return '('; }
")"       { return ')'; }

"|"       { return '|'; }

[ \t\r]+  { /* Ignore whitespace */ }

\n        { return EOL; }

.         { return INVALID; }

%%
