%% Localize Object (P: corners(req), imgInit(req), imgLoc(opt)) 
%  Localizes object in the arena by using the corners found with
%  locationInit(). It outputs the location (x,y) of the object wrt to the 
%  upper left corner of the arena.
function [loc, corloc, pivot, centroid] = location(corners, offset, imgInit,imgLoc)
    %Check if the a priori image exist (FOR DEBUGGING), else capture picture
    %using external USB Camera (requires MATLAB USB Camera Package!!!)
    if ~exist('imgLoc','var')
         if length(webcamlist) < 1
            error('External camera is not connected');
         else
             cam = webcam(2);
             imgLoc = snapshot(cam);
             clear cam;
         end         
    end
    imgLoc = imcrop(imgLoc, [0 0 length(imgLoc) 438]);
    %Obtains grayscale sustraction of the background
    subs_gray = rgb2gray(imcomplement(imgLoc)-imcomplement(imgInit));
    
    %Binarize image with optimal threholding
    level = graythresh(subs_gray);
    subs_BW = imbinarize(subs_gray,level);
    
    %Open image to eliminate noise
    se = strel('disk',7);
    subs_BW_open=imopen(subs_BW, se);
    
    %Identify connected BW regions (object)
    cc = bwconncomp(subs_BW_open,4);
    
    %Get properties from BW regions
    regiondata = regionprops(cc,'Centroid');
    centroid = [regiondata.Centroid];
    
    
    pivot = [(corners(2, 1)+corners(4, 1))/2,(corners(2, 2)+corners(4, 2))/2];
    mag =  pdist([pivot; centroid],'Euclidean');
    v = (pivot-centroid)';
    w = (corners(2,:)-corners(4,:))';
    theta = acos(dot(v,w)/(norm(v)*norm(w)));
    
    a = getRealDist(corners, [pivot; centroid]);
    c = sqrt(a^2 + offset^2 - 2*a*offset*cos(theta+pi/2));
    gamma = pi/2-asin(a*sin(theta+pi/2)/c);
    
    %Output location and corrected location in polar coords
    loc = [mag, theta];  
    corloc = [c, gamma];
end

