function [] = path_plan(port)
%path_plan() Simply connects to the arduino and executes a path.
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
% s3 must be greater than 0.5

% Desired position (will pass to arm later as part of function)
p1 = 0.5;
p2 = 0.7;
p3 = 0.8;

% Drop position
d1 = 0.85;
d2 = 0.6;
d3 = 1;

% Home position
h1 = 0.75;
h2 = 0.4;
h3 = 0.9;
h4 = 0.25;

% Pause time
dt = 2;

% Initialize Arduino Object
board = 'Uno';  % model of your arduino board
arduino_board = arduino(port, board, 'Libraries', 'Servo');

s1 = servo(arduino_board, 'D6');
s2 = servo(arduino_board, 'D9');
s3 = servo(arduino_board, 'D10');
s4 = servo(arduino_board, 'D11');

% Move to desired location and pick up object
writePosition(s4, 0.25);
writePosition(s1, p1);
pause(dt);
writePosition(s2, p2);
writePosition(s3, p3);
pause(dt);
writePosition(s4, 1);
pause(dt);

% Move to drop point and drop
writePosition(s1, d1);
writePosition(s2, d2);
writePosition(s3, d3);
writePosition(s4, 1);
pause(dt);
writePosition(s4, 0.25);
pause(dt);

% Move home
writePosition(s1, h1);
writePosition(s2, h2);
writePosition(s3, h3);
writePosition(s4, h4);
pause(dt);

fclose( serial(arduino_board.Port) );
clear arduino_board; %Remove the variable
end
