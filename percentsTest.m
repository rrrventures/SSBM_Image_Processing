function [p1Percent,p2Percent] = percentsTest(frame,p1Location,p2Location)

	
	%Function to get the players percents
	%Load the trained model
	categoryClassifier = importdata('C:/py/catClassifierExpanded.mat');

	%Get the MSER regions to find the numbers locations
	[stats, r, I] = featim(frame);

	%Easier way to deal with the bounding boxes
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

	%update yet again
	bboxes = vertcat(stats.BoundingBox);

	%Cell array to place the cropped images of the numbers
	aer = cell(1,4);

	%Get cropped images of the percents numbers
	for i=1:size(bboxes,1)
		aer{i}=imcrop(I,expandbox(bboxes(i,:)));
	end


	%Initial x value of bounding boxes
	startpoint = extractfield(stats,'BoundingBox');
	startpoint = startpoint(1:4:end);

	%First player is the one closer to the left of the image, i.e lower x value
	firstplayer = min(startpoint);

	%Near bounding boxes are digits of the percent of that player
	players = startpoint < firstplayer + 120 ;
	[kk,sorted] = sort(startpoint);

	%Number of players alive
	playersAlive=size(unique(players),2);

	%Number of digits of first players percentage (if both are alive, otherwise it could be from either)
	ndigits = sum(players);
	percentDigit = {};

	%Using the trained model to predict the number
	for i=1:size(stats,1)
	[labelIdx, scores] = predict(categoryClassifier, aer{i});
	percentDigit{i} = categoryClassifier.Labels(labelIdx);
	end


	%This last part is to get the numbers correctly assigned to the appropiate player. 
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


