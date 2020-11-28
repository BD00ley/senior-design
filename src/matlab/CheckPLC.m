% Login information for raspberry pi.
% May have to be configured depending on 
% indivdual raspberry pi.
ipaddress = '10.0.0.10';
username = 'raspi';
password = 'LetMeInDude!';
RPI = raspi(ipaddress, username, password);

% Configure RPI PLC input pins
PinPLC_00 = 35;
PinPLC_01 = 37;
PinPLC_02 = 38;
PinPLC_03 = 40;
configurePin(RPI, PinInput_00,'DigitalOutput');
configurePin(RPI, PinInput_01,'DigitalOutput');
configurePin(RPI, PinInput_02,'DigitalOutput');
configurePin(RPI, PinInput_03,'DigitalOutput');

% Raspberry Pi expects active low inputs from level converter
Movement_00 = [1, 1, 1, 1];
Movement_01 = [1, 1, 1, 0];
Movement_02 = [1, 1, 0, 1];
Movement_03 = [1, 1, 0, 0];
Movement_04 = [1, 0, 1, 1];
Movement_05 = [1, 0, 1, 0];
Movement_06 = [1, 0, 0, 1];
Movement_07 = [1, 0, 0, 0];
Movement_08 = [0, 1, 1, 1];
Movement_09 = [0, 1, 1, 0];
Movement_10 = [0, 1, 0, 1];
Movement_11 = [0, 1, 0, 0];
Movement_12 = [0, 0, 1, 1];
Movement_13 = [0, 0, 1, 0];
Movement_14 = [0, 0, 0, 1];
Movement_15 = [0, 0, 0, 0];
currentMovement = Movement_00;

%Pins initially high (Movement_00 is default)
PinValues = [1, 1, 1, 1];

% Main while loop to check the pins
% User can put in desired movements in the appropriate case

while(1)
    
    PinValues = [readDigitalPin(RPI, PinPLC_00), readDigitalPin(RPI, PinPLC_01), readDigitalPin(RPI, PinPLC_02), readDigitalPin(RPI, PLC_03)]
    
    switch PinValues
        case Movement_00
            if(currnetMovement ~= Movement_00)
                disp('Performing movement 00')
                % Movement_00 movements
                
            end
        case Movement_01
            if(currnetMovement ~= Movement_01)
                disp('Performing movement 01')
                % Movement_01 movements
                
            end
        case Movement_02
            if(currnetMovement ~= Movement_02)
                disp('Performing movement 02')
                % Movement_02 movements
                
            end
        case Movement_03
            if(currnetMovement ~= Movement_03)
                disp('Performing movement 03')
                % Movement_03 movements
                
            end
        case Movement_04
            if(currnetMovement ~= Movement_04)
                disp('Performing movement 04')
                % Movement_04 movements
                
            end
        case Movement_05
            if(currnetMovement ~= Movement_05)
                disp('Performing movement 05')
                % Movement_05 movements
                
            end
        case Movement_06
            if(currnetMovement ~= Movement_06)
                disp('Performing movement 06')
                % Movement_06 movements
                
            end
        case Movement_07
            if(currnetMovement ~= Movement_07)
                disp('Performing movement 07')
                % Movement_07 movements
                
            end
        case Movement_08
            if(currnetMovement ~= Movement_08)
                disp('Performing movement 08')
                % Movement_08 movements
                
            end
        case Movement_09
            if(currnetMovement ~= Movement_09)
                disp('Performing movement 09')
                % Movement_09 movements
                
            end
        case Movement_10
            if(currnetMovement ~= Movement_10)
                disp('Performing movement 10')
                % Movement_00 movements
                
            end
        case Movement_11
            if(currnetMovement ~= Movement_11)
                disp('Performing movement 11')
                % Movement_11 movements
                
            end
        case Movement_12
            if(currnetMovement ~= Movement_12)
                disp('Performing movement 12')
                % Movement_12 movements
                
            end
        case Movement_13
            if(currnetMovement ~= Movement_13)
                disp('Performing movement 13')
                % Movement_13 movements
                
            end
        case Movement_14
            if(currnetMovement ~= Movement_14)
                disp('Performing movement 14')
                % Movement_14 movements
                
            end
        case Movement_15
            if(currnetMovement ~= Movement_15)
                disp('Performing movement 15')
                % Movement_15 movements
                
            end
    end 
end
