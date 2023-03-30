/**
* @file symbol.h
* @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
* @brief
* @version 0.1
* @date 2023-03-21
* @copyright Copyright (c) 2023
*/

#ifndef __SYMBOL_T__
#define __SYMBOL_T__

typedef struct symbol_type {
    char* name;
    int value;
} symbol_t;

/**
 * @brief Creates a new symbol with the given name and value.
 * @param name The name of the symbol.
 * @param value The value of the symbol.
 * @return symbol_t* A pointer to the created symbol.
 */
symbol_t* symbol_create(char* name, int value);

/**
 * @brief Displays the name and value of the given symbol.
 * @param symbol The symbol to display.
 */
void symbol_display(symbol_t* symbol);

/**
 * @brief Deletes the given symbol.
 * @param symbol The symbol to delete.
 */
void symbol_delete(symbol_t* symbol);

/**
 * @brief Sets the value of the given symbol to the given value.
 * @param symbol The symbol to set the value of.
 * @param value The new value for the symbol.
 */
void symbol_set_value(symbol_t* symbol, int value);

/**
 * @brief Returns the value of the given symbol.
 * @param symbol The symbol to get the value of.
 * @return int The value of the symbol.
 */
int symbol_get_value(symbol_t* symbol);

/**

 * @brief Sets the name of the given symbol to the given name.
 * @param symbol The symbol to set the name of.
 * @param name The new name for the symbol.
 */
void symbol_set_name(symbol_t* symbol, char* name);

/**
 * @brief Returns the name of the given symbol.
 * @param symbol The symbol to get the name of.
 * @return char* The name of the symbol.
 */
char* symbol_get_name(symbol_t* symbol);

#endif 