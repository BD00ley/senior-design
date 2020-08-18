// Author: Bradley Dooley, USF EE.
// Uses the Linux kernel to send and receive data from a Tic.
// See https://www.kernel.org/doc/Documentation/i2c/dev-interface for
// more information on the ioctrl.
// See https://docs.rtems.org/doxygen/branches/master/structi2c__msg.html#a8633f67b7fb7d6e4b4389d8a5b999e5f
// for information on the messages.

#include <fcntl.h>
#include <unistd.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/ioctl.h>

// The following definitions assume the i2c addresses are in sequential order.
// For example, the default addresses are 11, 12, 13, 14, 15, 16.
#define addr_top 16
#define addr_bottom 11
#define NO_FLAGS 0
  //Structure of using io control in linux for reference.

// ioctl(file, I2C_RDWR, struct i2c_rdwr_ioctl_data *msgset)
// Do combined read/write transaction without stop in between.
// Only valid if the adapter has I2C_FUNC_I2C.  The argument is
// a pointer to a
//
// struct i2c_rdwr_ioctl_data {
//     struct i2c_msg *msgs;  /* ptr to array of simple messages */
//     int nmsgs;             /* number of messages to exchange */
// }
//

// struct i2c_msg { uint16_t addr, uint16_t flags, uint16_t len, uint8_t * buf }

// Opens the specified I2C device.
int open_device(const char* device) {
  int fd = open(device, O_RDWR);
  if (fd == -1) {
    perror(device);
		return -1;
  }
  return fd;
} 

// Sends the exit safe start command.
bool exit_safe_start(int fd, uint16_t address) {
  uint8_t command[] = { 0x83 };
  struct i2c_msg message = { address, NO_FLAGS, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result == -1) {
    perror("failed to exit safe start");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
 
// Sets the target position
bool set_position(int fd, uint16_t address, int32_t target) {
  uint8_t command[] = {
    0xE0,
    (uint8_t)(target >> 0  & 0xFF),		//Four bytes of info sent (position is 32 bits)
    (uint8_t)(target >> 8  & 0xFF),
    (uint8_t)(target >> 16 & 0xFF),
    (uint8_t)(target >> 24 & 0xFF)
  };
  struct i2c_msg message = { address, NO_FLAGS, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 };
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result == -1) {
    perror("failed to set target position");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

// Energize the motor
bool energize(int fd, uint16_t address) {
  uint8_t command[] ={ 0x85 };
  struct i2c_msg message = { address, NO_FLAGS, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result == -1) {
    perror("failed to energize");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

// De-energize the motor
bool de_energize(int fd, uint16_t address) {
  uint8_t command[] ={ 0x86 };
  struct i2c_msg message = { address, NO_FLAGS, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result == -1) {
    perror("failed to de-energize");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

void print_cmds() {
  printf("--energize ADR\t\tEnergize the motor at address ADR\n");
  printf("--de-energize ADR\t\tDe-energize the motor at address ADR\n");
  printf("--energize-all\t\tEnergizes all motors.");
  printf("--de-energize-all\t\tDe-energizes all motors.");
  printf("--set-position ADR PSTN\t\tSet the motor at address ADR to position PSTN\n");
  printf("--help\t\tPrint out command information\n");
}

int main(int argc, char* argv[argc+1]) {

  //Assign the terminal command and i2c address 
  const char* cmd = argv[1];

  //I2C device of the raspberry pi (GPIO2 & GPIO3).
  const char* device = "/dev/i2c-1";
 
  int fd = open_device(device);
  if (fd < 0)
    return EXIT_FAILURE;
 
  bool result = false;

  if (strcmp(cmd, "--energize") == 0) {
    const uint16_t address = strtol(argv[2], NULL, 10);
    result = exit_safe_start(fd, address);

    //Note the conditionals for result check if 
    //the commands were properly executed.
    if (result)
      return EXIT_FAILURE;

    printf("Energizing motor.\n");
    result = energize(fd, address);
    if (result)
      return EXIT_FAILURE;
    printf("Motor energized.\n");
  }
  else if (strcmp(cmd, "--de-energize") == 0) {
    const uint16_t address = strtol(argv[2], NULL, 10);
    result = exit_safe_start(fd, address);
    if (result)
      return EXIT_FAILURE;

    printf("De-energizing motor.\n");
    result = de_energize(fd, address);

    if (result)
      return EXIT_FAILURE;
    printf("Motor de-energized.\n");
  }
  else if (strcmp(cmd, "--energize-all") == 0){
    for (int i = addr_top; i >= addr_bottom; i--)
    {
      result = exit_safe_start(fd, i);
      if(result)
        return EXIT_FAILURE;
      printf("Energizing motor %d.\n", i);
      result = energize(fd, i);
      if(result)
        return EXIT_FAILURE;
      printf("Motor at address %d energized.\n", i);
    }
    printf("All motors energized.\n");
      return EXIT_SUCCESS;
  }
  else if (strcmp(cmd, "--de-energize-all") == 0){
    for (int i = addr_top; i >= addr_bottom; i--)
    {
      result = exit_safe_start(fd, i);
      if(result)
        return EXIT_FAILURE;
      printf("De-energizing motor %d.\n", i);
      result = de_energize(fd, i);
      if(result)
        return EXIT_FAILURE;
      printf("Motor at address %d de-energized.\n", i);
    }
    printf("All motors de-energized.\n");
      return EXIT_SUCCESS;
  }
  else if (strcmp(cmd, "--set-position") == 0) {
      const uint16_t address = strtol(argv[2], NULL, 10);
      result = exit_safe_start(fd, address);
      if (result) 
        return EXIT_FAILURE;

      // Get the desired position value 
      int32_t position = strtol(argv[3], NULL, 10);
      printf("Setting target position to %d.\n", position);
      result = set_position(fd, address, position);
        if (result) 
          return EXIT_FAILURE;
      printf("Position set.\n");
  }
  else if (strcmp(cmd, "--help") == 0) {
    print_cmds();
    return EXIT_SUCCESS;
  }
  else
  {
    printf("Unrecognized command.\n");
    print_cmds();
    return EXIT_FAILURE;
  }
  
  close(fd);  
  return EXIT_SUCCESS;
}
