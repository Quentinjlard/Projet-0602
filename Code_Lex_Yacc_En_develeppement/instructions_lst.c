#include <stdlib.h>
#include <stdio.h>

#include "instructions_lst.h"

instruction_list_t* new_instruction_list() {
    instruction_list_t* list = (instruction_list_t*)malloc(sizeof(instruction_list_t));
    list->head = NULL;
    list->tail = NULL;
    return list;
}

instruction_list_node_t* new_instruction_list_node(instruction_t* instruction) {
    instruction_list_node_t* node = (instruction_list_node_t*)malloc(sizeof(instruction_list_node_t));
    node->instruction = instruction;
    node->next = NULL;
    return node;
}

void add_instruction(instruction_list_t* list, instruction_t* instruction) {
    instruction_list_node_t* node = new_instruction_list_node(instruction);
    if (list->tail == NULL) {
        list->head = node;
        list->tail = node;
    }
    else {
        list->tail->next = node;
        list->tail = node;
    }
}

void remove_first_instruction(instruction_list_t* list) {
    if (list->head != NULL) {
        instruction_list_node_t* node = list->head;
        list->head = node->next;
        if (list->tail == node) {
            list->tail = NULL;
        }
        free(node->instruction->data);
        free(node->instruction);
        free(node);
    }
}

void clear_instruction_list(instruction_list_t* list) {
    while (list->head != NULL) {
        remove_first_instruction(list);
    }
}

int get_instruction_list_length(instruction_list_t* list) {
    int length = 0;
    instruction_list_node_t* current = list->head;
    while (current != NULL) {
        length++;
        current = current->next;
    }
    return length;
}
