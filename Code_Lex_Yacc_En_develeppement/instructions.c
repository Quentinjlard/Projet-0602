#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "instructions.h"
#include "instructions_lst.h"

instruction_t* create_instruction(instruction_type_t type,void* data) {
    instruction_t* instruction = (instruction_t*)malloc(sizeof(instruction_t));
    instruction->type = type;
    instruction->data = data;
    return instruction;
}

void print_instruction(instruction_t* instruction) {
    if(instruction == NULL) {
        printf("Null instruction\n");
        return;
    }

    switch(instruction->type) {
        case CALL_PROCEDURE_INSTRUCTION:
            printf("CALL PROCEDURE\n");
            break;
        case ASSIGNMENT_INSTRUCTION:
            printf("ASSIGNMENT\n");
            break;
        case CONDITIONAL_INSTRUCTION:
            printf("CONDITIONAL\n");
            break;
        case WHILE_LOOP_INSTRUCTION:
            printf("WHILE LOOP\n");
            break;
        case FOR_LOOP_INSTRUCTION:
            printf("FOR LOOP\n");
            for_loop_data_t* for_loop_data = (for_loop_data_t*)instruction->data;
            if (instruction->data != NULL) {
                for_loop_data = (for_loop_data_t*)instruction->data;
            }
            if (for_loop_data != NULL) {
                printf("  Variable : %s - %d\n", symbol_get_name(for_loop_data->variable), symbol_get_value(for_loop_data->variable));
                printf("  Start : %s - %d\n", symbol_get_name(for_loop_data->start), symbol_get_value(for_loop_data->start));
                printf("  End : %s - %d\n", symbol_get_name(for_loop_data->end), symbol_get_value(for_loop_data->end));
                printf("  STEP : %d\n", for_loop_data->step);
            }
            break;
        case LADDER_INSTRUCTION:
            printf("LADDER\n");
            ladder_data_t* ladder_data = NULL;
            if (instruction->data != NULL) {
                ladder_data = (ladder_data_t*)instruction->data;
            }
            if (ladder_data != NULL) {
                printf("  x: %s - %d\n", symbol_get_name(ladder_data->x), symbol_get_value(ladder_data->x));
                printf("  y: %s - %d\n", symbol_get_name(ladder_data->y), symbol_get_value(ladder_data->y));
                printf("  h: %s - %d\n", symbol_get_name(ladder_data->h), symbol_get_value(ladder_data->h));
            }
            break;
        case RECT_INSTRUCTION:
            printf("RECT\n");
            rect_data_t* rect_data = (rect_data_t*)instruction->data;
            printf("  x1: %s - %d\n", symbol_get_name(rect_data->x1), symbol_get_value(rect_data->x1));
            printf("  y1: %s - %d\n", symbol_get_name(rect_data->y1), symbol_get_value(rect_data->y1));
            printf("  x2: %s - %d\n", symbol_get_name(rect_data->x2), symbol_get_value(rect_data->x2));
            printf("  y2: %s - %d\n", symbol_get_name(rect_data->y2), symbol_get_value(rect_data->y2));
            printf("  block: %s\n", rect_data->block);
            break;
        case frect:
            printf("FRECT\n");
            frect_data_t* frect_data = (frect_data_t*)instruction->data;
            printf("  x1: %s - %d\n", symbol_get_name(frect_data->x1), symbol_get_value(frect_data->x1));
            printf("  y1: %s - %d\n", symbol_get_name(frect_data->y1), symbol_get_value(frect_data->y1));
            printf("  x2: %s - %d\n", symbol_get_name(frect_data->x2), symbol_get_value(frect_data->x2));
            printf("  y2: %s - %d\n", symbol_get_name(frect_data->y2), symbol_get_value(frect_data->y2));
            printf("  block: %s\n", frect_data->block);
            break;
        case HLINE_INSTRUCTION:
            printf("HLINE\n");
            hline_data_t* hline_data = (hline_data_t*)instruction->data;
            printf("  x: %s - %d\n", symbol_get_name(hline_data->x), symbol_get_value(hline_data->x));
            printf("  y: %s - %d\n", symbol_get_name(hline_data->y), symbol_get_value(hline_data->y));
            printf("  l: %s - %d\n", symbol_get_name(hline_data->l), symbol_get_value(hline_data->l));
            printf("  block: %s\n", hline_data->block);
            break;
        case vline:
            printf("VLINE\n");
            vline_data_t* vline_data = (vline_data_t*)instruction->data;
            printf("  x: %s - %d\n", symbol_get_name(vline_data->x), symbol_get_value(vline_data->x));
            printf("  y: %s - %d\n", symbol_get_name(vline_data->y), symbol_get_value(vline_data->y));
            printf("  l: %s - %d\n", symbol_get_name(vline_data->l), symbol_get_value(vline_data->l));
            printf("  block: %s\n", vline_data->block);
            break;
        case GATE_INSTRUCTION:
            printf("GATE\n");
            gate_data_t* gate_data = (gate_data_t*)instruction->data;
            printf("  x: %s - %d\n", symbol_get_name(gate_data->x), symbol_get_value(gate_data->x));
            printf("  y: %s - %d\n", symbol_get_name(gate_data->y), symbol_get_value(gate_data->y));
            printf("  n: %s - %d\n", symbol_get_name(gate_data->n), symbol_get_value(gate_data->n));
            break;
        case PUT_INSTRUCTION:
            printf("PUT\n");
            put_data_t* put_data = (put_data_t*)instruction->data;
            printf("  x: %s - %d\n", symbol_get_name(put_data->x), symbol_get_value(put_data->x));
            printf("  y: %s - %d\n", symbol_get_name(put_data->y), symbol_get_value(put_data->y));
            printf("  block: %s\n", put_data->block);
            break;
        default:
            printf("Unknown instruction\n");
            break;
    }
}