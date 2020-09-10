// Author: Bradley Dooley, USF EE.
// This code allows for control of the magnetic gripper using
// the bcm2835 library. See http://www.airspayce.com/mikem/bcm2835/modules.html
// For full documentation on the library.

#include <stdio.h>
#include <bcm2835.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#define MPIN RPI_BPLUS_GPIO_J8_15  //Pin 15 on J8 header = GPIO22 = GPIO_GEN3 on RPi
int main(int argc, char* argv[argc+1]) {

if(argc > 2) {
    printf("Too many arguments.\n");
    return EXIT_FAILURE;
}

const char* cmd = argv[1];
if(!bcm2835_init()){
    perror("failed initialize bcm2835 library");
    return EXIT_FAILURE;
}

bcm2835_gpio_fsel(MPIN, BCM2835_GPIO_FSEL_OUTP);
if(strcmp(cmd, "--on") == 0) {
    bcm2835_gpio_write(MPIN, HIGH);
    printf("Magnetic gripper energized.\n");
}
else if (strcmp(cmd,"--off") == 0) {
     bcm2835_gpio_write(MPIN, LOW);
     printf("Magnetic gripper de-energized.\n");
}
else {
    printf("Unknown command. Use --on or -off for magnet gripper control.\n");
}

return EXIT_SUCCESS; 
}