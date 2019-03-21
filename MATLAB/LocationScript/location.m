%% Localize Object (P: corners(req), imgInit(req), imgLoc(opt)) 
%  Localizes object in the arena by using the corners found with
%  locationInit(). It outputs the location (x,y) of the object wrt to the 
%  upper left corner of the arena.
function [loc, centroid] = location(corners,imgInit,imgLoc)
    %Check if the a priori image exist (FOR DEBUGGING), else capture picture
    %using external USB Camera (requires MATLAB USB Camera Package!!!)
    if ~exist('imgLoc','var')
         if webcamlist < 1
            error('External camera is not connected');
         else
             cam = webcam(2);
             imgLoc = snapshot(cam);
             clear cam;
         end         
    end
    
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
    
    %UpperLeft corner in arena
    cs = corners;
    [upperLeft,idx] = min(cs);
    cs(idx(1),:) = [];
    %LowerRight corner in arena
    [lowerRight,idx] = max(cs);
    cs(idx(1),:) = [];
    %UpperRight corner in arena
    [uR, idx] = min(cs(:,2));
    upperRight = cs(idx(1));
    %LowerLeft corner in arena
    [lL, idx] = min(cs(:,1));
    lowerLeft = cs(idx(1));
    %Output difference between corners and centroid
    loc = [upperLeft - centroid;
           lowerLeft - centroid;
           upperRight - centroid;
           lowerRight - centroid];    
end

