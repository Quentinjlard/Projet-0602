#include <stdlib.h>
#include <stdio.h>

#include "instructions_lst.h"

instruction_list_t* create_list() {
    instruction_list_t* list = malloc(sizeof(instruction_list_t));
    list->head = NULL;
    list->tail = NULL;
    return list;
}

instruction_node_t* create_node(instruction_t* instruction) {
    instruction_node_t* node = malloc(sizeof(instruction_node_t));
    node->instruction = instruction;
    node->next = NULL;
    return node;
}

void add_instruction_to_node(instruction_node_t* node, instruction_t* instruction) {
    node->instruction = instruction;
}

void add_node_to_list(instruction_list_t* list, instruction_node_t* node) {
    if (list->head == NULL) {
        list->head = node;
        list->tail = node;
    } else {
        list->tail->next = node;
        list->tail = node;
    }
}

void remove_first_instruction(instruction_list_t* list) {
    if (list->head != NULL) {
        instruction_node_t* node = list->head;
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
    instruction_node_t* current = list->head;
    while (current != NULL) {
        length++;
        current = current->next;
    }
    return length;
}

void print_instruction_list(instruction_list_t* list) {
    if (list == NULL || list->head == NULL) {
        printf("\nEmpty instruction list.\n");
        return;
    }
    printf("\nInstruction list:\n");
    instruction_node_t* current = list->head;
    while (current != NULL) {
        printf("Node:\n");
        print_instruction(current->instruction);
        current = current->next;
    }
}

void print_instruction_list_node(instruction_node_t* node) {
    if (node == NULL) {
        printf("Empty instruction list node.\n");
        return;
    }
    printf("Instruction list node:\n");
    print_instruction(node->instruction);
}

instruction_node_t* find_instruction_node_by_type(instruction_list_t* list, instruction_type_t type) {
    if (list == NULL || list->head == NULL) {
        return NULL;
    }

    instruction_node_t* current = list->head;
    while (current != NULL) {
        if (current->instruction->type == type) {
            return current;
        }
        current = current->next;
    }

    return NULL; // instruction not found
}