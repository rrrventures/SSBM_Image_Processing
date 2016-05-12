function [nStages,startsAt] = numberStages(timeDb)

%Use the time data frame to find how many stage were played and which frames are the start
%make a sort of distribution thingy to make finding the actual relevant zeros easier to find
	
kk = timeDb ==800;
kk(kk>800)=1;
dominic = kk;

%expand a bit 
dominic = [zeros(5,1) ; dominic];
dominicXL = zeros(size(dominic,1),1);


for i=6:(size(dominic)-6)
		
	dominicXL(i) = sum(dominic((i-5):(i+5)));
		
end

compare = [0 ; 1];
dominicDEFINITIVO = zeros(size(dominicXL,1),1);
for i=1:(size(dominicXL)-3)
	if isequal(dominicXL(i:(i+1)),compare)
		dominicDEFINITIVO(i+1) = 1;
	end
end

startsAt  = find(dominicDEFINITIVO);
nStages = size(startsAt,1);

end


