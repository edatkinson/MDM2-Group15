% Load two consecutive frames
frame1 = imread('frame000001.jpg');
frame2 = imread('frame000753.jpg');

% Convert frames to grayscale
frame1gray = rgb2gray(frame1);
frame2gray = rgb2gray(frame2);

% Specify region of interest (ROI) in first frame
roi = [33,20,100,100]; % [x,y,width,height] 
x = roi(1); y = roi(2); w = roi(3); h = roi(4);

% Compute optical flow using Lucas-Kanade method
opticFlow = opticalFlowLK('NoiseThreshold',0.009);
flow = estimateFlow(opticFlow, frame1gray);

% Track motion of ROI using flow vectors
u = flow.Vx(y:y+h, x:x+w);
v = flow.Vy(y:y+h, x:x+w);
x = x + sum(u(:));
y = y + sum(v(:));
roi_new = [x,y,w,h];


% Visualize flow field
figure; imshow(frame1);
hold on;
plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
title('Optical Flow Field');
hold off;

frames = [];
frames(:,:,1) = frame1gray;
frames(:,:,2) = frame2gray;
difference = diff(frames(:,:,1));


% Visualize motion of ROI in second frame
figure; imshow(frame2);
hold on;
rectangle('Position',roi_new,'EdgeColor','r');
title('Motion of ROI');
hold off;