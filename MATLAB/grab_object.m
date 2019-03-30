%%% Top Level Script %%%

%% Get the location of object
[r, theta] = ;
z = -20; % object height (mm)

%% Inverse Kinematics
A = inv_kin(r, theta, z);

%% Pass arm angles to path planner
path_plan(A);