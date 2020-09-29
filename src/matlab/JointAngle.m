function JointAngle(RPI, base_angle, shoulder_angle, elbow_angle, inner_wrist_angle, middle_wrist_angle, outer_wrist_angle)
% JointAngle: A basic function that allows for control of each arm joint.
% Note: Raspberry pi must be connected.
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "16 " + base_angle));
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "15 " + shoulder_angle));
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "14 " + elbow_angle));
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "13 " + inner_wrist_angle));
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "12 " + middle_wrist_angle));
system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "11 " + outer_wrist_angle));

end

