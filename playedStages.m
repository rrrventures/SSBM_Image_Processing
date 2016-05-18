function playedStages = playedStages(startsAt,stage)

	%Function to find what stage was played
	playedStages = cell(size(startsAt,1),1);

	%This goes to the beggining of a stage, and checks what is the most repeated predicted stage in the next frames
	for i=1:size(startsAt,1)
		arr = stage(startsAt(i):(startsAt(i)+10));

		[unique_strings, ~, string_map]=unique(arr);
		most_common_string=unique_strings(mode(string_map));
		playedStages(i) = {most_common_string};
	end
	

end

