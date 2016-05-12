function cleanPercents = cleanPercents(percentage)

	%percents clean function

	indices = strfind(percentage,'nada');
	indices2 = find(not(cellfun('isempty', indices)));
	percentage(indices2,1) = {'.'};


	c = cellfun(@(x)numel(x), percentage);
	percentage(c>3) = {'.'};

	cleanPercents = percentage;

	
end
