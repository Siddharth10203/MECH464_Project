function [arm_angles] = invKin(xyzcoords, pixel_space)
% takes xyz coordinates and converts to 4 joint angles for the mearm.
% norm is the max x or y in pixel space. the space should be a square with
% range -x,+x. norm is a single value
%% convert from pixel space to real space in mm.
l1=100; %mm
l2=100; %mm
max_distance_real = l1+l2;
scale=max_distance_real/pixel_space;
x=xyzcoords(1)*scale;
y=xyzcoords(2)*scale;
z=xyzcoords(3)*scale;

xyplane_d=norm([x,y]);
xyz_d=norm([x,y,z]);

if xyz_d > max_distance_real
    arm_angles=[0,0,0,0];
    disp('coordinates outside workspace');
    return
end
%% find theta_1 (base angle)
temp = atan(y/x);

if x >= 0
    theta_1=temp;
    if y < 0
       theta_1=(2*pi)+temp; 
    end
else
    theta_1=(pi)+temp;
end

%% find theta_2, 3
d = sqrt(x^2 + y^2);
l = sqrt(d^2 + z^2);

if z >= 0
    theta_3 = acos((l^2-l1^2-l2^2)/(2*l1*l2));
    alpha = atan(z/d);
    beta = acos((l1^2+l^2-l2^2)/(2*l1*l));
    theta_2 = alpha+beta;
    
else%TODO
    theta_2 = 0;
    theta_3 = 0;
end
%% output values

arm_angles = [theta_1 theta_2 theta_3];
end

