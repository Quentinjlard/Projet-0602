#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol_table.h"

table_t* table_create(){
    table_t* table = malloc(sizeof(table_t));
    if (!table) {
        printf("Erreur : Impossible d'allouer de la mémoire pour la table des symboles.\n");
        exit(EXIT_FAILURE);
    }
    table->head = NULL;
    return table;
}


void table_display(table_t* table) {
    if (!table->head) {
        printf("La table des symboles est vide.\n");
        return;
    }
    printf("Table des symboles :\n");
    lst_symbol_display(table->head);
}

void table_delete(table_t* table) {
    lst_symbol_delete(table->head);
}

void table_add(table_t* table, symbol_t* symbol) {
    lst_symbol_t* lst = lst_symbol_create(symbol);
    lst->next = (struct lst_symbol_t*) table->head;
    table->head = lst;
}

symbol_t* table_search(table_t* table, char* name) {
    lst_symbol_t* lst = lst_symbol_search(table->head, name);
    if (!lst) {
        return NULL;
    }
    return lst->symbol;
}

symbol_t* table_get_first_symbol(table_t* table) {
    if (!table || !table->head) {
        return NULL;
    }
    return table->head->symbol;
}

symbol_t* table_search_by_index(table_t* table, int index) {
    lst_symbol_t* current = table->head;
    int i = 0;
    while (current != NULL) {
        if (i == index) {
            return current->symbol;
        }
        current = current->next;
        i++;
    }
    return NULL;
}