function stage = whatstage(image)
	%Import the model. I should probably avoid loading it each time
	categoryClassifier = importdata('C:/py/stageClassifer.mat');

	%Stage identifier function
	%Crop and resize frame
	bboxI = [367 3 912 715];
	image=imcrop(image,bboxI);
    image=imresize(image,0.4);

    %predict stage
	[labelIdx, scores] = predict(categoryClassifier, image);
	stage = categoryClassifier.Labels(labelIdx);
	
end
