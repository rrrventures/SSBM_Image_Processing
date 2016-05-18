
function [p1Location,p2Location] = location(frame,I)

	%Location finder of bounding boxes for percents, to get where in the image the percents are
	%It is useful to avoid errors when the filtering of the MSER regions ends up finding regions
	%That are very obviously not percent numbers due to their location
	%It is only used a couple of frames in the mainscript, as an aid location finder to later get
	%More accurate results
	%Its pretty much a duplicated code from the usual percentTest

	%Find features of image
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

	%Find useful indices
	[a,finalIndices] = unique(componentIndices,'first');


	%Stats struct with overlapped bboxes removed
	stats = stats(finalIndices);


	%New relevant bounding boxes
	bboxes = vertcat(stats.BoundingBox);

	%Get areas within the same Y values, i.e height
	stats = stats(bboxes(:,2) < 50,:);

	%Cell to place cropped images
	aer = cell(1,4);

	%Get cropped images of the percents numbers
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