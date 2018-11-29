function [outData] = keepRow(inData,columnToFilter,responseToKeep)
outData = inData(ismember( [inData{:,columnToFilter}] ,responseToKeep),:);
end
    