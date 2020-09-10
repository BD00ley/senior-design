# Brute force example demonstrating the robot

import time
from subprocess import call
base_addr = 16
elbow_addr = 14
middlew_addr = 12
outerw_addr = 11

call(["./i2c_backend", "--set-position", str(base_addr), str(50)])
time.sleep(0.5)

call(["./i2c_backend", "--set-position", str(elbow_addr), str(300)])
time.sleep(1.5)

call(["./i2c_backend", "--set-position", str(middlew_addr), str(50)])
time.sleep(1.2)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(10)])
time.sleep(0.4)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(-10)])
time.sleep(0.4)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(10)])
time.sleep(0.4)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(-10)])
time.sleep(0.4)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(0)])
time.sleep(1.2)


call(["./i2c_backend", "--set-position", str(middlew_addr), str(0)])
call(["./i2c_backend", "--set-position", str(elbow_addr), str(300)])
call(["./i2c_backend", "--set-position", str(base_addr), str(50)])