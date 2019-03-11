%%  Servo_Angle_Provider
%   Objective:  To create a function which takes inputs of angles theta
%       1, 2 & 3 for the various servo positions for the MeArm.
%   Author: Siddharth Ganapathy
%   Date:   March 11,2019
%
%   Reference: https://www.allaboutcircuits.com/projects/...
%               servo-control-with-arduino-through-matlab/



port = 'COM3';  % Initialize COM Port
board = 'Uno';  % model of your arduino board

% creating arduino object with servo library
arduino_board = arduino(port, board, 'Libraries', 'Servo');

% Create Servo Motor Objects:
servo_motor_1 = servo(arduino_board, 'D8');
servo_motor_2 = servo(arduino_board, 'D9');
servo_motor_3 = servo(arduino_board, 'D10');
claw = servo(arduino_board, 'D11');

%   Angles = [Theta1 Theta2 Theta3 Claw]
function [T1,T2,T3,C] = AngleWrite(A)
%   Corrected/Calibrated angle values, essentially we
%       provide a PWM value from 0 to 1 duty cycle
%       (ie/0-180 degrees).

%   Writes Actual position to the motor
   writePosition(servo_motor_1, A(1));
   writePosition(servo_motor_2, A(2));
   writePosition(servo_motor_3, A(3));
   writePosition(claw, A(4));
   
%   Reads angular position of the servo & reports back
%       to the MCU.
    

    pause(2)
end

% loop to rotate servo motor from 0 to 180
% for angle = 0:0.2:1
%    writePosition(servo_motor_1, angle);
%    current_position = readPosition(servo_motor_1);
%    current_position = current_position * 180;   
%    % print current position of servo motor
%    fprintf('Current position is %d\n', current_position);   
%    % small delay is required so that servo can be positioned at the
%    % angle told to it.
%    pause(2);
% end
% bring back motor to 0 angle position
% writePosition(servo_motor_1, 0);