function [arm_angles] = inv_kin(r, theta, z)
% inv_kin() takes cylindrical coordinates and converts to 3 joint angles for the mearm.
% 
% r
% theta
% z

L_1=80; %mm
L_2=80; %mm

%% find theta_1
theta_1 = theta;

%% find theta_2, 3
L = sqrt(r^2 + z^2);

temp_angle = acos((L^2-L_1^2-L_2^2)/(2*L_1*L_2));
alpha = atan2(z,r);
beta = acos((L_1^2 + L^2 - L_2^2)/(2*L_1*L));
theta_2 = alpha + beta;
theta_3 = temp_angle  -theta_2;
%% output values

arm_angles = [theta_1 theta_2 theta_3];
end
