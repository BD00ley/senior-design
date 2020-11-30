classdef Arms_Reach < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ArmsReachUIFigure       matlab.ui.Figure
        GridLayout              matlab.ui.container.GridLayout
        LeftPanel               matlab.ui.container.Panel
        LinkLamp                matlab.ui.control.Lamp
        Switch                  matlab.ui.control.Switch
        ResetButton             matlab.ui.control.Button
        StartButton             matlab.ui.control.Button
        ForwardKinematicsPanel  matlab.ui.container.Panel
        OuterWristSliderLabel   matlab.ui.control.Label
        outer_wrist_Slider      matlab.ui.control.Slider
        MiddleWristSliderLabel  matlab.ui.control.Label
        middle_wrist_Slider     matlab.ui.control.Slider
        InnerWristSliderLabel   matlab.ui.control.Label
        inner_wrist_Slider      matlab.ui.control.Slider
        ElbowSliderLabel        matlab.ui.control.Label
        elbow_Slider            matlab.ui.control.Slider
        ShoulderSliderLabel     matlab.ui.control.Label
        shoulder_Slider         matlab.ui.control.Slider
        BaseSliderLabel         matlab.ui.control.Label
        base_Slider             matlab.ui.control.Slider
        outer_wrist_Edit        matlab.ui.control.EditField
        middle_wrist_Edit       matlab.ui.control.EditField
        inner_wrist_Edit        matlab.ui.control.EditField
        elbow_Edit              matlab.ui.control.EditField
        shoulder_Edit           matlab.ui.control.EditField
        base_Edit               matlab.ui.control.EditField
        RightPanel              matlab.ui.container.Panel
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        Upper = 200;
        Lower = -200;
        Increment = 1;
        
        cf1 = 1.8;
        cf2 = 7.5;
        
        base_angle;
        shoulder_angle;
        elbow_angle;
        inner_wrist_angle;
        middle_wrist_angle;
        outer_wrist_angle;
        
        base;
        shoulder;
        elbow;
        inner_wrist;
        middle_wrist;
        outer_wrist;
        
        cbase;
        cshoulder;
        celbow;
        cinner_wrist;
        cmiddle_wrist;
        couter_wrist;
        
    end

    methods (Access = private)
        
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
        
        function JointAngle(RPI, base_angle, shoulder_angle, elbow_angle, inner_wrist_angle, middle_wrist_angle, outer_wrist_angle)
            % JointAngle: A basic function that allows for control of each arm joint.
            % Note: Raspberry pi must be connected.
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "14 " + base_angle));
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "16 " + shoulder_angle));
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "15 " + elbow_angle));
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "11 " + inner_wrist_angle));
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "13 " + middle_wrist_angle));
            system(RPI, char("cd ~/Desktop/senior-design/test_runs; ./i2c_backend " + "--set-position " + "12 " + outer_wrist_angle));
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %% UI Setup
            app.base_Slider.Limits = [app.Lower app.Upper];
            app.shoulder_Slider.Limits = [app.Lower app.Upper];
            app.elbow_Slider.Limits = [app.Lower app.Upper];
            app.inner_wrist_Slider.Limits = [-12 12];
            app.middle_wrist_Slider.Limits = [-20 20];
            app.outer_wrist_Slider.Limits = [-20 20];
            
            app.base_Edit.Value = "0";
            app.shoulder_Edit.Value = "0";
            app.elbow_Edit.Value = "0";
            app.inner_wrist_Edit.Value = "0";
            app.middle_wrist_Edit.Value = "0";
            app.outer_wrist_Edit.Value = "0";
            
            app.base_Slider.Value = 0;
            app.shoulder_Slider.Value = 0;
            app.elbow_Slider.Value = 0;
            app.inner_wrist_Slider.Value = 0;
            app.middle_wrist_Slider.Value = 0;
            app.outer_wrist_Slider.Value = 0;
            
            %% Zero out Simulation
            app.base_angle = 0;
            app.shoulder_angle = 134;
            app.elbow_angle = -47;
            app.inner_wrist_angle = 0;
            app.middle_wrist_angle = 0;
            app.outer_wrist_angle = 60;
            
            app.base = 0;
            app.shoulder = 134;
            app.elbow = -47;
            app.inner_wrist = 0;
            app.middle_wrist = 0;
            app.outer_wrist = 60;
            
            assignin("base",'base',app.base);
            set_param('sixDOF_model3/Angle Offset Correction/base', 'Value', num2str(app.base));
            assignin("base",'shoulder',app.shoulder);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder', 'Value', num2str(app.shoulder));
            assignin("base",'elbow',app.elbow);
            set_param('sixDOF_model3/Angle Offset Correction/elbow', 'Value', num2str(app.elbow));
            assignin("base",'inner_wrist',app.inner_wrist);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist', 'Value', num2str(app.inner_wrist));
            assignin("base",'middle_wrist',app.middle_wrist);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist', 'Value', num2str(app.middle_wrist));
            assignin("base",'outer_wrist',app.outer_wrist);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist', 'Value', num2str(app.outer_wrist));
            
            assignin("base",'base_angle',app.base_angle);
            set_param('sixDOF_model3/Angle Offset Correction/base_angle', 'Value', num2str(app.base_angle));
            assignin("base",'shoulder_angle',app.shoulder_angle);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder_angle', 'Value', num2str(app.shoulder_angle));
            assignin("base",'elbow_angle',app.elbow_angle);
            set_param('sixDOF_model3/Angle Offset Correction/elbow_angle', 'Value', num2str(app.elbow_angle));
            assignin("base",'inner_wrist_angle',app.inner_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist_angle', 'Value', num2str(app.inner_wrist_angle));
            assignin("base",'middle_wrist_angle',app.middle_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist_angle', 'Value', num2str(app.middle_wrist_angle));
            assignin("base",'outer_wrist_angle',app.outer_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist_angle', 'Value', num2str(app.outer_wrist_angle));
            
            app.cbase = app.base_angle/app.cf1;
            app.cshoulder = app.shoulder_angle/app.cf1;
            app.celbow = app.elbow_angle/app.cf1;
            app.cinner_wrist = app.inner_wrist_angle/app.cf2;
            app.cmiddle_wrist = app.middle_wrist_angle/app.cf2;
            app.couter_wrist = app.outer_wrist_angle/app.cf2;
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.ArmsReachUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {501, 501};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {417, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            ArmStateAll(evalin('base', 'RPI'), value);
            MagnetState(evalin('base', 'RPI'), value);
            if strcmp(value, 'on')
                app.LinkLamp.Color = 'g';
            else
                app.LinkLamp.Color = 'r';
            end
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            value = app.Switch.Value;
            if strcmp(value, 'on')
                app.cbase = app.base_angle/app.cf1;
                app.cshoulder = app.shoulder_angle/app.cf1;
                app.celbow = app.elbow_angle/app.cf1;
                app.cinner_wrist = app.inner_wrist_angle/app.cf2;
                app.cmiddle_wrist = app.middle_wrist_angle/app.cf2;
                app.couter_wrist = app.outer_wrist_angle/app.cf2;
                JointAngle(evalin('base', 'RPI'), app.cbase, app.cshoulder, app.celbow, app.cinner_wrist, app.cmiddle_wrist, app.couter_wrist);
            end          
            
            app.base = app.base + app.base_angle;
            app.shoulder = app.shoulder + app.shoulder_angle;
            app.elbow = app.elbow + app.elbow_angle;
            app.inner_wrist = app.inner_wrist + app.inner_wrist_angle;
            app.middle_wrist = app.middle_wrist + app.middle_wrist_angle;
            app.outer_wrist = app.outer_wrist + app.outer_wrist_angle;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            if app.base < -360
                app.base = app.base + 360;
            end
            if app.base > 360
                app.base = app.base - 360;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            if app.shoulder < -360
                app.shoulder = app.shoulder + 360;
            end
            if app.shoulder > 360
                app.shoulder = app.shoulder - 360;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            if app.elbow < -360
                app.elbow = app.elbow + 360;
            end
            if app.elbow > 360
                app.elbow = app.elbow - 360;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            if app.inner_wrist < -360
                app.inner_wrist = app.inner_wrist + 360;
            end
            if app.inner_wrist > 360
                app.inner_wrist = app.inner_wrist - 360;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            if app.middle_wrist < -360
                app.middle_wrist = app.middle_wrist + 360;
            end
            if app.middle_wrist > 360
                app.middle_wrist = app.middle_wrist - 360;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            if app.outer_wrist < -360
                app.outer_wrist = app.outer_wrist + 360;
            end
            if app.outer_wrist > 360
                app.outer_wrist = app.outer_wrist - 360;
            end
            
            assignin("base",'base_angle',app.base_angle);
            set_param('sixDOF_model3/Angle Offset Correction/base_angle', 'Value', num2str(app.base_angle));
            assignin("base",'shoulder_angle',app.shoulder_angle);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder_angle', 'Value', num2str(app.shoulder_angle));
            assignin("base",'elbow_angle',app.elbow_angle);
            set_param('sixDOF_model3/Angle Offset Correction/elbow_angle', 'Value', num2str(app.elbow_angle));
            assignin("base",'inner_wrist_angle',app.inner_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist_angle', 'Value', num2str(app.inner_wrist_angle));
            assignin("base",'middle_wrist_angle',app.middle_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist_angle', 'Value', num2str(app.middle_wrist_angle));
            assignin("base",'outer_wrist_angle',app.outer_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist_angle', 'Value', num2str(app.outer_wrist_angle));
        end

        % Value changing function: base_Slider
        function base_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.base_angle = changingValue;
            app.base_Edit.Value = num2str(app.base_angle);
            assignin("base","base_angle",app.base_angle);
            set_param('sixDOF_model3/Angle Offset Correction/base_angle', 'Value', num2str(app.base_angle));
        end

        % Value changed function: base_Edit
        function base_EditValueChanged(app, event)
            value = str2num(app.base_Edit.Value);
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.base_Edit.Value = num2str(value);
                    app.base_angle = value;
                    app.base_Slider.Value = app.base_angle;
                end
            else
                app.base_Edit.Value = num2str(0);
                app.base_angle = 0;
                app.baseSlider.Value = 0;
            end
            assignin("base","base_angle",app.base_angle);
            set_param('sixDOF_model3/Angle Offset Correction/base_angle', 'Value', num2str(app.base_angle));
        end

        % Value changed function: shoulder_Edit
        function shoulder_EditValueChanged(app, event)
            value = str2num(app.shoulder_Edit.Value);
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.shoulder_Edit.Value = num2str(value);
                    app.shoulder_angle = value;
                    app.shoulder_Slider.Value = app.shoulder_angle;
                end
            else
                app.shoulder_Edit.Value = num2str(0);
                app.shoulder_angle = 0;
                app.shoulder_Slider.Value = 0;
            end
            assignin("base","shoulder_angle",app.shoulder_angle);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder_angle', 'Value', num2str(app.shoulder_angle));
        end

        % Value changed function: elbow_Edit
        function elbow_EditValueChanged(app, event)
            value = str2num(app.elbow_Edit.Value);
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.elbow_Edit.Value = num2str(value);
                    app.elbow_angle = value;
                    app.elbow_Slider.Value = app.elbow_angle;
                end
            else
                app.elbow_Edit.Value = num2str(0);
                app.elbow_angle = 0;
                app.elbow_Slider.Value = 0;
            end
            assignin("base","elbow_angle",app.elbow_angle);
            set_param('sixDOF_model3/Angle Offset Correction/elbow_angle', 'Value', num2str(app.elbow_angle));
        end

        % Value changed function: inner_wrist_Edit
        function inner_wrist_EditValueChanged(app, event)
            value = str2num(app.inner_wrist_Edit.Value); %#ok<*ST2NM> 
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.inner_wrist_Edit.Value = num2str(value);
                    app.inner_wrist_angle = value;
                    app.inner_wrist_Slider.Value = app.inner_wrist_angle;
                end
            else
                app.inner_wrist_Edit.Value = num2str(0);
                app.inner_wrist_angle = 0;
                app.inner_wrist_Slider.Value = 0;
            end
            assignin("base","inner_wrist_angle",app.inner_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist_angle', 'Value', num2str(app.inner_wrist_angle));
        end

        % Value changed function: middle_wrist_Edit
        function middle_wrist_EditValueChanged(app, event)
            value = str2num(app.middle_wrist_Edit.Value);
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.middle_wrist_Edit.Value = num2str(value);
                    app.middle_wrist_angle = value;
                    app.middle_wrist_Slider.Value = app.middle_wrist_angle;
                end
            else
                app.middle_wrist_Edit.Value = num2str(0);
                app.middle_wrist_angle = 0;
                app.middle_wrist_Slider.Value = 0;
            end
            assignin("base","middle_wrist_angle",app.middle_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist_angle', 'Value', num2str(app.middle_wrist_angle));
        end

        % Value changed function: outer_wrist_Edit
        function outer_wrist_EditValueChanged(app, event)
            value = str2num(app.outer_wrist_Edit.Value);
            value = round(value);
            if value<=app.Upper
                if value>=app.Lower
                    app.outer_wrist_Edit.Value = num2str(value);
                    app.outer_wrist_angle = value;
                    app.outer_wrist_Slider.Value = app.outer_wrist_angle;
                end
            else
                app.outer_wrist_Edit.Value = num2str(0);
                app.outer_wrist_angle = 0;
                app.outer_wrist_Slider.Value = 0;
            end
            assignin("base","outer_wrist_angle",app.outer_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist_angle', 'Value', num2str(app.outer_wrist_angle));
        end

        % Value changing function: shoulder_Slider
        function shoulder_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.shoulder_angle = changingValue;
            app.shoulder_Edit.Value = num2str(app.shoulder_angle);
            assignin("base","shoulder_angle",app.shoulder_angle);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder_angle', 'Value', num2str(app.shoulder_angle));
        end

        % Value changing function: elbow_Slider
        function elbow_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.elbow_angle = changingValue;
            app.elbow_Edit.Value = num2str(app.elbow_angle);
            assignin("base","elbow_angle",app.elbow_angle);
            set_param('sixDOF_model3/Angle Offset Correction/elbow_angle', 'Value', num2str(app.elbow_angle));
        end

        % Value changing function: inner_wrist_Slider
        function inner_wrist_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.inner_wrist_angle = changingValue;
            app.inner_wrist_Edit.Value = num2str(app.inner_wrist_angle);
            assignin("base","inner_wrist_angle",app.inner_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist_angle', 'Value', num2str(app.inner_wrist_angle));
        end

        % Value changing function: middle_wrist_Slider
        function middle_wrist_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.middle_wrist_angle = changingValue;
            app.middle_wrist_Edit.Value = num2str(app.middle_wrist_angle);
            assignin("base","middle_wrist_angle",app.middle_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist_angle', 'Value', num2str(app.middle_wrist_angle));
        end

        % Value changing function: outer_wrist_Slider
        function outer_wrist_SliderValueChanging(app, event)
            changingValue = event.Value;
            changingValue = round(changingValue);
            app.outer_wrist_angle = changingValue;
            app.outer_wrist_Edit.Value = num2str(app.outer_wrist_angle);
            assignin("base","outer_wrist_angle",app.outer_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist_angle', 'Value', num2str(app.outer_wrist_angle));
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            app.base_Edit.Value = "0";
            app.shoulder_Edit.Value = "0";
            app.elbow_Edit.Value = "0";
            app.inner_wrist_Edit.Value = "0";
            app.middle_wrist_Edit.Value = "0";
            app.outer_wrist_Edit.Value = "0";
            
            app.base_Slider.Value = 0;
            app.shoulder_Slider.Value = 0;
            app.elbow_Slider.Value = 0;
            app.inner_wrist_Slider.Value = 0;
            app.middle_wrist_Slider.Value = 0;
            app.outer_wrist_Slider.Value = 0;
            
            assignin("base","base_angle",app.base_angle);
            set_param('sixDOF_model3/Angle Offset Correction/base_angle', 'Value', num2str(app.base_angle));
            assignin("base","shoulder_angle",app.shoulder_angle);
            set_param('sixDOF_model3/Angle Offset Correction/shoulder_angle', 'Value', num2str(app.shoulder_angle));
            assignin("base","elbow_angle",app.elbow_angle);
            set_param('sixDOF_model3/Angle Offset Correction/elbow_angle', 'Value', num2str(app.elbow_angle));
            assignin("base","inner_wrist_angle",app.inner_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/inner_wrist_angle', 'Value', num2str(app.inner_wrist_angle));
            assignin("base","middle_wrist_angle",app.middle_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/middle_wrist_angle', 'Value', num2str(app.middle_wrist_angle));
            assignin("base","outer_wrist_angle",app.outer_wrist_angle);
            set_param('sixDOF_model3/Angle Offset Correction/outer_wrist_angle', 'Value', num2str(app.outer_wrist_angle));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ArmsReachUIFigure and hide until all components are created
            app.ArmsReachUIFigure = uifigure('Visible', 'off');
            app.ArmsReachUIFigure.AutoResizeChildren = 'off';
            app.ArmsReachUIFigure.Color = [1 1 1];
            app.ArmsReachUIFigure.Position = [100 100 429 501];
            app.ArmsReachUIFigure.Name = 'Arms Reach';
            app.ArmsReachUIFigure.Icon = 'RobotArm.ico';
            app.ArmsReachUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.ArmsReachUIFigure);
            app.GridLayout.ColumnWidth = {417, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create LinkLamp
            app.LinkLamp = uilamp(app.LeftPanel);
            app.LinkLamp.Position = [377 474 20 20];
            app.LinkLamp.Color = [1 0 0];

            % Create Switch
            app.Switch = uiswitch(app.LeftPanel, 'slider');
            app.Switch.Items = {'off', 'on'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Tooltip = {'Be sure to Connect the Raspberry Pi before turning on the motors!'};
            app.Switch.Position = [306 474 45 20];
            app.Switch.Value = 'off';

            % Create ResetButton
            app.ResetButton = uibutton(app.LeftPanel, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [25 419 100 22];
            app.ResetButton.Text = 'Reset';

            % Create StartButton
            app.StartButton = uibutton(app.LeftPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Tag = 'Forward Start';
            app.StartButton.Position = [286 419 100 22];
            app.StartButton.Text = 'Start';

            % Create ForwardKinematicsPanel
            app.ForwardKinematicsPanel = uipanel(app.LeftPanel);
            app.ForwardKinematicsPanel.TitlePosition = 'centertop';
            app.ForwardKinematicsPanel.Title = 'Forward Kinematics';
            app.ForwardKinematicsPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ForwardKinematicsPanel.Position = [24 21 362 375];

            % Create OuterWristSliderLabel
            app.OuterWristSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.OuterWristSliderLabel.HorizontalAlignment = 'center';
            app.OuterWristSliderLabel.WordWrap = 'on';
            app.OuterWristSliderLabel.Position = [1 302 54 43];
            app.OuterWristSliderLabel.Text = 'Outer Wrist';

            % Create outer_wrist_Slider
            app.outer_wrist_Slider = uislider(app.ForwardKinematicsPanel);
            app.outer_wrist_Slider.Limits = [-180 180];
            app.outer_wrist_Slider.ValueChangingFcn = createCallbackFcn(app, @outer_wrist_SliderValueChanging, true);
            app.outer_wrist_Slider.Position = [76 332 150 3];

            % Create MiddleWristSliderLabel
            app.MiddleWristSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.MiddleWristSliderLabel.HorizontalAlignment = 'center';
            app.MiddleWristSliderLabel.WordWrap = 'on';
            app.MiddleWristSliderLabel.Position = [1 249 54 43];
            app.MiddleWristSliderLabel.Text = 'Middle Wrist';

            % Create middle_wrist_Slider
            app.middle_wrist_Slider = uislider(app.ForwardKinematicsPanel);
            app.middle_wrist_Slider.Limits = [-180 180];
            app.middle_wrist_Slider.ValueChangingFcn = createCallbackFcn(app, @middle_wrist_SliderValueChanging, true);
            app.middle_wrist_Slider.Position = [76 279 150 3];

            % Create InnerWristSliderLabel
            app.InnerWristSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.InnerWristSliderLabel.HorizontalAlignment = 'center';
            app.InnerWristSliderLabel.WordWrap = 'on';
            app.InnerWristSliderLabel.Position = [1 198 48 41];
            app.InnerWristSliderLabel.Text = 'Inner Wrist';

            % Create inner_wrist_Slider
            app.inner_wrist_Slider = uislider(app.ForwardKinematicsPanel);
            app.inner_wrist_Slider.Limits = [-180 180];
            app.inner_wrist_Slider.ValueChangingFcn = createCallbackFcn(app, @inner_wrist_SliderValueChanging, true);
            app.inner_wrist_Slider.Position = [70 226 156 3];

            % Create ElbowSliderLabel
            app.ElbowSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.ElbowSliderLabel.HorizontalAlignment = 'center';
            app.ElbowSliderLabel.Position = [1 141 54 43];
            app.ElbowSliderLabel.Text = 'Elbow';

            % Create elbow_Slider
            app.elbow_Slider = uislider(app.ForwardKinematicsPanel);
            app.elbow_Slider.Limits = [-180 180];
            app.elbow_Slider.ValueChangingFcn = createCallbackFcn(app, @elbow_SliderValueChanging, true);
            app.elbow_Slider.Position = [76 171 150 3];

            % Create ShoulderSliderLabel
            app.ShoulderSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.ShoulderSliderLabel.HorizontalAlignment = 'center';
            app.ShoulderSliderLabel.Position = [1 86 54 43];
            app.ShoulderSliderLabel.Text = 'Shoulder';

            % Create shoulder_Slider
            app.shoulder_Slider = uislider(app.ForwardKinematicsPanel);
            app.shoulder_Slider.Limits = [-180 180];
            app.shoulder_Slider.ValueChangingFcn = createCallbackFcn(app, @shoulder_SliderValueChanging, true);
            app.shoulder_Slider.Position = [76 116 150 3];

            % Create BaseSliderLabel
            app.BaseSliderLabel = uilabel(app.ForwardKinematicsPanel);
            app.BaseSliderLabel.HorizontalAlignment = 'center';
            app.BaseSliderLabel.Position = [1 29 54 40];
            app.BaseSliderLabel.Text = 'Base';

            % Create base_Slider
            app.base_Slider = uislider(app.ForwardKinematicsPanel);
            app.base_Slider.Limits = [-180 180];
            app.base_Slider.ValueChangingFcn = createCallbackFcn(app, @base_SliderValueChanging, true);
            app.base_Slider.Position = [76 56 150 3];

            % Create outer_wrist_Edit
            app.outer_wrist_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.outer_wrist_Edit.ValueChangedFcn = createCallbackFcn(app, @outer_wrist_EditValueChanged, true);
            app.outer_wrist_Edit.Position = [254 313 100 22];
            app.outer_wrist_Edit.Value = '0';

            % Create middle_wrist_Edit
            app.middle_wrist_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.middle_wrist_Edit.ValueChangedFcn = createCallbackFcn(app, @middle_wrist_EditValueChanged, true);
            app.middle_wrist_Edit.Position = [254 260 100 22];
            app.middle_wrist_Edit.Value = '0';

            % Create inner_wrist_Edit
            app.inner_wrist_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.inner_wrist_Edit.ValueChangedFcn = createCallbackFcn(app, @inner_wrist_EditValueChanged, true);
            app.inner_wrist_Edit.Position = [254 207 100 22];
            app.inner_wrist_Edit.Value = '0';

            % Create elbow_Edit
            app.elbow_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.elbow_Edit.ValueChangedFcn = createCallbackFcn(app, @elbow_EditValueChanged, true);
            app.elbow_Edit.Position = [254 152 100 22];
            app.elbow_Edit.Value = '0';

            % Create shoulder_Edit
            app.shoulder_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.shoulder_Edit.ValueChangedFcn = createCallbackFcn(app, @shoulder_EditValueChanged, true);
            app.shoulder_Edit.Position = [254 97 100 22];
            app.shoulder_Edit.Value = '0';

            % Create base_Edit
            app.base_Edit = uieditfield(app.ForwardKinematicsPanel, 'text');
            app.base_Edit.ValueChangedFcn = createCallbackFcn(app, @base_EditValueChanged, true);
            app.base_Edit.Position = [254 37 100 22];
            app.base_Edit.Value = '0';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Show the figure after all components are created
            app.ArmsReachUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Arms_Reach

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ArmsReachUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ArmsReachUIFigure)
        end
    end
end