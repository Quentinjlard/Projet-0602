#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>
#include <locale.h>

#include "block.h"
#include "level.h"

#define GREEN "\033[1;32m"
#define YELLOW "\033[1;33m"
#define RESET "\033[0m"

extern int yyparse();
extern FILE *yyin;

int main(int argc, char **argv) {
	FILE *file;
	int resultat;
    
    if(setlocale(LC_ALL, "") == NULL)
        printf("setlocale failed.\n");

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }
    file = fopen(argv[1], "r");
    if (file == NULL) {
        fprintf(stderr, "Error: Unable to open file %s\n", argv[1]);
        return 1;
    }
    yyin = file;
    resultat = yyparse();

    if(resultat == 0) {
        printf("The %s file was successfully scanned.\n", argv[1]);
    } else {
        printf("The analysis of the %s file failed.\n", argv[1]);
    }

    fclose(file);

    return 0;
}
