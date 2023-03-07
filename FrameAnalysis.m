function [theta,yDiscplacement,zDiscplacement,yVelocity,zVelocity,thetaDot] = FrameAnalysis(rodLength,directory)

% Extract all png files from the folder 'images' as photos 
frames = dir(directory);
frames = natsortfiles(frames);

% Define frame rate and time in motion etc
timeInMotion = 6;
nFrames = length(frames);

% Create centroid variable to collect position of the ball at a time
centroid = zeros(2,nFrames);
counter = 0;

% Loop through photos finding the centre of mass of the ball at each frame 
for frame = frames'
    counter = counter+1;
    centroid(:,counter) = CentreOfMass([frame.folder '/' frame.name]); 
end

% Extract relevant x and y positions for pixel conversion
zPositionAtRest = centroid(2,end)+(centroid(2,1)-centroid(2,end))./2;

% Pixel to m conversion
convertPixelToM = abs(rodLength/zPositionAtRest);
centroid = centroid.*convertPixelToM;
yPositionDatum = (centroid(1,1)); 
zPositionDatum = centroid(2,1)+(centroid(2,end)-centroid(2,1))/2;


% Extract relevant z and y displacement 
yDiscplacement = centroid(1,:) - yPositionDatum;
zDiscplacement = zPositionDatum-(centroid(2,:));
theta = zeros(nFrames,1);

for n = 1:nFrames
    if zDiscplacement(n) > 0
        if yDiscplacement(n) > 0
            theta(n) = pi/2 - atan((zDiscplacement(n)/yDiscplacement(n)));
        else
            theta(n) = 3*pi/2 + atan(abs(zDiscplacement(n)/yDiscplacement(n)));
        end
    else
        if yDiscplacement(n) > 0
            theta(n) = pi/2 + atan(abs(zDiscplacement(n)/yDiscplacement(n)));
        else
            theta(n) = 3*pi/2 - atan((zDiscplacement(n)/yDiscplacement(n)));
        end
    end    
end

theta(2*pi-theta<0.1) = NaN;

% Velocity calculations
yVelocity = zeros(1,nFrames);
zVelocity = zeros(1,nFrames);
thetaDot =  zeros(1,nFrames);

for n = 1:(nFrames-1)
    yVelocity(n) = (yDiscplacement(n+1)-yDiscplacement(n))./(timeInMotion/nFrames);
    zVelocity(n) = (zDiscplacement(n+1)-zDiscplacement(n))./(timeInMotion/nFrames);
    thetaDot(n) = (theta(n+1)- theta(n))./(timeInMotion/nFrames);
end

% Acceleration calculations 
yAcc = zeros(1,nFrames);
zAcc = zeros(1,nFrames);
thetaDotDot =  zeros(1,nFrames);

for n = 1:(nFrames-1)
    yAcc(n) = (yVelocity(n+1)-yVelocity(n))./(timeInMotion/nFrames);
    zAcc(n) = (zVelocity(n+1)-zVelocity(n))./(timeInMotion/nFrames);
    thetaDotDot(n) = (thetaDot(n+1)- thetaDot(n))./(timeInMotion/nFrames);
end


end