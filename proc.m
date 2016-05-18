function y = proc(img)

	%Helpful function
	paren = @(x, varargin) x(varargin{:});

	
	%Get the useful part, the time numbers
	xsize = paren(size(img),1)/20;
	ysize = paren(size(img),2)/4;
	box_nums = img(xsize:(xsize*4 + 15),ysize:(ysize*3),:);

	
	%Processing of box for easier recognition
	gray_box = rgb2gray(box_nums);
	maxv = max(max(gray_box));
	inverted = maxv - gray_box;
	bw = inverted;
	bw(inverted > 50) = 250;


	%Using OCR to find the digits
	results = ocr(bw, 'CharacterSet', '0123456789', 'TextLayout','Block');
	[sortedConf, sortedIndex] = sort(results.CharacterConfidences, 'descend');

	altura = max(results.CharacterBoundingBoxes(sortedIndex,4))-5;
	gordura = max(results.CharacterBoundingBoxes(sortedIndex,3))/2 - 5;
	indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) & results.CharacterBoundingBoxes(sortedIndex,3) > gordura & results.CharacterBoundingBoxes(sortedIndex,4)> altura );
	indexesNaNsRemovedTry2 = sortedIndex(~isnan(sortedConf) & results.CharacterBoundingBoxes(sortedIndex,3) > 25 & results.CharacterBoundingBoxes(sortedIndex,4)> 25 );

	%Safety measure 
	try
		topTenIndexes = indexesNaNsRemoved(1:4);
	catch
		topTenIndexes = indexesNaNsRemovedTry2(1:4);
	end


	%Get the digits
	digits = num2cell(results.Text(topTenIndexes));
	bboxes = results.CharacterBoundingBoxes(topTenIndexes, :);


	%Order from left to right on image to get actual time
	[aux indextime] = sort(bboxes(:,1),'ascend');
	tiempo = digits(indextime);


	y = str2num(cell2mat(tiempo));

end