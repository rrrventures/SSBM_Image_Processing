function deathPercents = deathPercentsMax(percentage,loszeros)

	%from here actual deathpercent findings
	sizeZeros=size(loszeros,1);
	deathPercents=cell(sizeZeros,1);
	percentage = [{'.'} ; percentage];

	%idea with max number
	for i=1:sizeZeros
		elpunto=loszeros(i)+1;
		prueba = flip(percentage((elpunto-10):(elpunto-1)));
		prueba2 = find(~strcmp(prueba,'.'));

		b = cellfun(@(x)str2double(x), prueba(prueba2));
		deathPercents{i} = max(b);
	end

end