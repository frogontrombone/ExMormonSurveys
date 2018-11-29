function [outColumns] = ExpandMultipleChoice(inColumn,inResponses, inMultiple)
%This function brings a column and the creates a bunch of 1/0 columns based
%on the number of responses.

%Example, gender may be male, female, transgender.  Bringing this in
%creates three columns, one for each response.  One means the condition is 
% met.  Zero means not met.  E.g. A one in the 'male' column
%corresponds with a row that reponded "male".

%This function should only be used for categorical variables, such as
%apples and oranges, not ordinal variables, such as Age, or a Likert scale.

numResponses = length(inResponses);

%create the correctly sized output
outColumns = zeros(size(inColumn,1),numResponses);

% cycle through rows
for rowID = 1:size(inColumn,1)
    tempString = string(inColumn{rowID});
    %determine if we want to separate the responses by commas.  True for
    %multiple select questions, false for single select questions
    if inMultiple
        actualResponses = strsplit(tempString, ',');
    else
        actualResponses = tempString;
    end
    % cycle through columns
    for responseID = 1:numResponses
        % check to see if response is given
        for actualID = 1:length(actualResponses)
            %if the cell includes a response that matches the column, then
            %give it a 1.  Zeros are default.
            if strcmp(inResponses{responseID},actualResponses{actualID})
                outColumns(rowID,responseID) = 1;
            end
        end
    end
end

if length(inResponses) < 3
    outColumns = outColumns(:,1);
end

end

