function fzeros = findzerosx(percentages)

	%Find where all the zeros are
	dominic = strcmp(percentages,'0');
	dominic = [zeros(5,1) ; dominic];

	comparito = [zeros(5,1); 1 ; zeros(5,1)];
	dominicXL = zeros(size(dominic,1),1);

	%make a sort of distribution thingy to make finding the actual relevant zeros easier to find
	for i=6:(size(dominic)-6)
		
			dominicXL(i) = sum(dominic((i-5):(i+5)));
		
	end

	%Find the relevant zeros, i.e the begining of each stock

	compare = [0 ; 1];
	dominicDEFINITIVO = zeros(size(dominicXL,1),1);
	for i=1:(size(dominicXL)-3)
		if isequal(dominicXL(i:(i+1)),compare) && max(dominicXL((i+1):(i+13)))>2
			dominicDEFINITIVO(i+1) = 1;
		end
	end


	%Find the indices(frame) of the first relevant zero
	fzeros = find(dominicDEFINITIVO);
end
