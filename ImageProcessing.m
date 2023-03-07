
% https://www.mathworks.com/products/image.html#iman
% Code written and posted by ImageAnalyst, originally in July 2009.
% Updated March 2022 for MATLAB release R2022a
% Editted for the current project by Louis Swanepoel

originalImage = imread('images/camera1_7.png');
captionFontSize = 14;

cleanImage = imfill(originalImage, 'holes');
cleanImage =  bwareaopen(cleanImage, 50);
% Display the binary image.
figure(1)
imshow(cleanImage);
title('Image Cleared of Artifacts using area open function', 'FontSize', captionFontSize);

% Identify individual blobs by seeing which pixels are connected to each other.  This is called "Connected Components Labeling".
% Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% Do connected components labeling with either bwlabel() or bwconncomp().
[labeledImage, numberOfBlobs] = bwlabel(cleanImage, 8);     % Label each blob so we can make measurements of it
% labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.

% Collect all metrics for the circle 
props = regionprops(labeledImage, originalImage, 'all');


% PLOT BOUNDARIES.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries().
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
figure(3)
imshow(originalImage);
title('Outlines, from bwboundaries()', 'FontSize', captionFontSize);
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.
% Here is where we actually get the boundaries for each blob.
boundaries = bwboundaries(cleanImage); % Note: this is a cell array with several boundaries -- one boundary per cell.
% boundaries is a cell array - one cell for each blob.
% In each cell is an N-by-2 list of coordinates in a (row, column) format.  Note: NOT (x,y).
% Column 1 is rows, or y.    Column 2 is columns, or x.
numberOfBoundaries = size(boundaries, 1); % Count the boundaries so we can use it in our for loop
% Here is where we actually plot the boundaries of each blob in the overlay.
hold on; % Don't let boundaries blow away the displayed image.

thisBoundary = boundaries{1}; % Get boundary for this specific blob.
x = thisBoundary(:,2); % Column 2 is the columns, which is x.
y = thisBoundary(:,1); % Column 1 is the rows, which is y.
plot(x, y, 'r-', 'LineWidth', 2); % Plot boundary in red.


%------------------------------------------------------------------------------------------------------------------------------------------------------
% Print out the measurements to the command window, and display blob numbers on the image.
textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% Print header line in the command window.
fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
% Extract all the mean diameters into an array.
% The "diameter" is the "Equivalent Circular Diameter", which is the diameter of a circle with the same number of pixels as the blob.
% Enclosing in brackets is a nice trick to concatenate all the values from all the structure fields (every structure in the props structure array).
blobECD = [props.EquivDiameter];
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the individual measurements of each blob.  They are field of each structure in the props strucutre array.
	% You could use the bracket trick (like with blobECD above) OR you can get the value from the field of this particular structure.
	% I'm showing you both ways and you can use the way you like best.
	meanGL = props(k).MeanIntensity;		% Get average intensity.
	blobArea = props(k).Area;				% Get area.
	blobPerimeter = props(k).Perimeter;		% Get perimeter.
	blobCentroid = props(k).Centroid;		% Get centroid one at a time

	% Now do the printing of this blob's measurements to the command window.
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the grayscale image that is showing the red boundaries on it.
	text(blobCentroid(1), blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
