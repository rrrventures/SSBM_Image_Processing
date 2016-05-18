function fzeros = findzerosx(percentages)
	%Warning: Terrible variable names ahead

	%Find where all the zeros are
	dominic = strcmp(percentages,'0');

	%Expand a bit for easier handling
	dominic = [zeros(5,1) ; dominic];
	comparito = [zeros(5,1); 1 ; zeros(5,1)];
	dominicXL = zeros(size(dominic,1),1);

	%Make a sort of distribution thingy to make finding the actual relevant zeros easier
	%If it is not clear why this is necesary at all, plot dominic. It is very evident that 
	%the small errors make it difficult to find the relevant info.
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
