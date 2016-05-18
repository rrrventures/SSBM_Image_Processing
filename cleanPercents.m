function cleanPercents = cleanPercents(percentage)

	%Percents clean function

	%Just remove when it finds "nothing" (nada)
	indices = strfind(percentage,'nada');
	indices2 = find(not(cellfun('isempty', indices)));
	percentage(indices2,1) = {'.'};

	%If there are cells with more than 3 numbers, remove
	%Since max percent is 999
	c = cellfun(@(x)numel(x), percentage);
	percentage(c>3) = {'.'};

	cleanPercents = percentage;

	
end
