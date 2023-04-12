
% Load the video file
vid = VideoReader('trimmed_systemvideo.mp4');

% Define the patch to analyze in the first frame
patch_x = 70; % x-coordinate of top-left corner of patch
patch_y = 20; % y-coordinate of top-left corner of patch
patch_width = 100; % width of patch
patch_height = 100; % height of patch
velocities = [];
orientations = [];

% Iterate through each frame of the video
while hasFrame(vid)
    
    % Read the current frame
    frame = readFrame(vid);
    
    % Extract the patch from the current frame
    patch = frame(patch_y:patch_y+patch_height-1, patch_x:patch_x+patch_width-1);
    
    % Estimate the displacement of the patch between the current frame and the previous frame
    if exist('prev_patch', 'var')
        % Calculate the sub-pixel offset using phase correlation
        [offset_y, offset_x] = phase_correlation(prev_patch, patch);
        offset_y = abs(offset_y);
        offset_x = abs(offset_x);
        %Calculate the high-resolution patch coordinates
        patch_hr_x = patch_x + offset_x;
        patch_hr_y = patch_y + offset_y;
        patch_hr_width = patch_width*2;
        patch_hr_height = patch_height*2;
        
        % Extract the high-resolution patch from the current frame
        patch_hr = imresize(frame(patch_hr_y:patch_hr_y+patch_hr_height-1, patch_hr_x:patch_hr_x+patch_hr_width-1),2);

        % Estimate the displacement of the high-resolution patch
        opticalFlow = opticalFlowFarneback;
        flow = estimateFlow(opticalFlow, prev_patch);
        velocity_x  = flow.Vx(ceil(patch_height/2), ceil(patch_width/2)); % Use the velocity at the center of the patch
        velocity_y = flow.Vy(ceil(patch_height/2), ceil(patch_width/2)); % Use the velocity at the center of the patch
        velocity_mag = sqrt(velocity_x.^2 + velocity_y.^2);
        orientation = flow.Orientation(ceil(patch_height/2), ceil(patch_width/2));
        orientations = [orientations; orientation];
        velocities = [velocities; velocity_x, velocity_y, velocity_mag];
        
    end
    prev_patch = patch;

end


