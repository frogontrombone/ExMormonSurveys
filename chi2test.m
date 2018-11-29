function [ outTable, outTableLabels, outChi2, outChi2Contribution, ...
    outp, outExpectedCount, outChiRawResiduals, outChiAdjResiduals,outCramersV ] ...
    = chi2test( inDataset1, inDataset2, inVar1Column, inVar2Column )
%this function extends the chi^2 test provided by Matlab.  It calculates
%residual tables and other tables that help the user decide which groups
%have the largest impact.  Interpretation of the results can be found at
%the following website: http://support.minitab.com/en-us/minitab-express/1/help-and-how-to/basic-statistics/tables/cross-tabulation-and-chi-square/interpret-the-results/all-statistics/#raw-residuals

%Formulas used can be found here: http://support.minitab.com/en-us/minitab-express/1/help-and-how-to/basic-statistics/tables/cross-tabulation-and-chi-square/methods-and-formulas/methods-and-formulas/

%                       *****IMPORTANT*****
%The chi^2 test is useful for categorical dependent variables.  The test is
%non-parametric, meaning your data does not need to fit a specific 
%distribution (most tests require fit to normal).  If you are not familiar
%with this test, please check the above websites for learning how to
%interpret the results.

%This code also assumes that if you are entering a cell array, you have two
%rows of headers.

%Check the data type and adjust accordingly.  Different syntax is required
%for cell arrays and matrices.
if iscell(inDataset1)
    var1 = [inDataset1{3:end,inVar1Column}];
else
    var1 = inDataset1(:,inVar1Column);
end
if iscell(inDataset2)
    var2 = [inDataset2{3:end,inVar2Column}];
else
    var2 = inDataset2(:,inVar2Column);
end

%Figure out how many unique variables are in each dataset.
var1Categories = unique(var1);
var2Categories = unique(var2);
sizeVar1 = length(var1Categories);
sizeVar2 = length(var2Categories);

%Chi-squared analysis.  A high outChi2 means there are differences between
%groups.
[outTable,outChi2,outp,outTableLabels] = crosstab(var1,var2);

%Find expected counts for each entry.  Null hypothesis is that residual
%is approximately zero.
%First, get row, column, and total sums.
tblRowSums=sum(outTable,2);
tblColumnSums = sum(outTable,1);
TotalCount = sum(sum(outTable));

%prepare the four tables of statistics
outExpectedCount = zeros(sizeVar1,sizeVar2);
outChiRawResiduals = zeros(sizeVar1,sizeVar2);
outChiAdjResiduals = zeros(sizeVar1,sizeVar2);
outChi2Contribution = zeros(sizeVar1,sizeVar2);

%calculate the tables.  There may be a way to do this with matrix math, but
%I have not taken the time to figure that out yet.
for i=1:sizeVar1
    for j=1:sizeVar2
        %Raw shows how much the counts deviate from each other
        %Adjusted accounts for variation due to sample size
        %Contribution is how much each group contributes to the total chi^2
        %statistic.
        outExpectedCount(i,j) = tblRowSums(i)*tblColumnSums(j) / TotalCount;
        outChiRawResiduals(i,j) = (outTable(i,j) - outExpectedCount(i,j));
        outChiAdjResiduals(i,j) = outChiRawResiduals(i,j) / sqrt(sum(outTable(i,:)) * sum(outTable(:,j)) * (1-sum(outTable(i,:)/sum(sum(outTable))))/ sum(sum(outTable)) * (1-sum(outTable(:,j)/sum(sum(outTable))))/ sum(sum(outTable)));
        outChi2Contribution(i,j) = outChiRawResiduals(i,j)^2 / outExpectedCount(i,j);
    end
end

%Cramer's V is an effect size statistic that can be interpreted similarly
%to a correlation coefficient.  For more detail: http://www.real-statistics.com/chi-square-and-f-distributions/effect-size-chi-square/
outCramersV = sqrt(outChi2/(sum(sum(outTable))*min(sizeVar1-1,sizeVar2-2)));

%Print out some interpretations for the user
%Set threshholds for effect size.  These thresholds are approximate, not
%absolute.
interpThreshSmall = 0.1 - min(sizeVar1-1,sizeVar2-2)*0.01 - 0.01;
interpThreshMed = interpThreshSmall * 3;
interpThreshLg = interpThreshSmall * 5;
%is the test statistically significant?
if outp < 0.05
    disp('Yes');
else
    disp('No');
end
disp('p value');
disp(outp);
disp('Cramers V (effect size)')
disp(outCramersV);
%What size is the effect?
if outCramersV > interpThreshLg
    disp('large effect');
elseif outCramersV > interpThreshMed
    disp('medium effect');
elseif outCramersV > interpThreshSmall
    disp('small effect');
else
    disp('negligible effect');
end

%This plots adjusted residuals for each group
%c = categorical({'History','Social Justice','Doctrine','Historicity of Scripture','Weak Testimony','Other','Doctrinal Shift','Offended','Epistimology','Lack of Leadership','Spiritual Experience','Desire to sin','Lazy'});
%barh(outChiRawResiduals');
%graph = outCrossTabTbl ./ tblRowSums;
%barh(graph,'stacked');

end

