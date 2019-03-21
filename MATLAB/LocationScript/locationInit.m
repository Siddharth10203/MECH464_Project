%% Intialize Arena (P: imgInit(opt))
%  Intializes arena by capturing the its corner features to be used 
%  in the Dimensioning Algorithm.
function [corners, imgInit] = locationInit(imgInit)
    %Check if the a priori image exist (FOR DEBUGGING), else capture picture
    %using external USB Camera (requires MATLAB USB Camera Package!!!)
    if ~exist('imgInit','var')
         if webcamlist < 1
            error('External camera is not connected');
         else
             cam = webcam(2);
             imgInit = snapshot(cam);
             clear cam;
         end         
    end
    %Converts image to grayscale
    I= rgb2gray(imgInit);
    %Used Harris Feauture Detection to obtain arena corners-like features
    C = detectHarrisFeatures(I);
    %Filters the features based on their metrics. It is expected that with 
    %an empty arena, the majority of feutures are located in the arena corners 
    C = C.selectStrongest(10);
    %Use K-means to identify the corners 
    [idx, corners] = kmeans(C.Location,4);
end