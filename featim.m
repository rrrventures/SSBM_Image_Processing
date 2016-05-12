function [x,r,croppedI] = featim(image)

%Helpful function
paren = @(x, varargin) x(varargin{:});

%Image read and pre process
%I = imread(image);
I = image;
xsize = paren(size(I),1);
I = I((xsize-xsize/6):xsize,:,:);
croppedI = I;
I = rgb2gray(I);



%Feature detection
[mserRegions2, mserConnComp2] = detectMSERFeatures(I);

mserStats2 = regionprops(mserConnComp2, 'BoundingBox', 'Eccentricity', 'Solidity', 'Extent', 'Euler', 'Image','Perimeter','ConvexArea','FilledArea','Orientation');

bbox = vertcat(mserStats2.BoundingBox);
w2 = bbox(:,3);
h2 = bbox(:,4);
aspectRatio2 = w2./h2;
 
% Tunning to find numbers
filterIdx2 = aspectRatio2' < 1;
%filterIdx = filterIdx & [mserStats.Eccentricity] < .7 ;
filterIdx2 = filterIdx2 & [mserStats2.Solidity] < .7 & [mserStats2.Solidity] > .6;
%filterIdx2 = filterIdx2 & [mserStats2.Extent] < 0.62;
%filterIdx2 = filterIdx2 & [mserStats2.EulerNumber] == 1;
filterIdx2 = filterIdx2 & [mserStats2.ConvexArea] < 2000 & [mserStats2.ConvexArea] > 800;
filterIdx2 = filterIdx2 & [mserStats2.Perimeter] > 120 & [mserStats2.Perimeter] < 400;

%TUnnings to find the number 1
filterIdx = aspectRatio2' < 1;
filterIdx = filterIdx & [mserStats2.Eccentricity] > .85 ;
filterIdx = filterIdx & [mserStats2.Solidity] < .85 & [mserStats2.Solidity] > .6;
filterIdx = filterIdx & [mserStats2.Extent] < 0.62;
%filterIdx2 = filterIdx2 & [mserStats2.EulerNumber] == 1;
filterIdx = filterIdx & [mserStats2.ConvexArea] < 2000 & [mserStats2.ConvexArea] > 800;
filterIdx = filterIdx & [mserStats2.Perimeter] > 120 & [mserStats2.Perimeter] < 400;

%duplicate because
dup = mserStats2;
dup2 = mserRegions2;

mserStats2(~filterIdx2) = [];
mserRegions2(~filterIdx2) = [];

rows = size(mserStats2,1);

dup(~filterIdx) = [];
dup2(~filterIdx) = [];

%Final numbers matrix

if size(dup,1) == 0
	x = mserStats2;
	r = mserRegions2;
else
	for i=1:size(dup,1)
		mserStats2(rows + i) = dup(i);
		mserRegions2(rows + i,1) = dup2(i); %RECENTLY MADE CHANGE REVIEW REVIEW 01/05
	end
	x = mserStats2;
	r = mserRegions2;

end


end
