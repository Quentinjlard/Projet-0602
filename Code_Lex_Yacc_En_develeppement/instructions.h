/**
 * @file instrcutions.h
 * @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
 * @brief 
 * @version 0.1
 * @date 2023-03-22
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef __INSTRUCTIONS_H__
#define __INSTRUCTIONS_H__

#include "symbol.h"
#include "block.h"

typedef enum instruction_type_type{
    CALL_PROCEDURE_INSTRUCTION,
    ASSIGNMENT_INSTRUCTION,
    CONDITIONAL_INSTRUCTION,
    WHILE_LOOP_INSTRUCTION,
    FOR_LOOP_INSTRUCTION,
    LADDER_INSTRUCTION,
    RECT_INSTRUCTION,
    FRECT_INSTRUCTION,
    HLINE_INSTRUCTION,
    VLINE_INSTRUCTION,
    GATE_INSTRUCTION,
    PUT_INSTRUCTION
} instruction_type_t;

typedef struct ladder_data_type{
    symbol_t* x;
    symbol_t* y;
    symbol_t* h;
} ladder_data_t;

typedef struct rect_data_type{
    symbol_t* x1;
    symbol_t* y1;
    symbol_t* x2;
    symbol_t* y2;
    char* block;
} rect_data_t;

typedef struct frect_data_type{
    symbol_t* x1;
    symbol_t* y1;
    symbol_t* x2;
    symbol_t* y2;
    char* block;
} frect_data_t;

typedef struct hline_data_type{
    symbol_t* x;
    symbol_t* y;
    symbol_t* l;
    char* block;
} hline_data_t;

typedef struct vline_data_type{
    symbol_t* x;
    symbol_t* y;
    symbol_t* l;
    char* block;
} vline_data_t;

typedef struct gate_data_type{
    int x;
    int y;
    int n;
} gate_data_t;


typedef struct instruction_type{
    instruction_type_t type;
    void* data;
} instruction_t;

instruction_t* create_instruction(instruction_type_t type,void* data);

void print_instruction(instruction_t* instruction);

#endif