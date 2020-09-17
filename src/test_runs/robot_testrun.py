# Brute force example demonstrating the robot

import time
from subprocess import call
base_addr = 16
elbow_addr = 14
middlew_addr = 12
outerw_addr = 11

#call(["./magnet_gripper", "--on"})
call(["./i2c_backend", "--set-position", str(base_addr), str(-40)])
time.sleep(0.5)
call(["./i2c_backend", "--set-position", str(base_addr), str(0)])
time.sleep(0.5)

call(["./i2c_backend", "--set-position", str(elbow_addr), str(-50)])
time.sleep(0.5)

call(["./i2c_backend", "--set-position", str(middlew_addr), str(-60)])
time.sleep(5.0)

call(["./i2c_backend", "--set-position", str(middlew_addr), str(0)])
call(["./i2c_backend", "--set-position", str(elbow_addr), str(0)])
call(["./i2c_backend", "--set-position", str(base_addr), str(-10)])
time.sleep(2.0)
#call(["./magnet_gripper", "--off"])