%%% Top Level Script %%%

%% Get the location of object
[loc,corloc, pivot, centroid, B] = location(corners, offset, A);
r = corloc(1);
theta = corloc(2);
z = -20; % object height (mm)

%% Inverse Kinematics
A = inv_kin(r, theta, z);

%% Pass arm angles to path planner
path_plan(A);