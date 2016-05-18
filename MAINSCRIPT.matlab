clc
close all
clear all

%Function i use a few times
paren = @(x, varargin) x(varargin{:});


%Initiating cells, loading model for later predictions
%The detector one is not used for now
detector = vision.CascadeObjectDetector('meleeDetector.xml');

%Particular example for this video. Later I will just loop through the tournament vids.
source='WS Armada (Peach) vs. Plup (Sheik).mp4';
vidobj=VideoReader(source);
frames=vidobj.Numberofframes;
time = zeros(round(frames/10),1);
stocks = zeros(round(frames/10),1);
p1 = cell(round(frames/10),1);
p1(:,:)= {'.'};
p2 = cell(round(frames/10),1);
p2(:,:)= {'.'};
stage=cell(round(frames/10),1);

%useful value to find near area of percents boundingbox later on
everyoneDead = 1;
p1Location = 0;
p2Location = 0;


%Looping through video frames to process and find the info I'm looking for: percents, time and stages.

t = cputime;
for f=10:10:frames
  readframei =cputime;
  thisframe=read(vidobj,f);
  readframetime = cputime - readframei;
  try
  	%boxti = cputime; 
  	%bbox = step(detector,thisframe); %stock count not really necesary for now, trying to find winner of map differently
  	%bboxtime = cputime - boxti;

  	%stockti = cputime;
	%stocks(f/10) = paren(size(bbox),1);
	%stocktime = cputime - stockti;

	%this part where i save and load the frame as a jpg. It is useful because of how i trained the model with jpgs
	%it doesnt work as well if I just use the frame. Different format messes with it I guess
	%I also added some redundant time measuring things but they're not too important for now
	kki = cputime;
	thisfile=sprintf('C:/py/frames/frame_%010d.jpg',f);
    imwrite(thisframe,thisfile);
    loadedImage = imread(thisfile);
    kktime = cputime - kki;

    %Here I find the percents of each player on that frame
    %Called percentsTest because it was a new version of the function.
    percenti = cputime;
	[p1(f/10,1),p2(f/10,1)] = percentsTest(loadedImage,p1Location,p2Location);
	delete(thisfile);
	percentime = cputime - percenti;

	%Model to find what stage they where playing. Probably an overkill to calculate it each frame but I'll keep
	%it this way for now
	%Using the frame and not the loaded image works fine
	stagei = cputime;
	stage(f/10) = whatstage(thisframe);
	stagetime=cputime - stagei;

	%It finds the stage time of frame
	timei = cputime;
	time(f/10) = proc(thisframe);
	timetime= cputime - timei;

	
  catch
  	%Oldish fix. Should  just initiate the cell with ones
  	time(f/10) = 1;
  end
  
  %Small bit to find the location of the player to make it easier to crop
  %and find the percents of each player after the match beggins
  if everyoneDead
  	if isequal(p2(f/10),{'0'}) & isequal(p1(f/10),{'0'})
  		[p1Location, p2Location] = location(loadedImage);
  		everyoneDead = 0;
  	end
  end


end
e = cputime-t



%From here on its just cleaning and formatting of stuff. All the relevant info is in the cells
%from the previous section p1, p2, time and stage.

%Some cleaning functions to remove obvious errors from the percentages cell
p2PercentsClean = cleanPercents(p2);
p1PercentsClean = cleanPercents(p1);

p2SuperCleanSmall = smallSuperClean(p2PercentsClean);
p1SuperCleanSmall = smallSuperClean(p1PercentsClean);


%Find where the 0% are, to know each point where a new stock started
%it works well so I haven't had to use the clean version of the percents for this
%Actual finding of relevant 0% is not straight forward so this function is kind of funky
p1zeros = findzerosx(p1);
p2zeros = findzerosx(p2);


%Getting the appropiate death percents and other calculations
%The way the function works, it doesn't find the death percents
%at the end of the stage. But I fix that a few lines down
p1DeathNEW = deathPercentsMax(p1SuperCleanSmall,p1zeros);
p2DeathNEW = deathPercentsMax(p2SuperCleanSmall,p2zeros);

%Cleaning the stage time data from obvious errors
cleanTime = timeCleaner(time);

%Calculation, total stages played and frame where each stage starts
[nStages,startsAt]=numberStages(cleanTime);

%What stages were played
% playedStages = stage(startsAt); lazy way, prone to errors
%likelyer way to get it right
playedStages = playedStages(startsAt,stage);


%Stage duration calculation
stageDuration = stageTime(startsAt,cleanTime);

%Figure out who won each stage and the death percent of the losers' last stock 
[whoWon,lastDeathPercent] =whoWon(startsAt,cleanTime,p1SuperCleanSmall,p2SuperCleanSmall);

%Clean the death cell percent to make sure I can later properly split it by stage
p2DeathClean = deathPercentClean(p2DeathNEW,p2zeros,startsAt);
p1DeathClean = deathPercentClean(p1DeathNEW,p1zeros,startsAt);

%The death percent cell for each player, separated by stage
p1DeathCell=deathCell(p1DeathClean);
p2DeathCell=deathCell(p2DeathClean);

%The final touch is adding the death percent for the loser of the last stock in each stage.
finalDeathCellp2=finalDeathCellp2(p2DeathCell,whoWon,lastDeathPercent);
finalDeathCellp1=finalDeathCellp1(p1DeathCell,whoWon,lastDeathPercent);


%Inicial main struct for the overview of the match. Winner, names and score
%This applies to a particular example. Will adapt it when I run the script looping through 
%different videos
files = dir('videos');
a=files(3).name ;
matchId=1;

%Function to get names of players and winner
[theWinner,nameP1,nameP2,wonStagesP1,wonStagesP2] = overview(a,whoWon);

%Build overview struct with players names, winner, stages won
matchOverview = struct('match_id',matchId,'Player1',nameP1,'Player2',nameP2,'Winner',theWinner,'Won_Stages_P1',wonStagesP1,'Won_Stages_P2',wonStagesP2);

%Final Struct with all the relevant deatiled info. Death percents, duration, stages, etc
matchDetails = struct('Match_Id',matchId,'Stage_Order', num2cell(1:size(playedStages,1))', 'Stages',playedStages,'Winner',whoWon,'P1_Percents',finalDeathCellp1,'P2_Percents',finalDeathCellp2,'Stage_Duration',num2cell(stageDuration));

