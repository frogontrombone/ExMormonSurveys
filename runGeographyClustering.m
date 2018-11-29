function [outTempGeographyCluster,outTempGeographyClusterArray] = runGeographyClustering(inMotivesSurvey,inUseSeed)
%This function serves primarily to simplify the main code. Edits should be
%made here directly.

%GEOGRAPHICAL DATA
%In the survey, I collected geographical data by asking people to click a 
%point on a picture of the United States or the World.  The output is pixel
%data relating to which pixel on the picture that people clicked.  There
%are at least two ways this data could be used in an meaningful way.  The 
%first is to cluster the data by coordinantes into discrete groups.  This
%approach makes impersonal decisions about data points that lie in "gray
%areas" between groups, but still requires a human to determine if the
%grouping is meaningful.  The second approach is to pick a central point
%(SLC), and calculate the distance that each point lies from that point.
%This second approach assumes that geographic distance from SLC correlates
%with cultural and relgious orthodoxy, but ignores possible issues that may
%be more important for far-flung regions.  Further, it assumes a linear
%mapping from the cartesian plane to the spherical globe, so the data would
%be distorted anyway. This second approach is not implemented, but would be
%an interesting coding exercise, especially to correct for curvature.

USClusters = 10;
WorldClusters = 8;
USCentroidSeed = [270.1043  541.9258;  226.6374  439.4737;  194.0622  571.8660;
  469.7253  538.5604;  260.2174  501.6522;  573.9080  529.5632;  397.7300  643.4900;
  258.4253  613.8276;  538.7547  629.3396;  149.0909  209.8182];
worldCentroidSeed = [246.8 393.5; 645.8 212.5;
    534 252; 596 287; 651 574; 359 587.5; 1065 583; 992 389.7];

%%Mapping, based on seeded clusters that I decided were meaningful.
MappingMatrix = {1 'Utah'; 2 'Pacific Northwest'; 3 'California/Hawaii';
                4 'Midwest/Great Lakes'; 5 'Idaho'; 6 'New England';
                7 'Southern Central US'; 8 'SouthWest'; 9 'Southern States';
                10 'Alaska'; 11 'Central America'; 12 'Scandinavia/Russia';
                13 'Great Britain'; 14 'Europe Mainland'; 15 'Africa';
                16 'South America'; 17 'South Pacific / Australia';
                18 'Central Pacific / Japan';
                19 'not reported'};
            
%Run the clustering algorithm and plot.  The centroid seeds force the 
%results to be consistent every time the algorithm is run. Not using seeds 
%will result in new groupings each time, though they will be similar. If 
%you do not want to use the seeds, the last input argument should be 0.
[ClusterIDUS,USClusterCenters,UScoordinates,rowsClusteredUS] = ...
    GeographicClustering(inMotivesSurvey,0,USClusters,'US/Canada',12,13,14,...
    'north-america-map.gif',USCentroidSeed,inUseSeed);
[ClusterIDWorld,WorldClusterCenters,WorldCoordinates,rowsClusteredWorld] = ...
    GeographicClustering(inMotivesSurvey,0,WorldClusters,'Elsewhere',...
    12,15,16,'world-map.gif',worldCentroidSeed,inUseSeed);

%put the geographical information into a storage array for safe keeping
outTempGeographyCluster = zeros(length([inMotivesSurvey{1:end,1}]),1);
for i=1:length(UScoordinates) 
    outTempGeographyCluster(UScoordinates(i,1)) = ClusterIDUS(i);
end
for i=1:length(WorldCoordinates)
    outTempGeographyCluster(WorldCoordinates(i,1)) = ClusterIDWorld(i) + USClusters;
end
for i=1:length(outTempGeographyCluster)
    if outTempGeographyCluster(i) == 0
        outTempGeographyCluster(i) = 19;
    end
end

outTempGeographyClusterArray = [{'Geographical Cluster'}; {''}; num2cell(outTempGeographyCluster)];
for i=3:length(outTempGeographyClusterArray)
    outTempGeographyClusterArray{i}=MappingMatrix(outTempGeographyClusterArray{i},2);
end

