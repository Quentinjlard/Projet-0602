#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>

#include "block.h"
#include "level.h"


char* print_block_type(block_t block){
    switch (block.type){
        case EMPTY:
            return "EMPTY";
        case BLOCK:
            return "BLOCK";
        case TRAP:
            return "TRAP";
        case LIFE:
            return "LIFE";
        case BOMB:
            return "BOMB";
        case DOOR:
            return "DOOR";
        case ENTER:
            return "ENTER";
        case EXIT:
            return "EXIT";
        case LADDER:
            return "LADDER";
        case ROBOT: 
            return "ROBOT";
        case PROBE:
            return "PROBE";
        case KEY:
            return "KEY";
        case GATE:
            return "GATE";
        default:
            return " ";
    }
}