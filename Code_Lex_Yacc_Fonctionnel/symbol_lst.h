/**
 * @file symbol_lst.h
 * @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
 * @author COGNE Romain (romain.cogne@etudiant.univ-reims.fr)
 * @brief 
 * @version 0.1
 * @date 2023-03-21
 * 
 * @copyright Copyright (c) 2023
 * 
 */
#ifndef __LST_SYMBOL_T_H__
#define __LST_SYMBOL_T_H__

#include "symbol.h"

typedef struct lst_symbol_type {
    symbol_t* symbol;
    struct lst_symbol_t* next;
} lst_symbol_t;

/**
 * @brief Creates a new list element with the given symbol.
 * 
 * @param symbol The symbol to create a list element for.
 * @return lst_symbol_t* A pointer to the created list element.
 */
lst_symbol_t* lst_symbol_create(symbol_t* symbol);

/**
 * @brief Displays the name and value of all symbols in the given list.
 * 
 * @param lst The list of symbols to display.
 */
void lst_symbol_display(lst_symbol_t* lst);

/**
 * @brief Deletes the given list and all its elements.
 * 
 * @param lst The list to delete.
 */
void lst_symbol_delete(lst_symbol_t* lst);

/**
 * @brief Searches the given list for a symbol with the given name.
 * 
 * @param lst The list to search. 
 * @param name The name of the symbol to search for. 
 * @return lst_symbol_t* A pointer to the first list element containing the symbol with the given name, or NULL if the symbol is not found.
 */
lst_symbol_t* lst_symbol_search(lst_symbol_t* lst, char* name);


#endif