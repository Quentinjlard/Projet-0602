#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <wchar.h>
#include <string.h>

#include "block.h"
#include "level.h"

/**
 * Initialize a level.
 * @param level the level
 */
void level_init(level_t *level) {
    int i, j;
    block_t block;
    block.type = EMPTY;
    block.value = -1;
    block.coordX = -1;
    block.coordY = -1;
    
    for(i = 0; i < HEIGHT; i++) {
        for(j = 0; j < WIDTH; j++) {
            level->cells[i][j] = btowc(' ');
            level->colors[i][j] = FG_WHITE;
            level->blocks[i][j] = block;
        }
    }
}

/**
 * Display a level in the terminal.
 * @param level the level 
 */
void level_display(level_t *level) {
    int i, j;
    
    for(i = 0; i < WIDTH + 2; i++)
        printf("*");
    printf("\n");
    
    for(i = 0; i < HEIGHT; i++) {
        printf("*");
        for(j = 0; j < WIDTH; j++) {
            printf("\x1b[%dm%C\x1b[0m", level->colors[i][j], level->cells[i][j]);
        }
        printf("*\n");
    }
    
    for(i = 0; i < WIDTH + 2; i++)
        printf("*");
    printf("\n");
}

/**
 * Add a robot in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_robot(level_t *level, int posX, int posY) {
    int i, j;
    
    for(i = posY; i < posY + 4; i++)
        for(j = posX; j < posX + 3; j++)
            level->colors[i][j] = FG_WHITE, level->blocks[i][j].type = ROBOT;
    
    level->cells[posY][posX] = 0x250C;             // ┌
    level->cells[posY][posX] = 0x250C;
    level->cells[posY][posX+1] = 0x2534;           // ┴
    level->cells[posY][posX+2] = 0x2510;           // ┐
    level->cells[posY+1][posX] = 0x2514;           // └
    level->cells[posY+1][posX+1] = 0x252C;         // ┬
    level->cells[posY+1][posX+2] = 0x2518;         // ┘
    level->cells[posY+2][posX] = 0x2500;           // ─
    level->cells[posY+2][posX+1] = 0x253C;         // ┼
    level->cells[posY+2][posX+2] = 0x2500;         // ─
    level->cells[posY+3][posX] = 0x250C;           // ┌
    level->cells[posY+3][posX+1] = 0x2534;         // ┴
    level->cells[posY+3][posX+2] = 0x2510;         // ┐
}

/**
 * Add a probe in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_probe(level_t *level, int posX, int posY) {
    int i, j;
    
    for(i = posY; i < posY + 2; i++)
        for(j = posX; j < posX + 3; j++)
            level->colors[i][j] = FG_WHITE, level->blocks[i][j].type = PROBE;
    
    level->cells[posY][posX] = 0x251C;             // ├
    level->cells[posY][posX+1] = 0x2500;           // ─
    level->cells[posY][posX+2] = 0x2524;           // ┤
    level->cells[posY+1][posX] = 0x2514;           // └
    level->cells[posY+1][posX+1] = 0x2500;         // ─
    level->cells[posY+1][posX+2] = 0x2518;         // ┘
}

/**
 * Add a empty block in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_empty(level_t *level, int posX, int posY) {
    level->cells[posY][posX] = btowc(' ');
    level->colors[posY][posX] = FG_WHITE;
    level->blocks[posY][posX].type = EMPTY;
}

/**
 * Add a block in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_block(level_t *level, int posX, int posY) {
    level->cells[posY][posX] = btowc(' ');
    level->colors[posY][posX] = BK_BLUE;
    level->blocks[posY][posX].type = BLOCK;
}

/**
 * Add a trap in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_trap(level_t *level, int posX, int posY) {
    level->cells[posY][posX] = btowc('#');
    level->colors[posY][posX] = BK_BLUE;
    level->blocks[posY][posX].type = TRAP;
}

/**
 * Add a ladder in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_ladder(level_t *level, int posX, int posY) {
    int i;
    
    for(i = posX; i < posX + 3; i++)
        level->colors[posY][i] = FG_YELLOW, level->blocks[posY][i].type = LADDER;
    
    level->cells[posY][posX] = 0x251C;             // ├
    level->cells[posY][posX+1] = 0x2500;           // ─
    level->cells[posY][posX+2] = 0x2524;           // ┤
}

/**
 * Add a bomb in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_bomb(level_t *level, int posX, int posY) {
    level->cells[posY][posX] = btowc('O');
    level->colors[posY][posX] = FG_WHITE;
    level->blocks[posY][posX].type = BOMB;
}

/**
 * Add a life in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_life(level_t *level, int posX, int posY) {
    level->cells[posY][posX] = btowc('V');
    level->colors[posY][posX] = FG_RED;
    level->blocks[posY][posX].type = LIFE;
}

/**
 * Add a key in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 * @param num the number of the key (1 to 4)
 */
void level_add_key(level_t *level, int posX, int posY, int num) {
    level->cells[posY][posX] = btowc('0' + num);
    level->cells[posY+1][posX] = 0x2518;         // ┘
    level->blocks[posY][posX].type = KEY;
    level->blocks[posY+1][posX].type = KEY;
    
    switch(num) {
        case 1:        
            level->colors[posY][posX] = BK_MAGENTA;
            level->colors[posY+1][posX] = FG_MAGENTA;
            break;
        case 2:        
            level->colors[posY][posX] = BK_GREEN;
            level->colors[posY+1][posX] = FG_GREEN;
            break;
        case 3:        
            level->colors[posY][posX] = BK_YELLOW;
            level->colors[posY+1][posX] = FG_YELLOW;
            break;
        case 4:        
            level->colors[posY][posX] = BK_BLUE;
            level->colors[posY+1][posX] = FG_BLUE;
            break;
    }        
}

/**
 * Add a gate in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 * @param num the number of the gate (1 to 4)
 */
void level_add_gate(level_t *level, int posX, int posY, int num) {
    level->cells[posY][posX] = 0x253C;           // ┼
    level->blocks[posY][posX].type = GATE;
    switch(num) {
        case 1:        
            level->colors[posY][posX] = FG_MAGENTA;
            break;
        case 2:        
            level->colors[posY][posX] = FG_GREEN;
            break;
        case 3:        
            level->colors[posY][posX] = FG_YELLOW;
            break;
        case 4:        
            level->colors[posY][posX] = FG_BLUE;
            break;
    } 
}

/**
 * Add a door in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 * @param num the number of the door (1 to 99)
 */
void level_add_door(level_t *level, int posX, int posY, int num) {
    int i, j;
    
    level->cells[posY][posX] = btowc('0' + num / 10);
    level->colors[posY][posX] = FG_WHITE;
    level->blocks[posY][posX + 1].value = num;
    level->blocks[posY][posX + 1].type = DOOR;

    level->cells[posY][posX + 1] = btowc('0' + num % 10);
    level->colors[posY][posX + 1] = FG_WHITE;
    level->blocks[posY][posX + 1].value = num;
    level->blocks[posY][posX + 1].type = DOOR;
    

    level->cells[posY][posX + 2] = btowc(' ');
    level->colors[posY][posX + 2] = BK_GREEN;
    level->blocks[posY][posX + 2].value = num;
    level->blocks[posY][posX + 2].type = DOOR;


    
    for(i = posY + 1; i < posY + 4; i++)
        for(j = posX; j < posX + 3; j++) {
            level->cells[i][j] = btowc(' ');
            level->colors[i][j] = BK_GREEN;
        }
}

/**
 * Add a start door in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 * @param num the number of the door (1 to 99)
 */
void level_add_start(level_t *level, int posX, int posY) {
    int i, j;
    
    for(i = posY; i < posY + 4; i++)
        for(j = posX; j < posX + 3; j++) {
            level->cells[i][j] = btowc(' ');
            level->colors[i][j] = BK_MAGENTA;
            level->blocks[i][j].type = ENTER;
        }
}

/**
 * Add an exit door in a level.
 * @param level the level
 * @param posX the X position
 * @param posY the Y position
 */
void level_add_exit(level_t *level, int posX, int posY) {
    int i, j;
    
    for(i = posY; i < posY + 4; i++)
        for(j = posX; j < posX + 3; j++) {
            level->cells[i][j] = btowc(' ');
            level->colors[i][j] = BK_YELLOW;
            level->blocks[i][j].type = EXIT;
        }
}

/**
 * @brief 
 * 
 */
void save_level(level_t *level, char *filename)
{
    int fd;
    char full_filename[256];

    
    size_t total_len = strlen(BIN_DIR) + strlen(filename);
    if (total_len < sizeof(full_filename))
        snprintf(full_filename, sizeof(full_filename), "%s%s", BIN_DIR, filename);
    else {
        printf("Error: insufficient buffer size\n");
        return;
    }

    printf("%s\n", full_filename);

    fd = open(full_filename, O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
    if (fd == -1) {
        perror("open");
        return;
    }

    // Écriture de la structure level_t dans le fichier binaire
    ssize_t bytes_written = write(fd, level, sizeof(level_t));
    if (bytes_written == -1) {
        perror("write");
        close(fd);
        return;
    }

    if (close(fd) == -1) {
        perror("close");
        exit(EXIT_FAILURE);
    }

    printf("%s Saved ! \n", full_filename);
}

void get_block(level_t *level, int x, int y) 
{
    printf("Get Block : X : %d - Y : %d - Value : %d - Block : %s \n", x, y, level->blocks[y][x].value, print_block_type(level->blocks[y][x]));
}