function deathPercent=deathPercentClean(pDeathNEW,pzeros,startsAt)
	%Function to clean the deathPercent cell to make sure it is formated correctly
	
	for i=1:size(startsAt,1)
		ind = abs(pzeros - startsAt(i))<20;
		pDeathNEW(ind)={[]};
	end


	deathPercent = pDeathNEW;

end
