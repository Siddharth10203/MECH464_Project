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
%% find theta_1
temp = atan(y/x);

if x>=0
    theta_1=temp;
    if y<0
       theta_1=(2*pi)+temp; 
    end
else
    theta_1=(pi)+temp;
end
end

