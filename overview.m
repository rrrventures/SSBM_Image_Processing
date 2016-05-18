function [theWinner,nameP1,nameP2,wonStagesP1,wonStagesP2] = overview(fileName,whoWon)

	%Function to get the overview data
	%Gets characters played from file name
	a = fileName;
	asd=regexp(a,'\([A-z]+\)','match');

	%Gets rid of the parenthesis
	asd=cellfun(@(x) x(2:(end - 1)),asd,'UniformOutput',false);


	%Get round that is being played
	%Specific tuning for Battle of the five gods
	dominic = strsplit(a,' ');
	round = dominic(1);

	%Get the players names
	empty = regexp(a,' ');
	parenthesis =  regexp(a,'\(');
	vs = regexp(a,'vs\.');

	nameP1 = a((empty(1)+1):(parenthesis(1)-2));
	nameP2 = a((vs+4):(parenthesis(2)-2));

	wonStagesP1 = sum(strcmp(whoWon,'Player 1'));
	wonStagesP2 = sum(strcmp(whoWon,'Player 2'));

	if wonStagesP1 > wonStagesP2
		theWinner = nameP1;
	else
		theWinner = nameP2;
	end

end

