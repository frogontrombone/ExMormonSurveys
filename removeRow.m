function [outData] = removeRow(inData,columnToFilter,responseToRemove)
outData = inData(~ismember( [inData{:,columnToFilter}] ,responseToRemove),:);
end
    