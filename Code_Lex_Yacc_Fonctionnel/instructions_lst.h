/**
 * @file instructions_lst.h
 * @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
 * @brief Declaration of a linked list data structure for instructions
 * @version 0.1
 * @date 2023-04-01
 * 
 * @copyright Copyright (c) 2023
 * 
 */

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

/**
 * @brief Create a list object
 * 
 * @return instruction_list_t* Pointer to the newly created list 
 */
instruction_list_t* create_list();

/**
 * @brief Create a node object
 * 
 * @param instruction Pointer to the instruction to be added to the node
 * @return instruction_node_t* Pointer to the newly created node
 */
instruction_node_t* create_node(instruction_t* instruction);

/**
 * @brief Add an instruction to a node
 * 
 * @param node Pointer to the node to which the instruction will be added
 * @param instruction Pointer to the instruction to be added
 */
void add_instruction_to_node(instruction_node_t* node, instruction_t* instruction);

/**
 * @brief Add a node to a list
 * 
 * @param list Pointer to the list to which the node will be added
 * @param node Pointer to the node to be added
 */
void add_node_to_list(instruction_list_t* list, instruction_node_t* node);

/**
 * @brief Remove the first instruction from a list
 * 
 * @param list Pointer to the list from which the first instruction will be removed
 */
void remove_first_instruction(instruction_list_t* list);

/**
 * @brief Remove all instructions from a list
 * 
 * @param list Pointer to the list to be cleared
 */
void clear_instruction_list(instruction_list_t* list);

/**
 * @brief Get the instruction list length object
 * 
 * @param list Pointer to the list whose length will be determined
 * @return int The length of the list
 */
int get_instruction_list_length(instruction_list_t* list);

/**
 * @brief Print the instructions in a list
 * 
 * @param list Pointer to the list to be printed
 */
void print_instruction_list(instruction_list_t* list);

/**
 * @brief Print the instructions in a node
 * 
 * @param node Pointer to the node to be printed
 */
void print_instruction_list_node(instruction_node_t* node);

instruction_node_t* find_instruction_node_by_type(instruction_list_t* list, instruction_type_t type);

#endif 
/* __INSTRUCTIONS_LST_H__ */