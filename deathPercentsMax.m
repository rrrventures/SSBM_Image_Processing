function deathPercents = deathPercentsMax(percentage,loszeros)

	%From here actual deathpercent findings
	sizeZeros=size(loszeros,1);
	deathPercents=cell(sizeZeros,1);
	percentage = [{'.'} ; percentage];

	%Idea with max number
	%The idea is to start from a 0% (fresh stock) and then look back some frames
	%After that, the max number should be the percent when he lost the stock
	for i=1:sizeZeros
		elpunto=loszeros(i)+1;
		prueba = flip(percentage((elpunto-10):(elpunto-1)));
		prueba2 = find(~strcmp(prueba,'.'));

		b = cellfun(@(x)str2double(x), prueba(prueba2));
		deathPercents{i} = max(b);
	end

end