function distReal = getRealDist(corners,meaPts)
%   Function takes in corner locations in and order of UL, LL, UR, LR, and two
%   points of interest for measurement, return the real-world distance
%   between those two points. Assuming the UL to LL is 215.9 mm

%   example of usage: corners = [1 2;10 2;1 20;10 20]
%                     meaPts = [0 5;0 6];
%                     getRealDist(corners,meaPts)

refPts = corners(1:2,:);
ref_distPixel = pdist(refPts,'Euclidean');
mea_distPixel = pdist(meaPts,'Euclidean');

ratio = 215.9/ref_distPixel;

distReal = mea_distPixel*ratio;

end