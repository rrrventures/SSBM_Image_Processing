function expandedBBoxes = expandbox(bboxes) 
	% Get bounding boxes for all the regions with a bit of expanding
	% Convert from the [x y width height] bounding box format to the [xmin ymin
	% xmax ymax] format for convenience.

	expandedBBoxes = [(bboxes(:,1)-10) bboxes(:,2)*0.3 (bboxes(:,3)+15) (bboxes(:,4)+15)];

end
