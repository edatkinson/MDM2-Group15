clc
clear all
close all
warning off
c=webcam;
images = {};

time0 = tic;
timeLimit = 6*1; % 6 seconds

for i = 1:500; 
    e=c.snapshot;
    mkdir = createMask(e); 
    images{i} = mkdir; %write images to be saved later
    if toc(time0)>timeLimit %ends loop after the "timeLimit" 
      break
    end

end

num = size(images);
numItem = num(2);

for j = 1:numItem;
    imwrite(images{j}, ['camera1_' num2str(j) '.png']) %saves images from the cells 
end
