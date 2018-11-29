function [ outTable ] = dataFilter2( inTable, inColumn, inArguments )
%Tell the function what argument you don't want from a particular column.
%Use columns from the original worksheet, not the scrubbed tables

%inArguments should be in the form of an array: e.g. [1 2]

%Exclude rows that are should be filtered
%Syntax literally says, use all the rows and columns (:) in inCellArray, but
%exclude (~ismember) those rows that have data matching the filter value
outTable = inTable(~ismember( inTable(:,inColumn) ,inArguments),:);

end

