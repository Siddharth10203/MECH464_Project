%%% Top Level Script %%%

%% Get the location of object
Ax = imread('Ay.png');
[corners, Ax] = locationInit(Ax);
[loc,corloc, pivot, centroid, B] = location(corners, 60, Ax);
r = double(corloc(1));
theta = double(corloc(2));
z = -20; % object height (mm)

%% Inverse Kinematics
A = inv_kin(r, theta, z);

%% Pass arm angles to path planner
path_plan(A);