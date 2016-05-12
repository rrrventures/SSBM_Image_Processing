function stage = whatstage(image)
	categoryClassifier = importdata('C:/py/stageClassifer.mat');

	%stage identifier function
	%crop and resize frame
	bboxI = [367 3 912 715];
	image=imcrop(image,bboxI);
    image=imresize(image,0.4);

    %predict stage
	[labelIdx, scores] = predict(categoryClassifier, image);
	stage = categoryClassifier.Labels(labelIdx);
	
end
