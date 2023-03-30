#ifndef __INSTRUCTIONS_LST_H__
#define __INSTRUCTIONS_LST_H__

#include "instructions.h"

typedef struct instruction_list_node_type {
    instruction_t* instruction;
    struct instruction_list_node_type* next;
} instruction_list_node_t;

typedef struct instruction_list_type{
    instruction_list_node_t* head;
    instruction_list_node_t* tail;
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
    symbol_t* variable_name;
    symbol_t* start_expression;
    symbol_t* end_expression;
    symbol_t* step_expression;
    instruction_list_t* loop_instructions;
} for_loop_data_t;

instruction_list_t* new_instruction_list();

instruction_list_node_t* new_instruction_list_node(instruction_t* instruction);

void add_instruction(instruction_list_t* list, instruction_t* instruction);

void remove_first_instruction(instruction_list_t* list);

void clear_instruction_list(instruction_list_t* list);

int get_instruction_list_length(instruction_list_t* list);



#endif 
/* __INSTRUCTIONS_LST_H__ */