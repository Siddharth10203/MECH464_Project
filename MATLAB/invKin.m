function [arm_angles] = invKin(r, theta, z)
% takes cylindrical coordinates and converts to 3 joint angles for the mearm.
l1=80; %mm
l2=80; %mm

%% find theta_1
theta_1 = theta;

%% find theta_2, 3
l = sqrt(r^2 + z^2);

temp_angle = acos((l^2-l1^2-l2^2)/(2*l1*l2));
alpha=atan2(z,d);
beta= acos((l1^2+l^2-l2^2)/(2*l1*l));
theta_2 = alpha+beta;
theta_3 = temp_angle-theta_2;
%% output values

arm_angles = [theta_1 theta_2 theta_3];
end

