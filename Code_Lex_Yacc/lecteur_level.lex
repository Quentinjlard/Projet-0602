%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <wchar.h>
    #include <string.h>
    
    #include "symbol_table.h"

    #include "block.h"
    #include "level.h"
    #include "y.tab.h"

    void yyerror(const char *msg);

%}

/* To avoid warnings on input and yyunput */
%option nounput
%option noinput
%option yylineno

%%
"level"         {return LEVEL; }
"end"           {return END; }

"put"           { return PUT; }
"get"           { return GET; }

"empty"         { return EMPTY_YACC; }
"BLOCK"         { return BLOCK_YACC; }
"TRAP"          { return TRAP_YACC; }
"LIFE"          { return LIFE_YACC; }
"BOMB"          { return BOMB_YACC; }
"DOOR"          { return DOOR_YACC; }
"ENTER"         { return ENTER_YACC; }
"EXIT"          { return EXIT_YACC; }
"LADDER"        { return LADDER_YACC; }
"ROBOT"         { return ROBOT_YACC; }
"PROBE"         { return PROBE_YACC; }
"KEY"           { return KEY_YACC; }
"GATE"          { return GATE_YACC; }

-?[0-9]+        { yylval.value = atoi(yytext); return NUM; }

[a-zA-Z][a-zA-Z0-9]*       { yylval.lettre = strdup(yytext); return IDENTIFIER; }

","             {return VIRG; }

"("             {return PARO; }
")"             {return PARF; }

"+"             { return ADDITION; }
"-"             { return SOUSTRACTION; }
"*"             { return MULTIPLICATION; }
"/"             { return DIVISION; }
"="             { return EGALE; }

\n            { yylineno++; }
[[:space:]]+    {}
.               { fprintf(stderr, "Error: invalid character %s\n", yytext); }

%%

void yyerror(const char *msg)
{
    fprintf(stderr, "Erreur ligne %d : %s\n", yylineno, msg);
}
