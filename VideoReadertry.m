

% Load the video file
vid = VideoReader('trimmed_systemvideo.mp4');

% Define the patch to analyze in the first frame
patch_x = 70; % x-coordinate of top-left corner of patch
patch_y = 20; % y-coordinate of top-left corner of patch
patch_width = 100; % width of patch
patch_height = 100; % height of patch
velocities = [];
orientations = [];
%figure;
% Iterate through each frame of the video
while hasFrame(vid)
    
    % Read the current frame
    frame = readFrame(vid);
    
    % Extract the patch from the current frame
    patch = frame(patch_y:patch_y+patch_height-1, patch_x:patch_x+patch_width-1);
    
    % Estimate the displacement of the patch between the current frame and the previous frame
    if exist('prev_patch', 'var')
        opticalFlow = opticalFlowFarneback;
        flow = estimateFlow(opticalFlow, prev_patch);
        velocity_x  = flow.Vx(ceil(patch_height/2), ceil(patch_width/2)); % Use the velocity at the center of the patch
        velocity_y = flow.Vy(ceil(patch_height/2), ceil(patch_width/2)); % Use the velocity at the center of the patch
        velocity_mag = sqrt(velocity_x.^2 + velocity_y.^2);
        orientation = flow.Orientation(ceil(patch_height/2), ceil(patch_width/2));
        orientations = [orientations; orientation];
        velocities = [velocities; velocity_x, velocity_y, velocity_mag];
        % Plot the optical flow vectors
%          imshow(frame)
%          hold on;
%          centre_x = patch_x + patch_width/2;
%          centre_y = patch_y + patch_height/2;
%          quiver(centre_x, centre_y, velocity_x(:), velocity_y(:), 2, 'r', 'LineWidth', 1, 'MaxHeadSize', 3, 'AutoScaleFactor', 10, 'Color', 'b', 'ShowArrowHead', 'off',...
%               'AutoScale', 'off', 'DisplayName', 'Optical Flow Vectors',...
%               'UData', velocity_x./velocity_mag, 'VData', velocity_y./velocity_mag);
%           axis([patch_x, patch_x+patch_width-1, patch_y, patch_y+patch_height-1]);
%          drawnow;

    end
    
    % Store the current patch as the previous patch for the next iteration
    prev_patch = patch;
end

displacement_x = diff(velocities(:,1));
displacement_y = diff(velocities(:,2));
disp_mag = sqrt(displacement_x.^2 + displacement_y.^2);
t = linspace(0,42,length(velocities));
td = linspace(0,42,length(displacement_x)); 
angular_vel = diff(orientations);

% figure; Magnitudes of velocity and displacement.
% subplot(3,1,1)
% plot(td,disp_mag,'b');
% title('Displacement graph against Time ');
% xlabel('Time');
% ylabel('Displacement');
% 
% subplot(3,1,2)
% plot(t,velocities(:,3),'r');
% title("Velocity Graph Against Time)");
% xlabel('Time');
% ylabel('Velocity');

figure;
plot(td,angular_vel)
title("Angular Velocity");
xlabel("Time (s)");
ylabel("Angular Velocity (Rad/s)");


figure;
subplot(4,1,1)
plot(t,velocities(:,1),'r');
title("Velocity Graph Against Time (X-Direction)");
xlabel('Time');
ylabel('Velocity');
subplot(4,1,2)
plot(td,displacement_x, 'b');
title('Displacement graph against Time (X-Direction)')
xlabel('Time');
ylabel('Displacement');
subplot(4,1,3);
plot(t,velocities(:,2),'r');
title("Velocity Graph Against Time (Y-Direction)");
xlabel('Time');
ylabel('Velocity');
subplot(4,1,4);
plot(td,displacement_y,'b')
title('Displacement graph against Time (Y-Direction)')
xlabel('Time');
ylabel('Displacement');





