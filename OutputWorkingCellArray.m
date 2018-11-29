function [ outWorkingCellArray ] = OutputWorkingCellArray( inCategoricalChoicesArray, inWorkingTable )

%Tagging the columns, for workability
outWorkingCellArray = [inCategoricalChoicesArray{:,:},'Age','TransitionLength',...
    'FeelingsOnChurch','SinFrequencyChurchDef','SinFrequencyPersonalDef'; ...
    num2cell(inWorkingTable)];

 fid = fopen('test.txt', 'w','delimiter','\t') ;
 fprintf(fid, '%s,', outWorkingCellArray{1,1:end-1}) ;
 fprintf(fid, '%s\n', outWorkingCellArray{1,end}) ;
 fclose(fid) ;

 dlmwrite('test.txt', outWorkingCellArray(2:end,:), '-append') ;

end

