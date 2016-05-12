function [p1Percent,p2Percent] = percentsTest(frame,p1Location,p2Location)

	
%Script pa sacar los porcentajes
categoryClassifier = importdata('C:/py/catClassifierExpanded.mat');
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

%get areas within the same Y values, i.e height %RANDOM CHANGES REVIEW ADDED THE &  & bboxes(:,2) > 2 PART because it was findind a random area and fucking me up
try
	stats = stats(bboxes(:,2) < 50 & bboxes(:,2) > 2,:); 
catch
	stats = stats';
	stats = stats(bboxes(:,2) < 50 & bboxes(:,2) > 2,:);
end 

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

%near bounding boxes are digits of the percent of that player
players = startpoint < firstplayer + 120 ;
[kk,sorted] = sort(startpoint);

%number of players alive
playersAlive=size(unique(players),2);

%number of digits of first players percentage (if both are alive, otherwise it could be from either)
ndigits = sum(players);
percentDigit = {};


for i=1:size(stats,1)
[labelIdx, scores] = predict(categoryClassifier, aer{i});
percentDigit{i} = categoryClassifier.Labels(labelIdx);
end


%PRUEBAS 
sortedDigits = percentDigit(sorted);

if playersAlive==2
	
	p1Percent = strcat(sortedDigits{1:ndigits});
	p2Percent = strcat(sortedDigits{(ndigits+1):end});
elseif playersAlive==1
	playerPosition = max(startpoint);
	if (abs(playerPosition - p1Location) < abs(playerPosition - p2Location))
		p1Percent = strcat(sortedDigits{1:ndigits});
		p2Percent = {'.'};
	else
		p1Percent = {'.'};
		p2Percent = strcat(sortedDigits{1:ndigits});
	end
end
	

end


