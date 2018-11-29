function [outWorkingTable,outWorkingCellArray,outWorkingCategoricalCellArray] = formatData(inMotivesSurvey,inGeographyCluster)
%This chunk of code manipulates the data to be better suited to logistic
%regression and similar methods.  It defines what the categorical variables
%are, then creates a new column for those variables.

%It is important to note that we retain both the MotivesSurvey (cell array)
%and the WorkingCellArray at the end of this, because the different formats
%are needed for different analyses.
outWorkingCategoricalCellArray = categoricalData(inMotivesSurvey);

%Gather all the categorical columns
%We have to use this extremly manual process instead of the unique()
%function because of the multiple-select questions.  The result of
%running the unique() function with multiple select is hundreds of
%unique combinations of the various selections.  The unique() method
%cannot parse out the parts.  Therefore we need to do it manually.  If
%you know a better method, let me know.

%This means the ArrangeCatagoricalAnalysis and ArrangeOrdinalData
%function will need to be manually updated if there are any changes to
%the survey.
[CatagoricalArray,Questions] = ArrangeCategoricalAnalysis(inMotivesSurvey);
%Gather all the ordinal variables
[OrdinalChoicesArray,OrdinalColumnToAnalyze,Questions2] = ArrangeOrdinalData( );

% Create the memory space.  There are no headers, so rows match inMotivesSurvey.
%+1 for geography cluster
WorkingTable = zeros(size(inMotivesSurvey,1),size([CategoricalChoicesArray{:,:}])+length(Questions2)+1);

%Now, let's add the ordinal parts to the whole thing.
for numQuestion = 1:length(OrdinalChoicesArray)
    WorkingTable(:,columnCnt) = ...
        LikertConvert(inMotivesSurvey(1:end,OrdinalColumnToAnalyze(numQuestion)),OrdinalChoicesArray{numQuestion});
    columnCnt = columnCnt+1;
end
    
%Tack on our geographic data from earlier
WorkingTable(:,end) = inGeographyCluster;

%create question headers for the responses
headers = {zeros(1,size(WorkingTable,2))+1};
columnCnt = 1;
for numQuestion=1:length(Questions) %since columns are expanded out as dummy variables, label each column appropriately
    for i=columnCnt:columnCnt+length(CategoricalChoicesArray{numQuestion})-1
        headers{i} = Questions{numQuestion};
    end
    columnCnt = columnCnt+length(CategoricalChoicesArray{numQuestion});
end
for numQuestion=1:length(Questions2) %ordinal variables are not dummy variable columns, just list the questions
    headers{columnCnt} = Questions2{numQuestion};
    columnCnt = columnCnt+1; %continue the column count from before so we don't overwrite things
end
headers{size(WorkingTable,2)} = 'Geography'; %tack on the last column, which was not an explicit question
headersAndOptions = [headers; [CategoricalChoicesArray{:,:}],Questions2,'GeographyCluster']; %combine headers and options into a 2xm matrix

%Flatten the callings columns to only represent the max calling ever held
MaxCalling = 8 - flattenCallings(WorkingTable); %calculate the highest calling ever held (larger is better)
  
%To flatten sexual orientation options, use heterosexual column (8) only
%To flatten sect, use LDS column (24) only
    
%exchange the expanded columns for flattened ones, remove 'no' column for
%binary responses
outWorkingTable = [WorkingTable(:,1),WorkingTable(:,3:48),MaxCalling, WorkingTable(:,66),WorkingTable(:,68:end)];
outWorkingCellArray = [headersAndOptions(:,1),headersAndOptions(:,3:48),{'MaxCalling';'MaxCalling'}, headersAndOptions(:,66), headersAndOptions(:,68:end);
                       num2cell(outWorkingTable)];
                   
%Write working table to file.  This code will throw an error if you do not
%already have a file of the same name in your working directory.
xlswrite('X.xlsx',outWorkingCellArray,'A1:OC4906');

end