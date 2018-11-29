function [outColumn] = LikertConvert(inColumn,inResponses)
%This function brings a column in and converts it to a column of numbers.

%inResponses needs to be formatted from lowest value to highest value.
%This function will assign a number from 0 to the number of values.

%This function should only be used for ordinal variables, such as a Likert
%scale.

numResponses = length(inResponses);

%create the correctly sized output
outColumn = zeros(size(inColumn,1),1);

evaluated = 0;

% cycle through rows
for rowID = 1:size(inColumn,1)
    tempString = string(inColumn{rowID});
        % check to see if response is given
        for responseID = 1:length(inResponses)
            %if the cell includes a response that matches the column, then
            %give it its number in the ordinal list.  Zeros are default.
            if strcmp(inResponses{responseID},tempString)
                outColumn(rowID) = responseID - 1;
                evaluated = 1;
            end
            if evaluated == 1
                evaluated = 0;
                break
            end
        end
    
end

end

