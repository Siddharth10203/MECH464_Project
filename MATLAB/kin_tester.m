function [] = kin_tester(A)
%kin_tester() Simply connects to the arduino and executes a path.
%   Steps:
%        1 Connect to arduino at port and initialize servos
%        2 Move to desired position and pause
%        3 Pick up object with claw and move to drop point
%        4 Drop object into cup
%        5 Move back to home position
%        6 Close servo connection
%   port: servo port (example = 'COM4')
%   s1: base
%   s2: shoulder
%   s3: elbow
%   s4: claw

%% Joint limits:
% s2 must be greater than 0.4
% s3 must be greater than 0.5
open = 0.3;
close = 1;

% Correction Factors (for robot joint compliance)
bias_1 = 0.023;
bias_2 = -0.1;
bias_3 = -0.125;

% Desired position (will pass to arm later as part of function)
p1 = (A(1)/pi + bias_1);
p2 = (1-(A(2)/pi) + bias_2);
p3 = (1-(A(3)/pi) + bias_3);

% Home position
h1 = 0.9;
h2 = 0.4;
h3 = 0.9;

% Pause time
dt = 2;

% Initialize Arduino Object
board = 'Uno';  % model of your arduino board
arduino_board = arduino('COM5' , board, 'Libraries', 'Servo');

s1 = servo(arduino_board, 'D6');
s2 = servo(arduino_board, 'D9');
s3 = servo(arduino_board, 'D10');
s4 = servo(arduino_board, 'D11');

% Move home
writePosition(s1, h1);
writePosition(s2, h2);
writePosition(s3, h3);
pause(dt);

% Move to desired location and pick up object
writePosition(s4, open);
writePosition(s1, p1);
pause(dt);
writePosition(s2, p2);
writePosition(s3, p3);
pause(dt);
writePosition(s4, close);
pause(dt);

fclose( serial(arduino_board.Port) );
clear arduino_board; %Remove the variable
end

