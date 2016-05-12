function playedStages = playedStages(startsAt,stage)

	playedStages = cell(size(startsAt,1),1);

	for i=1:size(startsAt,1)
		arr = stage(startsAt(i):(startsAt(i)+10));

		[unique_strings, ~, string_map]=unique(arr);
		most_common_string=unique_strings(mode(string_map));
		playedStages(i) = {most_common_string};
	end
	

end

