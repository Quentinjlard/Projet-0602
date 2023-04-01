#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol_lst.h"

lst_symbol_t* lst_symbol_create(symbol_t* symbol) {
    lst_symbol_t* lst = malloc(sizeof(lst_symbol_t));
    if (!lst) {
        printf("Erreur : Impossible d'allouer de la mémoire pour la liste de symboles.\n");
        exit(EXIT_FAILURE);
    }
    lst->symbol = symbol;
    lst->next = NULL;
    return lst;
}

void lst_symbol_display(lst_symbol_t* lst) {
    if (!lst) {
        printf("La liste de symboles est vide.\n");
        return;
    }
    printf("Liste de symboles :\n");
    while (lst) {
        symbol_display(lst->symbol);
        lst = (lst_symbol_t*)lst->next;
    }
}

void lst_symbol_delete(lst_symbol_t* lst) {
    while (lst) {
        lst_symbol_t* next = (lst_symbol_t*)lst->next;
        symbol_delete(lst->symbol);
        free(lst);
        lst = next;
    }
}

lst_symbol_t* lst_symbol_search(lst_symbol_t* lst, char* name) {
    while (lst) {
        if (strcmp(lst->symbol->name, name) == 0) {
            return lst;
        }
        lst = (lst_symbol_t*)lst->next;
    }
    return NULL;
}
