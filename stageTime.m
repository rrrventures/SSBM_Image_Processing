function stageTime = stageTime(stageStarts,cleanTime)

	%Function to calculate the amount of time each stage lasted

	kk = cleanTime;
	start= stageStarts;
	stageTime=zeros(size(start,1),1);

	for i=2:size(start,1)
		prueba = find(flip(kk((start(i)-300):(start(i)-1))) > 10,1);
		ind = start(i)-prueba;
		stageTime(i-1) = 800-kk(ind);
	end


	i=size(start,1);
	prueba = find(flip(kk((end-700):end)>10),1);
	ind = size(kk,1) - prueba;
	stageTime(i) = 800-kk(ind);

end