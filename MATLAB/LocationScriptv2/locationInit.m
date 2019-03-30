%% Intialize Arena (P: imgInit(opt))
%  Intializes arena by capturing the its corner features to be used 
%  in the Dimensioning Algorithm.
function [corners, imgInit] = locationInit(imgInit)
    %Check if the a priori image exist (FOR DEBUGGING), else capture picture
    %using external USB Camera (requires MATLAB USB Camera Package!!!)
    if ~exist('imgInit','var')
         if length(webcamlist) < 1
            error('External camera is not connected');
         else
             cam = webcam(2);
             imgInit = snapshot(cam);
             clear cam;
         end         
    end
    %Converts image to grayscale
    imgInit = imcrop(imgInit, [0 0 length(imgInit) 438]);
    I= rgb2gray(imgInit);
    %Used Harris Feauture Detection to obtain arena corners-like features
    C = detectHarrisFeatures(I);
    %Filters the features based on their metrics. It is expected that with 
    %an empty arena, the majority of feutures are located in the arena corners 
    C = C.selectStrongest(20);
    %Use K-means to identify the corners 
    [idx, cs] = kmeans(C.Location,4);
        %UpperLeft corner in arena
        
    [uL,idx] = min(cs(:,1)+cs(:,2));
    upperLeft = cs(idx(1),:);
    cs(idx(1),:) = [];
    %LowerRight corner in arena
    [lR,idx] = max(cs(:,1)+cs(:,2));
    lowerRight = cs(idx(1),:);
    cs(idx(1),:) = [];
    %UpperRight corner in arena
    [uR, idx] = min(cs(:,2));
    upperRight = cs(idx(1),:);
    %LowerLeft corner in arena
    [lL, idx] = min(cs(:,1));
    lowerLeft = cs(idx(1),:);
    
    corners = [upperLeft; lowerLeft; upperRight; lowerRight];
end