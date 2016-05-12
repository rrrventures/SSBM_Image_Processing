function [whoWon,deathPercent] = whoWon(stageStarts,cleanTime,p1Percents,p2Percents)


	start = stageStarts;
	p1SuperCleanSmall = p1Percents;
	p2SuperCleanSmall = p2Percents;
	kk = cleanTime;

	%function to figure out who won in each stage and maybe check the death percent loser


	whoWon = cell(size(start,1),1);
	deathPercent = zeros(size(start,1),1);

	for i=2:size(start,1)
		prueba = find(flip(kk((start(i)-300):(start(i)-1))) > 10,1);
	    ind = start(i)-prueba;

	    paraTesteo1 = p1SuperCleanSmall((ind-15):(ind+10));
	    paraTesteo2 = p2SuperCleanSmall((ind-15):(ind+10));

	    aux1 = cell2mat(cellfun(@(x)str2num(x),paraTesteo1,'UniformOutput',false));
	    aux2 = cell2mat(cellfun(@(x)str2num(x),paraTesteo2,'UniformOutput',false));


	    l1 = ~logical(strcmp('.',paraTesteo1));
	    l2 = ~logical(strcmp('.',paraTesteo2));



	    if sum(l1) > sum(l2)
	    	whoWon(i-1,1) = {'Player 1'};
	    	deathPercent(i-1,1) = max(aux2);
	    else
	    	whoWon(i-1,1) = {'Player 2'};
	    	deathPercent(i-1,1) = max(aux1);
	    end

	end

	%warning, probably will fail if goes to time limit

	prueba = find(flip(kk((end-800):end)>10),1);
	ind = size(kk,1) - prueba;
	paraTesteo1 =  p1SuperCleanSmall((ind-10):(ind+10));
	paraTesteo2 = p2SuperCleanSmall((ind-10):(ind+10));
	
	aux1 = cell2mat(cellfun(@(x)str2double(x),paraTesteo1,'UniformOutput',false));
	aux2 = cell2mat(cellfun(@(x)str2double(x),paraTesteo2,'UniformOutput',false));


	l1 = ~logical(strcmp('.',paraTesteo1));
	l2 = ~logical(strcmp('.',paraTesteo2));

	if sum(l1) > sum(l2)
		whoWon(size(start,1),1) = {'Player 1'};
		deathPercent(size(start,1),1) = max(aux2);
	else
		whoWon(size(start,1),1) = {'Player 2'};
		deathPercent(size(start,1),1) = max(aux1);
	end

end