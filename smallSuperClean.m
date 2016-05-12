function superCleandf = smallSuperClean(cleanPercents)
%idea para limpiar mas la base de datos
%remove high jumps in close frames

prueba = cellfun(@(x)str2num(x),cleanPercents,'UniformOutput',false);

%remove big wrong numbers
for i=1:size(prueba,1)
	if prueba{i}>= 400;
		prueba(i)={[]};
	end
end


%remove high jumps in percent change
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
