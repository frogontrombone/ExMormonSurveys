function [outWorkingCategoricalCellArray,outWorkingCategoricalHeaders] = categoricalData(inMotivesSurvey)
%this function also creates a table for analysis, but formats all data as
%categorical, where appropriate, rather than in dummy variables

gender = categorical([inMotivesSurvey{3:end,4}]);

orientation = categorical([inMotivesSurvey{3:end,5}]);

priorMaritalStatus = categorical([inMotivesSurvey{3:end,7}]);

currentMaritalStatus = categorical([inMotivesSurvey{3:end,6}]);

%howJoined = categorical([inMotivesSurvey{3:end,19}]);

mission = categorical([inMotivesSurvey{3:end,23}]);

temple = categorical([inMotivesSurvey{3:end,24}]);

sealed = categorical([inMotivesSurvey{3:end,26}]);

typicalActivity = categorical([inMotivesSurvey{3:end,27}]);

maxActivity = categorical([inMotivesSurvey{3:end,29}]);

sexualMisconduct = categorical([inMotivesSurvey{3:end,33}]);

PrimaryReasonForApostasy = categorical([inMotivesSurvey{3:end,48}]);

CurrentBelief = categorical([inMotivesSurvey{3:end,74}]);

FamilyReaction = categorical([inMotivesSurvey{3:end,78}]);

outWorkingCategoricalCellArray = [gender' orientation' priorMaritalStatus' ...
    currentMaritalStatus' mission' temple' sealed' ...
    typicalActivity' maxActivity' sexualMisconduct' PrimaryReasonForApostasy'...
    CurrentBelief' FamilyReaction'];

outWorkingCategoricalHeaders = ['gender' 'orientation' 'priorMaritalStatus' ...
    'currentMaritalStatus' 'mission' 'temple' 'sealed' ...
    'typicalActivity' 'maxActivity' 'sexualMisconduct' 'PrimaryReasonForApostasy'...
    'CurrentBelief' 'FamilyReaction'];