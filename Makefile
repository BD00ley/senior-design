CC=gcc

all: i2c magnet

i2c: 
	$(CC) -o test_runs/i2c_backend src/c/backend/i2c_backend.c

magnet:
	$(CC) -o test_runs/magnet_gripper src/c/backend/magnet_gripper.c -l bcm2835

clean:
	rm -rf test_runs/i2c_backend
	rm -rf test_runs/magnet_gripper
