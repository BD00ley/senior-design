#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[argc+1]) {
    printf("Argument set-position: %s\n", argv[1]);
    printf("Argument address: %d\n", strtol(argv[2], NULL, 10));
    printf("Argument position: %d\n\n", strtol(argv[3], NULL, 10));
    //printconst uint8_t address = strtol(argv[2], NULL, 10);
    return 0;
}