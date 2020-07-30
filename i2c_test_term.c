// Author: Bradley Dooley, USF EE.
// Uses the Linux I2C API to send and receive data from a Tic.
// NOTE: The Tic's control mode must be "Serial / I2C / USB".
// NOTE: For reliable operation on a Raspberry Pi, enable the i2c-gpio.
 
#include <fcntl.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/ioctl.h>


  //Structure of using io control in linux for reference.

  //ioctl(file, I2C_RDWR, struct i2c_rdwr_ioctl_data *msgset)
  //struct i2c_rdwr_ioctl_data {
  //    struct i2c_msg *msgs;  /* ptr to array of simple messages */
  //    int nmsgs;             /* number of messages to exchange */
  //} 


// Opens the specified I2C device.
int open_i2c_device(const char* device) {
  int fd = open(device, O_RDWR); //Open as given in fcntl.h
  if (fd == -1) {
    perror(device);
		return -1;
  }
  return fd;
} 

// Sends the "Exit safe start" command.
bool tic_exit_safe_start(int fd, uint8_t address) {
  uint8_t command[] = { 0x83 };
  struct i2c_msg message = { address, 0, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result != 1) {
    perror("failed to exit safe start");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
 
// Sets the target position
bool tic_set_target_position(int fd, uint8_t address, int32_t target) {
  uint8_t command[] = {
    0xE0,
    (uint8_t)(target >> 0  & 0xFF),		//Split 32 bit register into four bytes
    (uint8_t)(target >> 8  & 0xFF),
    (uint8_t)(target >> 16 & 0xFF),
    (uint8_t)(target >> 24 & 0xFF)
  };
  struct i2c_msg message = { address, 0, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 };
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result != 1) {
    perror("failed to set target position");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
 
// Gets one or more variables from the Tic (without clearing them).
bool tic_get_variable(int fd, uint8_t address, uint8_t offset, uint8_t* buffer, uint8_t length) {
  uint8_t command[] = { 
    0xA1, 
    offset 
  };
  struct i2c_msg messages[] = {
    { address, 0, sizeof(command), command },
    { address, I2C_M_RD, length, buffer },
  };
  struct i2c_rdwr_ioctl_data ioctl_data = { &messages, 2 };
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result != 2) {
    perror("failed to get variables");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

// Energize the motor
bool energize(int fd, uint8_t address) {
  uint8_t command[] ={ 0x85 };
  struct i2c_msg message = { address, 0, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result != 1) {
    perror("failed to energize");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}

// De-energize the motor
bool de_energize(int fd, uint8_t address) {
  uint8_t command[] ={ 0x86 };
  struct i2c_msg message = { address, 0, sizeof(command), command };
  struct i2c_rdwr_ioctl_data ioctl_data = { &message, 1 }; 
  int result = ioctl(fd, I2C_RDWR, &ioctl_data);
  if (result != 1) {
    perror("failed to de-energize");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
 
int main(int argc, char* argv[argc+1]) {

  //Assign the terminal command and i2c address 
  const char* cmd = argv[1];
  const uint8_t address = strtol(argv[2], NULL, 10);

  //I2C device of the raspberry pi (GPIO2 & GPIO3).
  const char* device = "/dev/i2c-1";
 
  int fd = open_i2c_device(device);
  if (fd < 0)
    return EXIT_FAILURE;
 
  bool result = false;

  if (!strcmp(cmd, "--energize")) {
    result = tic_exit_safe_start(fd, address);

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
  else if (!strcmp(cmd, "--de-energize")) {
    result = tic_exit_safe_start(fd, address);
    if (result)
      return EXIT_FAILURE;

    printf("De-energizing motor.\n");
    result = de_energize(fd, address);

    if (result)
      return EXIT_FAILURE;
    printf("Motor de-energized.\n");
  }
  else if (!strcmp(cmd, "--set-position")) {
      result = tic_exit_safe_start(fd, address);
      if (result) 
        return EXIT_FAILURE;

      // Get the desired position value 
      int32_t position = strtol(argv[3], NULL, 10);
      printf("Setting target position to %d.\n", position);
      result = tic_set_target_position(fd, address, position);
        if (result) 
          return EXIT_FAILURE;
      printf("Position set.\n");
  }
  else
  {
    printf("Unrecognized command.\n");
    return EXIT_FAILURE;
  }
  
  close(fd);  
  return EXIT_SUCCESS;
}