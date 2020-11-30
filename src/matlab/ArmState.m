function ArmState(RPI, State, Joint_i2c_addr)
% ArmState: A basic function that turns on and off a joint in the arm.
% Note: Raspberry pi must be connected.
if(strcmp(State, 'on') && isnumeric(Joint_i2c_addr))
    system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--energize " + Joint_i2c_addr));
elseif (strcmp(State, 'off') && isnumeric(Joint_i2c_addr))
    system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--de-energize " + Joint_i2c_addr));  
else
    error('Please use ''on'' or ''off'' syntax for state and ensure the ''Joint'' argument is the i2c address.')
end
end