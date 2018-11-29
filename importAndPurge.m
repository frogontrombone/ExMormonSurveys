function [outMotivesSurvey] = importAndPurge()
%the purpose of this function is to simplify the main code. Edits to what
%should be removed should happen here. Columns are hardcoded here and must
%be edited if the survey changes at all in future iterations

importedMotivesSurvey = importfile('MotivesSurvey.csv');
%cut out unneeded rows and columns from the survey data, due to the way Qualtrics structures the files
importedMotivesSurvey(:,1)=[]; %remove column, user language
importedMotivesSurvey(3,:)=[]; %remove row, question ID
importedMotivesSurvey(1,:)=[]; %remove row, question #

%Filter out certain participants
tempMotivesSurvey = removeRow(importedMotivesSurvey,1,"No");%remove participants who do not consent to the study
tempMotivesSurvey = keepRow(tempMotivesSurvey,8,"The Church of Jesus Christ of Latter Day Saints (CoJCoLDS), Brighamite - Salt Lake City"); %keep only participants who are LDS-SLC
outMotivesSurvey = removeRow(tempMotivesSurvey,48,""); %remove missing data (most are incomplete responses)
%the keepRow function will also remove headers
end
