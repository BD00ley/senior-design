# Brute force example demonstrating the robot

import time
from subprocess import call

elbow_addr = 14
innerw_addr = 13
middlew_addr = 12
outerw_addr = 11

call(["./i2c_backend", "--set-position", str(elbow_addr), str(-360)])

time.sleep(4.0)

call(["./i2c_backend", "--set-position", str(innerw_addr), str(-7)])

time.sleep(1.5)

call(["./i2c_backend", "--set-position", str(middlew_addr), str(-40)])

time.sleep(2.0)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(100)])

time.sleep(3.0)

call(["./i2c_backend", "--set-position", str(outerw_addr), str(0)])

time.sleep(3.0)

call(["./i2c_backend", "--set-position", str(middlew_addr), str(0)])

time.sleep(2.0)

call(["./i2c_backend", "--set-position", str(innerw_addr), str(0)])

time.sleep(1.5)

call(["./i2c_backend", "--set-position", str(elbow_addr), str(-360)])

time.sleep(4)

call(["./i2c_backend", "--set-position", str(elbow_addr), str(-360)])
call(["./i2c_backend", "--set-position", str(innerw_addr), str(-7)])
call(["./i2c_backend", "--set-position", str(middlew_addr), str(-40)])
call(["./i2c_backend", "--set-position", str(outerw_addr), str(100)])

time.sleep(4.0)

call(["./i2c_backend", "--set-position", str(elbow_addr), str(0)])
call(["./i2c_backend", "--set-position", str(innerw_addr), str(0)])
call(["./i2c_backend", "--set-position", str(middlew_addr), str(0)])
call(["./i2c_backend", "--set-position", str(outerw_addr), str(0)])