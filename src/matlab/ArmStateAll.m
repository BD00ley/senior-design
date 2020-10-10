function ArmStateAll(RPI, State)
% ArmState: A basic function that turns on and off all joints in the arm.
% Note: Raspberry pi must be connected.
if(strcmp(State, 'on'))
    for i = 11:16
        ArmState(RPI, 'on', i);
    end
elseif (strcmp(State, 'off'))
    for i = 11:16
        ArmState(RPI, 'off', i);
    end
else
    error('Please use ''on'' or ''off'' syntax for state.')
end    
end

