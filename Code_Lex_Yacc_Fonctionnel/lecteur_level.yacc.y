%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <wchar.h>

    #include "symbol_table.h"
    
    #include "block.h"
    #include "level.h"

    #include "y.tab.h"

    table_t* tableSymbol;
    
    level_t level;
    block_t block;

    void yyerror(const char *msg);
    
%}

%union {
    block_t block;
    int value;
    int coordX;
    int coordY;
    char* lettre;
}

%token LEVEL END

%token EMPTY_YACC BLOCK_YACC TRAP_YACC LIFE_YACC BOMB_YACC DOOR_YACC ENTER_YACC EXIT_YACC LADDER_YACC ROBOT_YACC PROBE_YACC KEY_YACC GATE_YACC
%token BLOCK_VAL_YACC

%token GET


%token PARO PARF VIRG PUT NUM


%token ADDITION SOUSTRACTION DIVISION MULTIPLICATION EGALE

%token IDENTIFIER

%%

file: level_file_list
    ;

level_file_list: level_file
                | level_file_list level_file
            ;

level_file: LEVEL 
                {
                    //printf("Table \n");
                    tableSymbol = table_create();
                    //table_display(tableSymbol);
                    //printf("Level \n");
                    level_init(&level);
                    //level_display(&level);
                } 
                instruction_list
        ;

instruction_list :  instruction
            |   instruction_list instruction
            |   END
            {
                    printf("Level : \n");
                    level_display(&level);
                    table_display(tableSymbol);
                    table_delete(tableSymbol);
                }
            ;


instruction :   instructionPUTNombre
            |   instructionPUTVariable
            |   instructionAffectation
            ;


instructionPUTNombre : 
    PUT PARO expression VIRG  
    {
        // Création d'une nouvelle structure block_t
        block_t b;
        // Affectation des coordonnées X et Y
        b.coordX = $3.value;
        yyval.block = b;
        // printf("1) X : %d - Y :  %d\n", b.coordX, b.coordY);
    } 
    expression VIRG 
    {
        // Création d'une nouvelle structure block_t
        block_t b;
        // Affectation des coordonnées X et Y
        b.coordY = $6.value;
        yyval.block = b;
        // printf("2) X : %d - Y : %d \n",b.coordX, b.coordY);
    }
    instructionBlock PARF
    ;

instructionPUTVariable :
    PUT PARO IDENTIFIER VIRG
    {
        symbol_t *sym1, *var1, *symbol1;

        sym1 = table_search(tableSymbol, $3.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        block_t b;
        b.coordX = var1->value;
        yyval.block = b;
    } expression VIRG 
    {
        block_t b;
        b.coordY = $6.value;
        yyval.block = b;
    }
    instructionBlock PARF
    |
    PUT PARO expression  VIRG
    {
        block_t b;
        b.coordX = $3.value;
        yyval.block = b;
    } IDENTIFIER VIRG 
    {
        symbol_t *sym1, *var1, *symbol1;

        sym1 = table_search(tableSymbol, $3.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        block_t b;
        b.coordY = var1->value;
        yyval.block = b;
    }
    instructionBlock PARF
    |
        PUT PARO IDENTIFIER  VIRG
    {
        symbol_t *sym1, *var1, *symbol1;

        sym1 = table_search(tableSymbol, $3.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        block_t b;
        b.coordX = var1->value;
        yyval.block = b;
    } IDENTIFIER VIRG 
    {
        symbol_t *sym1, *var1, *symbol1;

        sym1 = table_search(tableSymbol, $3.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        block_t b;
        b.coordY = var1->value;
        yyval.block = b;
    }
    instructionBlock PARF
    ;


instructionAffectation :
    IDENTIFIER EGALE NUM // X = 1
    {
        //printf("%s - %d\n", $1.lettre, $3.value);
        symbol_t* symbol = symbol_create($1.lettre, $3.value);
        //symbol_display(symbol);
        //lst_symbol_t* lst = lst_symbol_create(symbol);
        //lst_symbol_display(lst);
        table_add(tableSymbol, symbol);
        //table_display(tableSymbol);
        //printf("---------------------------------------------------------------- \n");
    }
    | IDENTIFIER EGALE IDENTIFIER ADDITION NUM  // X = X + 1 OU X = Y + 1
    {
        symbol_t *sym1, *var1, *symbol1;
        symbol_t *sym2, *var2, *symbol2;

        sym1 = table_search(tableSymbol, $1.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($1.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        sym2 = table_search(tableSymbol, $3.lettre);
        if (sym2 == NULL) {
            symbol2 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol2);
            var2 = symbol2;
        } else {
            var2 = sym2;
        }

        int res = var2->value + $5.value;
        // printf("X = X + 1 => RES : %d = %d + %d + %d \n", res, var1->value, var2->value, $5.value);

        // table_display(tableSymbol);

        symbol_set_value(var1, res);
    }
    | IDENTIFIER EGALE IDENTIFIER ADDITION IDENTIFIER // X = X + Y
    {
        symbol_t *sym1, *var1, *symbol1;
        symbol_t *sym2, *var2, *symbol2;
        symbol_t *sym3, *var3, *symbol3;

        sym1 = table_search(tableSymbol, $1.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($1.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        sym2 = table_search(tableSymbol, $3.lettre);
        if (sym2 == NULL) {
            symbol2 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol2);
            var2 = symbol2;
        } else {
            var2 = sym2;
        }

        sym3 = table_search(tableSymbol, $5.lettre);
        if (sym3 == NULL) {
            symbol3 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol3);
            var3 = symbol2;
        } else {
            var3 = sym3;
        }

        var1->value = var1->value + var2->value + var3->value;
        // printf("X = X + Y => RES : %d = %d + %d + %d \n", var1->value, var1->value, var2->value, var3->value);

        // table_display(tableSymbol);

        symbol_set_value(var1, var1->value);
    }
    | IDENTIFIER EGALE IDENTIFIER   // X = X ou X = Y
    {
        symbol_t *sym1, *var1, *symbol1;
        symbol_t *sym2, *var2, *symbol2;

        sym1 = table_search(tableSymbol, $1.lettre);
        if (sym1 == NULL) {
            symbol1 = symbol_create($1.lettre, 0);
            table_add(tableSymbol, symbol1);
            var1 = symbol1;
        } else {
            var1 = sym1;
        }

        sym2 = table_search(tableSymbol, $3.lettre);
        if (sym2 == NULL) {
            symbol2 = symbol_create($3.lettre, 0);
            table_add(tableSymbol, symbol2);
            var2 = symbol2;
        } else {
            var2 = sym2;
        }

        var1->value = var2->value;
        // printf("X = X => %d = %d \n", var1->value, var2->value);

        // table_display(tableSymbol);

        symbol_set_value(var1, var1->value);
    }
    ;

instructionBlock : 
                    block
                    {
                        // printf("Block ! \n");
                    }
                    |
                    GET PARO NUM VIRG NUM PARF 
                    {
                        // printf("GET ! \n");
                        // printf("X : %2d - Y : %2d \n", $3.value , $5.value);
                        int x = $3.value ;
                        int y = $5.value ;
                        get_block(&level, x, y);
                        // print_block_type(block);
                    }
                    ;

expression : 
    | NUM ADDITION NUM	{ $$.value = $1.value + $3.value; }
	| NUM SOUSTRACTION NUM	{ $$.value = $1.value - $3.value; }
	| '-' NUM			{ $$.value = -$2.value; }
	| NUM MULTIPLICATION NUM	{ $$.value = $1.value * $3.value; }
	| NUM DIVISION NUM	{
		if ($3.value == 0) {
			printf("Error: division by zero : %d / %d\n", $1.value, $3.value);
            exit(1);
		}
		else
			$$.value = $1.value / $3.value;
	}
	| '(' NUM ')'		{ $$.value = $2.value; }
    | NUM { $$.value = $1.value;}
    | NUM EGALE NUM { $$.value = $3.value;}
	;

block: BLOCK_YACC 
                    {
                        block_t b;
                        b.type = BLOCK;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : ", b.coordX, b.coordY, b.value);
                        level_add_block(&level, b.coordX,  b.coordY);
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : %s \n", b.coordX, b.coordY, b.value, print_block_type(b));
                    }
     | TRAP_YACC 
                    {
                        block_t b;
                        b.type = TRAP;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : TRAP \n", b.coordX, b.coordY, b.value);
                        level_add_trap(&level, b.coordX,  b.coordY);
                    }
     | LIFE_YACC
                    {
                        block_t b;
                        b.type = LIFE;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : LIFE \n", b.coordX, b.coordY, b.value);
                        level_add_life(&level, b.coordX,  b.coordY);
                    }
     | BOMB_YACC 
                    {
                        block_t b;
                        b.type = BOMB;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : BOMB \n", b.coordX, b.coordY, b.value);
                        level_add_bomb(&level, b.coordX,  b.coordY);
                    }
     | DOOR_YACC PARO expression PARF
                    {   
                        block_t b;
                        b.type = DOOR;
                        b.value = $3.value;

                        if (b.value < 0 || b.value > 100) {
                            fprintf(stderr, "Invalid door number: %2d\n", b.value);
                            exit(EXIT_FAILURE);
                        }

                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : DOOR \n", b.coordX, b.coordY, b.value);
                        level_add_door(&level, b.coordX, b.coordY, b.value);
                    }
     | ENTER_YACC 
                    {
                        block_t b;
                        b.type = ENTER;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : ENTER \n", b.coordX, b.coordY, b.value);
                        level_add_start(&level, b.coordX,  b.coordY);
                    }
     | EXIT_YACC 
                    {
                        block_t b;
                        b.type = EXIT;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : EXIT \n", b.coordX, b.coordY, b.value);
                        level_add_exit(&level, b.coordX,  b.coordY);
                    }
     | LADDER_YACC 
                    {
                        block_t b;
                        b.type = LADDER;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : LADDER \n", b.coordX, b.coordY, b.value);
                        level_add_ladder(&level, b.coordX,  b.coordY);
                    }
     | ROBOT_YACC 
                    {
                        block_t b;
                        b.type = ROBOT;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : ROBOT \n", b.coordX, b.coordY, b.value);
                        level_add_robot(&level, b.coordX,  b.coordY);
                    }
     | PROBE_YACC 
                    {
                        block_t b;
                        b.type = PROBE;
                        b.value = 0; // Valeur par défaut
                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : PROBE \n", b.coordX, b.coordY, b.value);
                        level_add_probe(&level, b.coordX,  b.coordY);
                    }
     | KEY_YACC PARO expression PARF
                    {
                        block_t b;
                        b.type = KEY;
                        b.value = $3.value;

                        if (b.value < 0 || b.value > 4) {
                            fprintf(stderr, "Invalid key number: %2d\n", b.value);
                            exit(EXIT_FAILURE);
                        }

                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : KEY \n", b.coordX, b.coordY, b.value);
                        level_add_key(&level, b.coordX, b.coordY, b.value);
                    }
     | GATE_YACC PARO expression PARF 
                    {
                        block_t b;
                        b.type = GATE;
                        b.value = $3.value;

                        if (b.value < 0 || b.value > 4) {
                            fprintf(stderr, "Invalid gate number: %2d\n", b.value);
                            exit(EXIT_FAILURE);
                        }

                        yyval.block = b;
                        b.coordX = yyval.block.coordX;
                        b.coordY = yyval.block.coordY;
                        // printf("X : %2d - Y : %2d - Value : %2d - Block Name : GATE \n", b.coordX, b.coordY, b.value);
                        level_add_gate(&level, b.coordX, b.coordY, b.value);
                    }
            ;

%%

