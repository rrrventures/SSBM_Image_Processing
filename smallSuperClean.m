function superCleandf = smallSuperClean(cleanPercents)
	%Yet another cleaning function
	%Remove high jumps in close frames
	%MERGE THIS FUNCTION WITH THE ORIGINAL CLEANPERCENTS TO MAKE IT LESS OF A CLUSTER F

	prueba = cellfun(@(x)str2num(x),cleanPercents,'UniformOutput',false);

	%Remove big wrong numbers
	%This is honestly not the best, since someone could reach over 400 percents
	%Not too likely though
	for i=1:size(prueba,1)
		if prueba{i}>= 400;
			prueba(i)={[]};
		end
	end


	%Remove high jumps in percent change
	for i=2:size(prueba,1)
		if prueba{i}-prueba{i-1}>=50
			prueba(i)={[]};
		end
	end

	AAA = ~cellfun(@(x)isempty(x),prueba);
	indices = find(AAA);

	prueba(~AAA)={'.'};

	superCleandf = cellfun(@(x)num2str(x),prueba,'UniformOutput',false);

end
