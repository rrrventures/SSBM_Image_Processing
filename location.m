
function [p1Location,p2Location] = location(frame,I)

%location finder of bounding boxes for percents
%Script pa sacar los porcentajes

[stats, r, I] = featim(frame);

bboxes = vertcat(stats.BoundingBox);

%Remove overlapping bounding boxes
% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(bboxes, bboxes);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1);
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);

%find useful indices
[a,finalIndices] = unique(componentIndices,'first');


%stats struct with overlapped bboxes removed
stats = stats(finalIndices);


%new relevant bounding boxes
bboxes = vertcat(stats.BoundingBox);

%get areas within the same Y values, i.e height
stats = stats(bboxes(:,2) < 50,:);

%imagenes binarias (deprecated)
%aer = extractfield(stats,'Image');
aer = cell(1,4);

%get cropped images of the percents numbers
for i=1:size(bboxes,1)
	aer{i}=imcrop(I,expandbox(bboxes(i,:)));
end


%initial x value of bounding boxes
startpoint = extractfield(stats,'BoundingBox');
startpoint = startpoint(1:4:end);

%first player is the one closer to the left of the image, i.e lower x value
firstplayer = min(startpoint);

%Second player position
secondplayer = max(startpoint);

p1Location = firstplayer;
p2Location = secondplayer;

end