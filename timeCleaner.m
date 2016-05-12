function cleanTime = timeCleaner(time)
	%function to clean the stage time cell

	kk = time ;

	kk(kk>800)=1;

	aer=kk ~=1;

	[index, nada] = find(kk ~=1);

	lastCounter = 0;

	
	for i=1:(size(index,1)-2)
		
		if lastCounter ~= 0
			lastCounter = lastCounter - 1;
			continue
		end

		j = index(i);
		n = index(i+1);

		if abs(kk(j) - kk(n)) > 50  & kk(n) ~= 800
			kk(n)= 1;
			aux= i+2;
			o = index(aux);
			lastCounter = 1;

			while abs(kk(j)-kk(o)) > 50 & kk(o) ~= 800
				kk(o)=1;
				aux =aux+1;
				o = index(aux);
				lastCounter = lastCounter + 1;
			end
		end
	end
	
		
	

	cleanTime = kk;

end