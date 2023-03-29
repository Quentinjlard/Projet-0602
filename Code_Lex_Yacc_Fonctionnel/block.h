/**
 * @file block.h
 * @author JUILLIARD Quentin (quentin.juilliard@etudiant.univ-reims.fr)
 * @brief 
 * @version 0.1
 * @date 2023-03-21
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef __BLOCK_H__
#define __BLOCK_H__

typedef enum block_name_type{
    EMPTY,
    BLOCK,
    TRAP,
    LIFE,
    BOMB,
    DOOR,
    ENTER,
    EXIT,
    LADDER,
    ROBOT,
    PROBE,
    KEY,
    GATE
} block_name_t;

typedef struct block_type{
    block_name_t type;
    int value;  // valeur associée au bloc (numéro de porte, de clé, etc.)
    int coordX;
    int coordY;
} block_t;

/**
 * @brief 
 * 
 * @param block 
 * @return char* 
 */
char* print_block_type(block_t block);

#endif