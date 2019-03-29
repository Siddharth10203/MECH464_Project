%%  Servo_Angle_Provider
%   Objective:  To create a function which takes inputs of angles theta
%       1, 2, 3, & 4 for the various servo positions for the MeArm.
%   Author: Siddharth Ganapathy
%   Date:   March 18,2019
%
%   Reference: https://www.allaboutcircuits.com/projects/...
%               servo-control-with-arduino-through-matlab/

function Position = Angle_Provider(A)
    %   Initialize Arduino Object
    port = 'COM5';  % Initialize COM Port
    board = 'Uno';  % model of your arduino board
    arduino_board = arduino(port, board, 'Libraries', 'Servo');
    
    % Initialize Servo Objects
    servo_motor_1 = servo(arduino_board, 'D6');
    servo_motor_2 = servo(arduino_board, 'D9');
    servo_motor_3 = servo(arduino_board, 'D10');
    claw = servo(arduino_board, 'D11');
    
    %   Base rotates +/- 90 degrees from neutral position
    %       0 PWM = -90 degrees & 1 PWM = 90 degrees
    writePosition(servo_motor_1, (A(1)+90)/180);
    %   Shoulder rotates +45/-25 degrees from neutral position
    %       0.36 PWM = -25 degrees & 0.75 PWM = 45 degrees
    writePosition(servo_motor_2, (A(2)+90)/180);
    %   Elbow rotates -45 degrees from neutral position
    %       0.60 PWM = -70 degrees & 1 PWM = 0 degrees
    writePosition(servo_motor_3, (A(3)+180)/180);
    %   Claw either opens or closes
    %       0.25 PWM = (Open) & 1 PWM = (Close)
    writePosition(claw, A(4));
    
    Position = A;
    fclose( serial(arduino_board.Port) );
    clear arduino_board; %Remove the variable
end