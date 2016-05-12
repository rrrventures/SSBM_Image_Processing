function finalDeathCell = finalDeathCellp2(deathCell,whoWon,lastDeathPercent)

	indx=find(strcmp(whoWon,'Player 1'));

	for i=1:size(indx,1)
		deathCell{indx(i)}(end+1)={lastDeathPercent(indx(i))};
	end

	finalDeathCell =deathCell;
end
