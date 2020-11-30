function MagnetState(RPI, State)
% ArmState: A basic function that turns on and off the magnet gripper of the arm.
% Note: Raspberry pi must be connected.
if(strcmp(State, 'on'))
    system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./magnet_gripper " + "--on "));
elseif (strcmp(State, 'off'))
    system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./magnet_gripper " + "--off "));  
else
    error('Please use ''on'' or ''off'' syntax for state')
end
end