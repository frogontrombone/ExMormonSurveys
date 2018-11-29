close all

%Should the program use the pre-calculated geography data instead of
%clustering all the data from scratch? %1 = yes, 0 = no
useCalculatedGeography = 1;
%If clustering again, should the program use the pre-calculated seeds for 
%the clustering algorithm that decides which geographic region everyone 
%belongs to? 1 = yes, 0 = no
useGeographySeeds = 1; 

%IMPORT DATA into a cell array, using Matlab-generated function
if ~exist('MotivesSurvey', 'var')
    MotivesSurvey = importAndPurge();
end

%Figure out where everyone is from
if useCalculatedGeography == 1 
    load('calculatedGeography.mat'); %use the pre-calculated values
else
    [tempGeographyCluster,tempGeographyClusterArray] = runGeographyClustering(MotivesSurvey,useGeographySeeds); %calculate the clusters again
    save('calculatedGeography.mat','tempGeographyCluster') %save the result
end

%FORMAT DATA
if ~exist('WorkingCellArray', 'var')
    [WorkingTable,WorkingCellArray,WorkingCategoricalCellArray] = formatData(MotivesSurvey,tempGeographyCluster);
end
   

%STATISTICS
%Percent who self-reported as divorcing and who were married at the
%beginning of the faith transition
divorcesSinceTransition = sum(WorkingTable(:,30))/(size(WorkingTable,1)-sum(WorkingTable(:,10))-sum(sum(WorkingTable(:,14:15))));
%The following analyses are commented out because they show the more or less the same rate of divorce regardless of temple sealing or high activity
%Percent who self-reported as divorcing among those who had been sealed in the temple
%divorcesSealedInTemple = sum(and(WorkingTable(:,32),WorkingTable(:,55)))/sum(WorkingTable(:,55));
%Percent who self-reported as divorcing among those who had been sealed in the temple
divorcesHighActivity = sum(and(WorkingTable(:,32),or(WorkingTable(:,71),WorkingTable(:,72))))/sum(and(or(or(WorkingTable(:,13),WorkingTable(:,14)),WorkingTable(:,15)),or(WorkingTable(:,71),WorkingTable(:,72))));
divorcesMediumActivity = sum(and(WorkingTable(:,32),or(WorkingTable(:,69),WorkingTable(:,70))))/sum(and(or(or(WorkingTable(:,13),WorkingTable(:,14)),WorkingTable(:,15)),or(WorkingTable(:,69),WorkingTable(:,70))));
divorcesLowActivity = sum(and(WorkingTable(:,32),or(or(WorkingTable(:,66),WorkingTable(:,67)),WorkingTable(:,68))))/sum(and(or(or(WorkingTable(:,13),WorkingTable(:,14)),WorkingTable(:,15)),or(or(WorkingTable(:,66),WorkingTable(:,67)),WorkingTable(:,68))));

whyLeft = WorkingCategoricalCellArray(:,11);
%Dependent variables
%[gender' orientation' priorMaritalStatus' mission' temple' sealed' ...
%typicalActivity' maxActivity' sexualMisconduct maxCalling(48) strongestBeliefs(107:132) weakestBeliefs(133:158) belovedPractices(159:182) hatedPractices(183:206)] 
%categorical(WorkingTable(:,107:206))
%WorkingTable(:,107:206)
%[male,female,trans,hetero,bi,homo,asex,single,married,XXpolyXX,separated,divorced,widowed]
%[bornIn,bornMixedFaith,convert,familyjoined,other] [max calling,mission]
X = [WorkingTable(:,5:13) WorkingTable(:,15:17) WorkingTable(:,42:44) WorkingTable(:,46) WorkingTable(:,48:49)];

[B,dev,stats] = mnrfit(X,whyLeft);

[B,dev,stats] = mnrfit([WorkingTable(:,46) WorkingTable(:,48)],whyLeft);

%Age versus reason for leaving
disp('Do different age groups have different reasons for leaving?');
[tbl1,Labels1,~,~,~,~,~,AdjR1] = chi2test(WorkingTable,MotivesSurvey,389,48);

%Activity versus reason for leaving
disp('Do different levels of activity have different reasons for leaving?');
[tbl2,Labels2,~,~,~,~,~,AdjR2] = chi2test(MotivesSurvey,MotivesSurvey,27,48);

%Gender versus reason for leaving
disp('Do different genders have different reasons for leaving?');
[tbl3,Labels3,~,~,~,~,~,AdjR3] = chi2test(MotivesSurvey,MotivesSurvey,4,48);

%Orientation versus reason for leaving
disp('Do people with different sexual orientations have different reasons for leaving?');
[tbl4,Labels4,~,~,~,~,~,AdjR4] = chi2test(MotivesSurvey,MotivesSurvey,5,48);

%Geography versus reason for leaving
disp('Do people from different areas have different reasons for leaving?');
[tbl5,Labels5,~,~,~,~,~,AdjR5] = chi2test(tempGeographyClusterArray,MotivesSurvey,1,48);

%Put this in a format that we can read easily.
DisplayTable = [{''} {Labels5{1:14,2}}; {Labels5{:,1}}' num2cell(AdjR5)];
disp(DisplayTable);

%What people liked, by activity
disp('Do different levels of activity lead to different apsects of the church viewed positively when TBM?');
[tbl6,Labels6,~,~,~,~,~,AdjR6] = chi2test(MotivesSurvey,MotivesSurvey,28,51);
