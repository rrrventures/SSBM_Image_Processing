function deathCell = deathCell(deathPercents)

	%function to format the death percents
	%this will fail if someone gets a 4 stock
	%It just splits the original cell into a different cell where the numbers are separated by stage

	indx = find(cellfun('isempty',deathPercents)) ;
	asd = cell(size(indx,1),1);

	for i=1:size(indx,1)

		if i==size(indx,1)
			asd{i}=deathPercents((indx(i)+1):end);
		else
			asd{i}=deathPercents((indx(i)+1):(indx(i+1)-1));
		end

	end

	deathCell = asd;

end






