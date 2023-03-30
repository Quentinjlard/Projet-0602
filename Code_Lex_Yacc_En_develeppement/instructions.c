#include <stdlib.h>
#include <stdio.h>

#include "instructions.h"

instruction_t* create_instruction(instruction_type_t type,void* data) {
    instruction_t* instruction = (instruction_t*)malloc(sizeof(instruction_t));
    instruction->type = type;
    instruction->data = data;
    return instruction;
}