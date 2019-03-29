function [arduino_board, s1, s2, s3, s4] = servo_connect(port)
%servo_connect() Simply connects to the servo motor of our mearm
%   Returns all the servo connections which can be passed to writePosition
%   port: servo port (example = 'COM4')
%   s1: base
%   s2: shoulder
%   s3: elbow
%   s4: claw

%   Initialize Arduino Object
board = 'Uno';  % model of your arduino board
arduino_board = arduino(port, board, 'Libraries', 'Servo');

s1 = servo(arduino_board, 'D6');
s2 = servo(arduino_board, 'D9');
s3 = servo(arduino_board, 'D10');
s4 = servo(arduino_board, 'D11');
end

