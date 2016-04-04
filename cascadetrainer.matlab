% MATLAB img proc. lazy script

#Get the names of images of positive examples in the folder
x = dir('C:/py/framesPositivos')
names = {x.name}
adssa = names(3:end)

imageFilename ={}

for j=1:390
  imageFilename{j} = sprintf('C:/py/framesPositivos/%s',adssa{j}); 
end

% Info on bounding boxes of every stock example for fox

verde = cell(1,82);
verde(:) = {[405 523 44 44]};
azul = cell(1,114);
azul(:) = {[28 537 40 46]}
blanco = cell(1,97)
blanco(:) = {[625 524 44 44]}
rojo = cell(1,97)
rojo(:) = {[407 523 42 47]}

boundingBoxes =[verde azul blanco rojo] ;


% Negative folder setting and struct to pass to the model trainer

negativeFolder = 'C:\py\framesNegativos'

data2 = struct('imageFilename',imageFilename,'objectBoundingBoxes',boundingBoxes)


% Model Trainer

trainCascadeObjectDetector('meleeDetector.xml',data2,negativeFolder,'NumCascadeStages',20,'TruePositiveRate', 0.997,'FalseAlarmRate',0.3);

detector = vision.CascadeObjectDetector('meleeDetector.xml');


%Just model testing on an image
img = imread('C:/py/apex.jpg');
bbox = step(detector,img);

detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'X');
figure;
imshow(detectedImg);