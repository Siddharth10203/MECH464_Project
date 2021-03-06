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
    
    %Output difference between corners and centroid
    loc = [corners(1) - centroid;
           corners(2) - centroid;
           corners(3) - centroid;
           corners(4) - centroid];    
end

