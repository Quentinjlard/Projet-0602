%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <wchar.h>

    #include "instructions_lst.h"
    
    #include "symbol_table.h"
    
    #include "block.h"
    #include "level.h"

    #include "y.tab.h"

    instruction_list_t* instruction_list_C = NULL;
    table_t* tableSymbol = NULL;
    
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
    symbol_t* symbol;
}

%token LEVEL END

%token EMPTY_YACC BLOCK_YACC TRAP_YACC LIFE_YACC BOMB_YACC DOOR_YACC ENTER_YACC EXIT_YACC LADDER_YACC ROBOT_YACC PROBE_YACC KEY_YACC GATE_YACC
%token BLOCK_VAL_YACC

%token GET PUT


%token PARO PARF VIRG NUM PVRIGULE
%token SUP

%token ADDITION SOUSTRACTION DIVISION MULTIPLICATION EGALE SUPEGAL

%token SYMBOLE

%token PRC_YACC LADDER_PRC_YACC RECT_YACC FRECT_YACC HLINE_YACC VLINE_YACC 

%token IF_YACC THEN_YACC ELSE_YACC

%token WHILE_YACC DO_YACC FOR_YACC TO_YACC STEP_YACC

%%

file: level_file_list
    | instruction_proc_list
    ;

level_file_list: level_file
                | level_file_list level_file
            ;

instruction_proc_list: instruction_proc
                | instruction_proc_list instruction_proc
                ;

instruction_list :  instruction_list instruction
            |   instruction
            ;

instruction :   instructionPUTNombre
            |   instructionPUTVariable
            |   affectation
            |   END
            {
                    printf("Level : \n");
                    level_display(&level);
                    table_display(tableSymbol);
                    table_delete(tableSymbol);
                }
            ;

level_file: LEVEL 
                {
                    //printf("Table \n");
                    if(tableSymbol == NULL)
                        tableSymbol = table_create();
                    //printf("Level \n");
                    level_init(&level);
                    //level_display(&level);
                } 
                instruction_list
        ;


instruction_proc : 
                
                    PRC_YACC
                    {
                            if (instruction_list_C == NULL)
                                instruction_list_C = new_instruction_list();
                            if(tableSymbol == NULL)
                                tableSymbol = table_create();
                            // table_display(tableSymbol);
                    }    LADDER_PROC FOR_LOOP_PROC PUT_PROC END
                |   PRC_YACC{
                            if (instruction_list_C == NULL)
                                instruction_list_C = new_instruction_list();
                            if(tableSymbol == NULL)
                                tableSymbol = table_create();
                            // table_display(tableSymbol);
                    }       RECT_PROC FOR_LOOP_PROC PUT_PROC PUT_PROC END FOR_LOOP_PROC PUT_PROC PUT_PROC END
                |   PRC_YACC{
                            if (instruction_list_C == NULL)
                                instruction_list_C = new_instruction_list();
                            if(tableSymbol == NULL)
                                tableSymbol = table_create();
                            // table_display(tableSymbol);
                    }       FRECT_PROC FOR_LOOP_PROC FOR_LOOP_PROC PUT_PROC END END
                |   PRC_YACC{
                            if (instruction_list_C == NULL)
                                instruction_list_C = new_instruction_list();
                            if(tableSymbol == NULL)
                                tableSymbol = table_create();
                            // table_display(tableSymbol);
                    }       HLINE_PROC FOR_LOOP_PROC PUT_PROC END   
                |   PRC_YACC{
                            if (instruction_list_C == NULL)
                                instruction_list_C = new_instruction_list();
                            if(tableSymbol == NULL)
                                tableSymbol = table_create();
                            // table_display(tableSymbol);
                    }       VLINE_PROC FOR_LOOP_PROC PUT_PROC END
                | FOR_LOOP_PROC
                |   END
                {
                    table_display(tableSymbol);
                }
                | level_file
                ;
    ;

LADDER_PROC : LADDER_PRC_YACC PARO affectation VIRG affectation VIRG affectation PARF {
                printf("LADDER_PRC \n");
                ladder_data_t* data = (ladder_data_t*)malloc(sizeof(ladder_data_t));
                
                data->x = $3.symbol;
                data->y = $5.symbol;
                data->h = $7.symbol;
                add_instruction(instruction_list_C, create_instruction(LADDER_INSTRUCTION, data));
            }
            ;

RECT_PROC : RECT_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                printf("RECT_PRC \n");
                rect_data_t* data = (rect_data_t*)malloc(sizeof(rect_data_t));
                
                data->x1 = $3.symbol;
                data->y1 = $5.symbol;
                data->x2 = $7.symbol;
                data->y2 = $9.symbol;
                data->block = $11.symbol->name;
                add_instruction(instruction_list_C, create_instruction(RECT_INSTRUCTION, data));
            };

FRECT_PROC : FRECT_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                printf("FRECT_PRC \n");
                rect_data_t* data = (rect_data_t*)malloc(sizeof(rect_data_t));
                
                data->x1 = $3.symbol;
                data->y2 = $5.symbol;
                data->x2 = $7.symbol;
                data->y2 = $9.symbol;
                data->block = $11.symbol->name;
                add_instruction(instruction_list_C, create_instruction(FRECT_INSTRUCTION, data));
            };

HLINE_PROC : HLINE_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                printf("HLINE_PROC \n");
                hline_data_t* data = (hline_data_t*)malloc(sizeof(hline_data_t));
                
                data->x = $3.symbol;
                data->y = $5.symbol;
                data->l = $7.symbol;
                data->block = $9.symbol->name;
                add_instruction(instruction_list_C, create_instruction(HLINE_INSTRUCTION, data));
            };

VLINE_PROC : VLINE_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                printf("VLINE_PROC \n");
                hline_data_t* data = (hline_data_t*)malloc(sizeof(hline_data_t));
                
                data->x = $3.symbol;
                data->y = $5.symbol;
                data->l = $7.symbol;
                data->block = $9.symbol->name;
                add_instruction(instruction_list_C, create_instruction(VLINE_INSTRUCTION, data));
            };

FOR_LOOP_PROC : 
            FOR_YACC PARO affectation PVRIGULE affectation SUPEGAL affectation PVRIGULE affectation PARF
            {
                printf("1. FOR_LOOP_PROC \n");
                for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));

                data->variable = $3.symbol;
                data->start = $5.symbol;
                data->end = $7.symbol;
                data->step = $9.symbol;

                add_instruction(instruction_list_C, create_instruction(FOR_LOOP_INSTRUCTION, data));
            }
            | FOR_YACC PARO affectation PVRIGULE affectation SUPEGAL SYMBOLE ADDITION SYMBOLE SOUSTRACTION NUM PVRIGULE affectation PARF
            {
                printf("2. FOR_LOOP_PROC \n");
                for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));
                symbol_t* symbol = symbol_create("fin_loop", 0);
                int value = $7.symbol->value + $9.symbol->value - $11.value;
                symbol_set_value(symbol, value);

                data->variable = $3.symbol;
                data->start = $5.symbol;
                data->end = symbol;
                data->step = $9.symbol;

                add_instruction(instruction_list_C, create_instruction(FOR_LOOP_INSTRUCTION, data));

            }
            | FOR_YACC PARO affectation PVRIGULE affectation SUP affectation ADDITION affectation PVRIGULE affectation PARF
            {
                printf("3. FOR_LOOP_PROC \n");
                for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));
                symbol_t* symbol = symbol_create("finloop", 0);
                int value = $7.symbol->value + $9.symbol->value;
                symbol_set_value(symbol, value);

                data->variable = $3.symbol;
                data->start = $5.symbol;
                data->end = symbol;
                data->step = $9.symbol;

                add_instruction(instruction_list_C, create_instruction(FOR_LOOP_INSTRUCTION, data));
            }
            ;

PUT_PROC : PUT PARO affectation VIRG affectation VIRG LADDER_YACC PARF  {
                printf("PUT_PROC \n");
                // put_data_t* data = (put_data_t*)malloc(sizeof(put_data_t));
                
                // data->x = $3.symbol;
                // data->y = $5.symbol;
                // data->block = $7.symbol->name;
                // add_instruction(instruction_list_C, create_instruction(PUT_INSTRUCTION, data));
            }
            |
            PUT PARO affectation VIRG affectation VIRG affectation PARF  {
                printf("PUT_PROC \n");
                // put_data_t* data = (put_data_t*)malloc(sizeof(put_data_t));
                
                // data->x = $3.symbol;
                // data->y = $5.symbol;
                // data->block = $7.symbol->name;
                // add_instruction(instruction_list_C, create_instruction(PUT_INSTRUCTION, data));
            }
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
    PUT PARO SYMBOLE VIRG
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
    } SYMBOLE VIRG 
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
        PUT PARO SYMBOLE  VIRG
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
    } SYMBOLE VIRG 
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

affectation : 
            SYMBOLE 
            {
                // printf("Affectation 0 \n");
                symbol_t *sym, *var, *symbol;
                
                sym = table_search(tableSymbol, $1.lettre);
                
                if (sym == NULL) {
                    symbol = symbol_create($1.lettre, 0);
                    table_add(tableSymbol, symbol);
                    var = symbol;
                } else {
                    var = sym;
                }
                symbol_set_value(var, var->value);
                // symbol_display(var);
            }
            |
            SYMBOLE EGALE NUM 
            {
                // printf("Affectation 1 \n");
                symbol_t *sym, *var, *symbol;

                sym = table_search(tableSymbol, $1.lettre);
                if (sym == NULL) {
                    symbol = symbol_create($1.lettre, 0);
                    table_add(tableSymbol, symbol);
                    var = symbol;
                } else {
                    var = sym;
                }

                var->value = $3.value;

                symbol_set_value(var, var->value);
                // symbol_display(var);
            }
            |
            SYMBOLE EGALE SYMBOLE 
            {
                // printf("Affectation 2\n");
                symbol_t *sym, *var, *symbol;
                symbol_t *sym2, *var2, *symbol2;

                sym = table_search(tableSymbol, $1.lettre);
                if (sym == NULL) {
                    symbol = symbol_create($1.lettre, 0);
                    table_add(tableSymbol, symbol);
                    var = symbol;
                } else {
                    var = sym;
                }

                sym2 = table_search(tableSymbol, $3.lettre);
                if (sym2 == NULL) {
                    symbol2 = symbol_create($3.lettre, 0);
                    table_add(tableSymbol, symbol2);
                } else {
                    var2 = sym2;
                }

                symbol_set_value(var, var2->value);
                // symbol_display(var);
            }
            |
            SYMBOLE EGALE SYMBOLE ADDITION NUM {
                // printf("Affectation 3\n");
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

                var1->value = var2->value + $5.value;

                symbol_set_value(var1, var1->value);
                // symbol_display(var1);
            }
            |
            SYMBOLE EGALE SYMBOLE ADDITION SYMBOLE {
                // printf("Affectation 4\n");
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
                    symbol3 = symbol_create($5.lettre, 0);
                    table_add(tableSymbol, symbol3);
                    var3 = symbol3;
                } else {
                    var3 = sym3;
                }

                var1->value = var2->value + var3->value;

                symbol_set_value(var1, var1->value);
                // symbol_display(var1);
            }
            ;

expression : 
    | NUM ADDITION NUM	{ $$.value = $1.value + $3.value; }
	| NUM SOUSTRACTION NUM	{ $$.value = $1.value - $3.value; }
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

