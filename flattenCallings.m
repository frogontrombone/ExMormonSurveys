function outMaxCalling = flattenCallings(inData)

%Flatten callings into a single variable.  The variable represents the
%highest calling held by each individual at any point.  This metric is
%oversimplified and does not account for nuance between callings that are 
%roughly at the same level (e.g. how EQP is more authoritative than RSP)

%This section defines a hierarchical tree diagram based on LDS-SLC, and 
%scores a calling based on its distance from the root node (President of 
%the Church).  Roughly speaking, this is how many "phone calls" you would
%have to go through to talk directly to the President of the Church.

%I've defined it as follows:
% 
% "President of the Church" = 1 = 0
% "Quorum of the 12" = 1.1 = 1
% "Presidency of the Seventy" = 1.1.1 = 2
% "Seventy, General Authority" = 1.1.1.1 = 3
% "Area Authority" = 1.1.1.1.1 = 4
% "Temple Presidency" = 1.1.1.1.2 = 4
% "Mission Presidency" = 1.1.1.1.3 = 4
% "Stake Presidency" = 1.1.1.1.1.1 = 5
% "Stake Calling" = 1.1.1.1.1.1.1 = 6
% "High Priest Group Leader" = 1.1.1.1.1.1.2 = 6
% "Bishopric" = 1.1.1.1.1.1.3 = 6
% "Patriarch" = 1.1.1.1.1.1.4 = 6
% "Bishopric Secretary/Clerk" = 1.1.1.1.1.1.3.1 = 7
% "Elder Quorum Presidency" = 1.1.1.1.1.1.3.2 = 7
% "Relief Society Presidency" = 1.1.1.1.1.1.3.3 = 7
% "YM/YW/SS Presidency" = 1.1.1.1.1.1.3.4 = 7
% "Primary Presidency" = 1.1.1.1.1.1.3.5 = 7
% "Teacher (classes)" = 1.1.1.1.1.1.3.n.1 = 8
% "Committee or made up calling" = 1.1.1.1.1.1.3.n.2 = 8
% "Youth calling" = = 1.1.1.1.1.1.3.n.3 = 8
% "no calling" = = 1.1.1.1.1.1.3.n.4 = 9

outMaxCalling = zeros(size(inData,1),1);
for i = 1:size(inData,1)
    if inData(i,15) == 1 %'General Authority'
        outMaxCalling(i) = 6;
    elseif inData(i,14) == 1 %'Mission, Area, Temple or counselor'    
        outMaxCalling(i) = 5;
    %skip 13 'Evangelist'
    elseif inData(i,12) == 1
        outMaxCalling(i) = 4; %'Stake Presidency'
    elseif (inData(i,11) == 1 || inData(i,10) == 1 || inData(i,9) == 1 || inData(i,17) == 1)%'Stake Calling', 'Bishopric / Branch presidency', 'High Priest Leadership', Patriarch
        outMaxCalling(i) = 3;
    elseif (inData(i,8) == 1 || inData(i,7) == 1 || inData(i,6) == 1) %'Elders Quorum/Relief Society Presidency', 'YM/YW/Sunday School Presidency/Ward Mission Leader', 
        outMaxCalling(i) = 2;
    elseif (inData(i,5) == 1 || inData(i,4) == 1 || inData(i,3) == 1 || inData(i,2) == 1) %'Calling as a youth (YM/YW age)', 'Committee calling or a calling not found in the official handbook', 'Teaching/Sunday School', Primary/Nursery/Ward Choir/Pianist/Ward Missionary/Family History/Other Auxiliary',
        outMaxCalling(i) = 1;
    else
        outMaxCalling(i) = 0; %1 'Never held a calling'
    end
end
