/**
 * @file symbol_table.h
 * @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
 * @brief Defines the interface for a symbol table data structure. 
 * @version 0.1
 * @date 2023-03-21
 * 
 * @copyright Copyright (c) 2023
 * 
 */
#ifndef __TABLE_T__
#define __TABLE_T__

#include "symbol_lst.h"

typedef struct table_type {
    lst_symbol_t* list;
    lst_symbol_t* head;
} table_t;

/**
 * @brief Creates a new, empty symbol table.
 * 
 * @return table_t* A pointer to the created symbol table.
 */
table_t* table_create();

/**
 * @brief Displays the contents of the given symbol table.
 * 
 * @param table The symbol table to display.
 */
void table_display(table_t* table);

/**
 * @brief Deletes the given symbol table and all its contents.
 * 
 * @param table The symbol table to delete.
 */
void table_delete(table_t* table);

/**
 * @brief Adds a new symbol to the given symbol table.
 * 
 * @param table The symbol table to add the symbol to.
 * @param symbol The symbol to add.
 */
void table_add(table_t* table, symbol_t* symbol);

/**
 * @brief Searches the given symbol table for a symbol with the given name.
 * 
 * @param table The symbol table to search.
 * @param name The name of the symbol to search for.
 * @return symbol_t* A pointer to the symbol with the given name, or NULL if the symbol is not found.
 */
symbol_t* table_search(table_t* table, char* name);

symbol_t* table_get_first_symbol(table_t* table);


#endif