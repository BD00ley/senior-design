CC=gcc
BE-SRC=src/backend

all: i2c magnet

i2c: 
	$(CC) -o test_runs/i2c_backend $(BE-SRC)/i2c_backend.c

magnet:
	$(CC) -o test_runs/magnet_gripper $(BE-SRC)/magnet_gripper.c -l bcm2835

clean:
	rm -rf test_runs/i2c_backend
	rm -rf test_runs/magnet_gripper
