#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "symbol.h"

symbol_t* symbol_create(char* name, int value) {
    symbol_t* symbol = malloc(sizeof(symbol_t));
    if (!symbol) {
        printf("Erreur : Impossible d'allouer de la mémoire pour le symbole.\n");
        exit(EXIT_FAILURE);
    }
    symbol->name = malloc(strlen(name) + 1);
    if (!symbol->name) {
        printf("Erreur : Impossible d'allouer de la mémoire pour le nom du symbole.\n");
        free(symbol);
        exit(EXIT_FAILURE);
    }
    strcpy(symbol->name, name);
    symbol->value = value;
    return symbol;
}

void symbol_display(symbol_t* symbol) {
    printf("Symbole %s : %d\n", symbol->name, symbol->value);
}

void symbol_delete(symbol_t* symbol) {
    free(symbol->name);
    free(symbol);
    printf("Symbole supprimé.\n");
}

void symbol_set_value(symbol_t* symbol, int value) {
    symbol->value = value;
}

int symbol_get_value(symbol_t* symbol) {
    return symbol->value;
}

void symbol_set_name(symbol_t* symbol, char* name) {
    symbol->name = name;
}

char* symbol_get_name(symbol_t* symbol) {
    return symbol->name;
}