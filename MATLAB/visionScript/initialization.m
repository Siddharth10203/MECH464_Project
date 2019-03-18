%%  MeArm Vision Initialization Script
%   Author: Kaitai Tong (Alan)
%   Date:   March 17,2019

%   Get Scale Value to map from pixels to real-world spatial dimentions, we
%   are studying a 2D case here, where user is required to first calibrate
%   the system by selecting 'Set Arena' to set 4 points on the captured
%   image as boundary coordinates of Arena. System will then require user
%   to input real-world length (in any units, as long as consistent), for
%   each corresponding length. Script will evalute the value (scaleResult)
%   to map real-world length from pixel indices. Function 'Take Measurement
%   ' is for the purpose of testing such evaluation.

global testImage
global arenaCoordinates
global fig
global scaleResult
global measurementResult

testImage = imread('demo3.jpg');            % change this path
[width, height, col] = size(testImage);     % extract info from image
testImage_gray = rgb2gray(testImage);       % grayscaled
fig = figure;
imshow(testImage_gray); title('Captured Image');
set(gcf,'name','MeArm Camera Window',...
    'Color',[1 1 1])

%   Get GUI size Info and create Buttons
pos = get(gcf, 'Position');
fig_Width = pos(3);
fig_height = pos(4);
operationPanel = uipanel(fig,'Position',[0.2 0.02 0.6 0.1]);
button_setArena = uicontrol(operationPanel,...
    'Position',[11 11 200 30],'String','Set Arena',...
    'Style','pushbutton');
button_setArena.Callback = @setArena;

button_measure = uicontrol(operationPanel,...
    'Position',[400 11 200 30],'String','Take Measurement',...
    'Style','pushbutton');
button_measure.Callback = @measure;

% ======================
% Callback function list
% ======================

function setArena(src,event)
global arenaCoordinates
global fig
global scaleResult

%   Let user set location of boundaries for Arena, it is better to select
%   points in a cw or ccw order, since we will later ask for length info
counter = 4;                                % rectangle bondary
selectedPts = [];
setLength = [];
while counter ~= 0
    [x_coord,y_coord] = ginput(1);
    selectedPts = [selectedPts; x_coord, y_coord];
    fig; hold on;
    plot(x_coord, y_coord, 'r.','MarkerSize',20);
    counter = counter-1;
end
% hold off;

%   Ask user for real-world spatial info
for numLine = 1:4
    if numLine == 4
        currentLine = [selectedPts(numLine,1),selectedPts(numLine,2);...
            selectedPts(1,1),selectedPts(1,2)];
    else
        currentLine = [selectedPts(numLine,1),selectedPts(numLine,2);...
            selectedPts(numLine+1,1),selectedPts(numLine+1,2)];
    end
    indexDistance = pdist(currentLine);
    
    fig; hold on;
    plot(currentLine(:,1), currentLine(:,2), 'r',...
        'LineWidth',8); hold off;
    userPrompt = {'Distance of this line:'};
    dialogTitle = 'Real-World Spatial Info';
    dimentionInput = inputdlg(userPrompt, dialogTitle, 1, {'0'});
    setLength = [setLength;indexDistance,str2num(dimentionInput{1})];
end

%   Store selected points info, and compute scale value
arenaCoordinates = [selectedPts,setLength];
scaleResult = mean(setLength(:,2)./setLength(:,1)); % real/pixel

end

function measure(src,event)
global fig
global scaleResult
global measurementResult

selectedPts = [];
for numPts = 1:2
    [x_coord,y_coord] = ginput(1);
    selectedPts = [selectedPts;x_coord,y_coord];
    
    fig; hold on;
    plot(x_coord, y_coord, 'b.','MarkerSize',20);
    
end
hold off;

%   Store measurement spatial result
indexDistance = pdist(selectedPts);
measurementResult = indexDistance*scaleResult;
msgbox(sprintf('Distance is %f',measurementResult));
end
