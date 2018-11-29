function [ OrdinalChoicesArray,OrdinalColumnToAnalyze,outQuestions] = ArrangeOrdinalData( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%% This section is for ordinal data %%%%%%%%%%%

%It is important that the choices listed in these variables are ranked from
%lowest value to highest value.  The first cell in each array will be given
%the value of '0', and the values will increase by one for each option in
%the cell array.

%This is so you don't have to manually write the index for the column to
%analyze.  This is important in case you switch the order of the questions
%below.
j = 1;

%Set up the columns array.  This is used to pick out the right columns from
%the spreadsheet.
OrdinalColumnToAnalyze = zeros(5,1);

OrdinalColumnToAnalyze(j) = 3; j = j+1; %the column from the spreadsheet
Age = {'18','18-24','25-35','36-45','46-55','56-65','66'}; %in a future iteration, just ask for age directly

OrdinalColumnToAnalyze(j) = 47; j = j+1; %the column from the spreadsheet
TransitionLength = {'I have not started a faith transition OR I have never believed in the church', '0-1 months', ...
    '2-9 months', '10 months to 2 years', '3 years to 10 years', 'More than 10 years'};

OrdinalColumnToAnalyze(j) = 72; j = j+1; %the column from the spreadsheet
FeelingsOnChurch = {'I think it is great and is a net positive in the world. I find truth in it, despite not finding its entire narrative to be true.', ...
    'I do not care about the church. It is so insignificant in the grand scheme of things that I don''t think much about what it is doing or if it is good or bad.', ...
    'There are good parts and bad parts, and I can''t say if the whole is good or bad', ...
    'My feelings shift between neutral and negative', ...
    'I think it is net negative in the world. I respect that others can find truth in it, but I think it does more harm than good.', ...
    'The church embodies evil. It is a truly terrible organization and should be opposed.', 'Other (Please write it in)'};

OrdinalColumnToAnalyze(j) = 82; j = j+1; %the column from the spreadsheet
SinFrequencyChurchDef = {'I sin far less than before', 'I sin less than before', 'I sin about as often as before', ...
    'I sin more than before', 'I sin much more than before'};

OrdinalColumnToAnalyze(j) = 83; j = j+1; %the column from the spreadsheet
SinFrequencyPersonalDef = {'I sin far less than before', 'I sin less than before', 'I sin about as often as before', ...
    'I sin more than before', 'I sin much more than before'};

%This is a cell array containing all the options from the survey.
OrdinalChoicesArray = {Age,TransitionLength,FeelingsOnChurch,SinFrequencyChurchDef,SinFrequencyPersonalDef};
outQuestions = {'Age','TransitionLength','FeelingsOnChurch','SinFrequencyChurchDef','SinFrequencyPersonalDef'};

end

