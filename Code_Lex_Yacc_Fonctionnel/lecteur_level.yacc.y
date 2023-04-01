    %{
        #include <stdio.h>
        #include <stdlib.h>
        #include <wchar.h>
        #include <string.h>

        #include "instructions_lst.h"
        
        #include "symbol_table.h"
        
        #include "block.h"
        #include "level.h"

        #include "y.tab.h"

        instruction_list_t* listeInstruction = NULL;
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
                        /* clear_instruction_list(listeInstruction); */
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
                            /* printf("=> LADDER instruction \n"); */
                                if (listeInstruction == NULL)
                                    listeInstruction = create_list();
                                if(tableSymbol == NULL)
                                    tableSymbol = table_create();                                
                                // table_display(tableSymbol);
                        }    LADDER_PROC FOR_LOOP_PROC PUT_PROC END
                    |   PRC_YACC{
                                /* printf("\n=> REC instruction \n"); */
                                if (listeInstruction == NULL)
                                    listeInstruction = create_list();
                                if(tableSymbol == NULL)
                                    tableSymbol = table_create();
                                // table_display(tableSymbol);
                        }       RECT_PROC FOR_LOOP_PROC PUT_PROC PUT_PROC END FOR_LOOP_PROC PUT_PROC PUT_PROC END
                    |   PRC_YACC{
                                /* printf("\n=> FREC instruction \n"); */
                                if (listeInstruction == NULL)
                                    listeInstruction = create_list();
                                if(tableSymbol == NULL)
                                    tableSymbol = table_create();
                                // table_display(tableSymbol);
                        }       FRECT_PROC FOR_LOOP_PROC FOR_LOOP_PROC PUT_PROC END END
                    |   PRC_YACC{
                                /* printf("\n=> HLINE instruction \n"); */
                                if (listeInstruction == NULL)
                                    listeInstruction = create_list();
                                if(tableSymbol == NULL)
                                    tableSymbol = table_create();
                                // table_display(tableSymbol);
                                

                        }       HLINE_PROC FOR_LOOP_PROC PUT_PROC END   
                    |   PRC_YACC{
                                /* printf("\n=> VLINE instruction \n"); */
                                if (listeInstruction == NULL)
                                    listeInstruction = create_list();
                                if(tableSymbol == NULL)
                                    tableSymbol = table_create();
                                // table_display(tableSymbol);
                        }       VLINE_PROC FOR_LOOP_PROC PUT_PROC END
                    |   END
                    {
                        print_instruction_list(listeInstruction);
                        printf("\n \n ");
                    }
                    | level_file
                    ;
        ;

    LADDER_PROC : LADDER_PRC_YACC PARO affectation VIRG affectation VIRG affectation PARF {
                    /* printf("LADDER_PRC \n"); */
                    symbol_t* symbolX = table_search(tableSymbol, "x");
                    symbol_t* symbolY = table_search(tableSymbol, "y");
                    symbol_t* symbolH = table_search(tableSymbol, "h");
                    
                    ladder_data_t* data = (ladder_data_t*)malloc(sizeof(ladder_data_t));
                    
                    data->x = symbolX;
                    data->y = symbolY;
                    data->h = symbolH;

                    
                    instruction_t* ladderIsntruction = create_instruction(LADDER_INSTRUCTION, data);
                    /* print_instruction(ladderIsntruction); */
                    instruction_node_t* ladderNode = create_node(ladderIsntruction);
                    add_node_to_list(listeInstruction, ladderNode);

                }
                ;

    RECT_PROC : RECT_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                    /* printf("RECT_PRC \n"); */
                    symbol_t* symbolX1 = table_search(tableSymbol, "x1");
                    symbol_t* symbolX2 = table_search(tableSymbol, "x2");
                    symbol_t* symbolY1 = table_search(tableSymbol, "y1");
                    symbol_t* symbolY2 = table_search(tableSymbol, "y2");
                    symbol_t* symbolB = table_search(tableSymbol, "b");

                    rect_data_t* data = (rect_data_t*)malloc(sizeof(rect_data_t));
                    
                    data->x1 = symbolX1;
                    data->y1 = symbolY1;
                    data->x2 = symbolX2;
                    data->y2 = symbolY2;
                    data->block = symbolB->name;

                    instruction_t* rectInstruction = create_instruction(RECT_INSTRUCTION, data);
                    /* print_instruction(rectInstruction); */

                    instruction_node_t* rectNode = create_node(rectInstruction);
                    add_node_to_list(listeInstruction, rectNode);


                };

    FRECT_PROC : FRECT_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                    /* printf("FRECT_PRC \n"); */
                    symbol_t* symbolX1 = table_search(tableSymbol, "x1");
                    symbol_t* symbolX2 = table_search(tableSymbol, "x2");
                    symbol_t* symbolY1 = table_search(tableSymbol, "y1");
                    symbol_t* symbolY2 = table_search(tableSymbol, "y2");
                    symbol_t* symbolB = table_search(tableSymbol, "b");

                    frect_data_t* data = (frect_data_t*)malloc(sizeof(frect_data_t));
                    
                    data->x1 = symbolX1;
                    data->x2 = symbolX2;
                    data->y1 = symbolY1;
                    data->y2 = symbolY2;
                    data->block = symbolB->name;

                    instruction_t* frectInstruction = create_instruction(FRECT_INSTRUCTION, data);
                    /* print_instruction(frectInstruction); */

                    instruction_node_t* frectNode = create_node(frectInstruction);
                    add_node_to_list(listeInstruction, frectNode);
                };

    HLINE_PROC : HLINE_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                    /* printf("HLINE_PROC \n"); */

                    symbol_t* symbolX = table_search(tableSymbol, "x");
                    symbol_t* symbolY = table_search(tableSymbol, "y");
                    symbol_t* symbolL = table_search(tableSymbol, "l");
                    symbol_t* symbolB = table_search(tableSymbol, "b");

                    hline_data_t* data = (hline_data_t*)malloc(sizeof(hline_data_t));
                    
                    data->x = symbolX;
                    data->y = symbolY;
                    data->l = symbolL;
                    data->block = symbolB->name;

                    instruction_t* hlineInstruction = create_instruction(HLINE_INSTRUCTION, data);
                    /* print_instruction(hlineInstruction); */

                    instruction_node_t* hlineNode = create_node(hlineInstruction);
                    add_node_to_list(listeInstruction, hlineNode);

                };

    VLINE_PROC : VLINE_YACC PARO affectation VIRG affectation VIRG affectation VIRG affectation PARF {
                    /* printf("VLINE_PROC \n"); */

                    symbol_t* symbolX = table_search(tableSymbol, "x");
                    symbol_t* symbolY = table_search(tableSymbol, "y");
                    symbol_t* symbolL = table_search(tableSymbol, "l");
                    symbol_t* symbolB = table_search(tableSymbol, "b");

                    hline_data_t* data = (hline_data_t*)malloc(sizeof(hline_data_t));
                    
                    data->x = symbolX;
                    data->y = symbolY;
                    data->l = symbolL;
                    data->block = symbolB->name;

                    instruction_t* vLineInstruction = create_instruction(VLINE_INSTRUCTION, data);
                    /* print_instruction(vLineInstruction); */

                    instruction_node_t*  vLineNode = create_node(vLineInstruction);
                    add_node_to_list(listeInstruction, vLineNode);

                };

    FOR_LOOP_PROC : 
                FOR_YACC PARO affectation PVRIGULE affectation SUPEGAL SYMBOLE PVRIGULE SYMBOLE EGALE SYMBOLE ADDITION NUM PARF
                {
                    /* printf("1. FOR_LOOP_PROC \n");  */
                
                    symbol_t* symbolX1 = table_search(tableSymbol, "x1");
                    symbol_t* symbolX2 = table_search(tableSymbol, "x2");
                    symbol_t* symbolY1 = table_search(tableSymbol, "y1");
                    symbol_t* symbolY2 = table_search(tableSymbol, "y2");
                    symbol_t* symbolI = table_search(tableSymbol, "i");

                    for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));
                    
                    if(strcmp($7.lettre,"x2") == 0)
                        data->start = symbolX1, data->end = symbolX2;
                    if(strcmp($7.lettre,"y2") == 0)
                        data->start = symbolY1, data->end = symbolY2;

                    data->variable = symbolI;

                    data->step = $13.value;

                    instruction_t* forLoopInstruction = create_instruction(FOR_LOOP_INSTRUCTION, data);
                    /* print_instruction(forLoopInstruction); */
                    
                    instruction_node_t* forLoopNode = create_node(forLoopInstruction);
                    add_node_to_list(listeInstruction,forLoopNode);
                    
                }
                | FOR_YACC PARO affectation PVRIGULE affectation SUPEGAL SYMBOLE ADDITION SYMBOLE SOUSTRACTION NUM PVRIGULE SYMBOLE EGALE SYMBOLE ADDITION NUM PARF
                {
                    /* printf("2. FOR_LOOP_PROC \n"); */
                    for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));
                    symbol_t* end = symbol_create("endLoop", 0);
                    int value = $7.symbol->value + $9.symbol->value - $11.value;
                    table_add(tableSymbol, end);
                    symbol_set_value(end, value);

                    symbol_t* symbolI = table_search(tableSymbol, "i");
                    symbol_t* symbolY = table_search(tableSymbol, "y");

                    data->variable = symbolI;
                    data->start = symbolY;
                    data->end = end;
                    data->step = $17.value;

                    instruction_t* forLoopInstruction = create_instruction(FOR_LOOP_INSTRUCTION, data);
                    /* print_instruction(forLoopInstruction); */
                    instruction_node_t* forLoopNode = create_node(forLoopInstruction);
                    add_node_to_list(listeInstruction,forLoopNode);
                    
                }
                | FOR_YACC PARO affectation PVRIGULE affectation SUP affectation ADDITION affectation PVRIGULE SYMBOLE EGALE SYMBOLE ADDITION NUM PARF
                {
                    /* printf("3. FOR_LOOP_PROC \n"); */

                    symbol_t* symbolI = table_search(tableSymbol, "i");
                    symbol_t* symbolX = table_search(tableSymbol, "x");
                    symbol_t* symbolL = table_search(tableSymbol, "l");
                
                    for_loop_data_t* data = (for_loop_data_t*)malloc(sizeof(for_loop_data_t));
                    symbol_t* symbol = symbol_create("endLoop", 0);
                    int value = symbolX->value + symbolL->value;
                    table_add(tableSymbol, symbol);
                    symbol_set_value(symbol, value);
                    

                    data->variable = symbolI;
                    data->start = symbolX;
                    data->end = symbol;
                    data->step = $15.value;

                    instruction_t* forLoopInstruction = create_instruction(FOR_LOOP_INSTRUCTION, data);
                    /* print_instruction(forLoopInstruction); */
                    instruction_node_t* forLoopNode = create_node(forLoopInstruction);
                    add_node_to_list(listeInstruction,forLoopNode);
                }
                ;

    PUT_PROC : PUT PARO SYMBOLE VIRG SYMBOLE VIRG LADDER_YACC PARF  {

                    symbol_t* symbolX = table_search(tableSymbol, $3.lettre);
                    symbol_t* symbolY = table_search(tableSymbol, $5.lettre);

                    put_data_t* data = (put_data_t*)malloc(sizeof(put_data_t));
                    
                    data->x = symbolX;
                    data->y = symbolY;
                    data->block = $7.lettre;

                    instruction_t* putLadder = create_instruction(PUT_INSTRUCTION, data);
                    instruction_node_t* putLadder_node = create_node(putLadder);
                    add_node_to_list(listeInstruction,putLadder_node);
                    /* print_instruction(putLadder); */
                }
                |
                PUT PARO SYMBOLE VIRG SYMBOLE VIRG SYMBOLE PARF  {
                    /* printf("PUT_PROC \n"); */

                    symbol_t* symbolX = table_search(tableSymbol, $3.lettre);

                    symbol_t* symbolY = table_search(tableSymbol, $5.lettre);

                    put_data_t* data = (put_data_t*)malloc(sizeof(put_data_t));
                    
                    data->x = symbolX;
                    data->y = symbolY;
                    data->block = $7.lettre;

                    instruction_t* putLadder = create_instruction(PUT_INSTRUCTION, data);
                    instruction_node_t* putLadder_node = create_node(putLadder);
                    add_node_to_list(listeInstruction,putLadder_node);
                    /* print_instruction(putProc); */
                    
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

