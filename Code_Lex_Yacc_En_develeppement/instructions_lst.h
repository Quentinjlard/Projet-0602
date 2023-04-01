#ifndef __INSTRUCTIONS_LST_H__
#define __INSTRUCTIONS_LST_H__

#include "instructions.h"

typedef struct instruction_list_node_type {
    instruction_t* instruction;
    struct instruction_list_node_type* next;
} instruction_node_t;

typedef struct instruction_list_type{
    instruction_node_t* head;
    instruction_node_t* tail;
} instruction_list_t;

typedef struct call_procedure_data_type{
    char* procedure_name;
    instruction_list_t* arguments;
} call_procedure_data_t;

typedef struct assignment_data_type{
    char* variable_name;
    instruction_t* value_expression;
} assignment_data_t;

typedef struct conditional_data_type{
    instruction_t* condition_expression;
    instruction_list_t* then_instructions;
    instruction_list_t* else_instructions;
} conditional_data_t;

typedef struct while_loop_data_type{
    instruction_t* condition_expression;
    instruction_list_t* loop_instructions;
} while_loop_data_t;

typedef struct for_loop_data_type{
    symbol_t* variable;
    symbol_t* start;
    symbol_t* end;
    int step;
    instruction_list_t* loop_instructions;
} for_loop_data_t;

instruction_list_t* create_list();

instruction_node_t* create_node(instruction_t* instruction);

void add_instruction_to_node(instruction_node_t* node, instruction_t* instruction);

void add_node_to_list(instruction_list_t* list, instruction_node_t* node);

void remove_first_instruction(instruction_list_t* list);

void clear_instruction_list(instruction_list_t* list);

int get_instruction_list_length(instruction_list_t* list);

void print_instruction_list(instruction_list_t* list);

void print_instruction_list_node(instruction_node_t* node);

instruction_node_t* find_instruction_node_by_type(instruction_list_t* list, instruction_type_t type);

#endif 
/* __INSTRUCTIONS_LST_H__ */