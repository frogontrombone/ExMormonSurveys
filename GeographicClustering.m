function [outclusterID,outCentroidCenters,outXY, outRowsToCluster] = ...
    GeographicClustering( inRawData,...
    inHeaders, inNumClusters, inResponse, inLocationColumn,inX,inY,inImage,inSeed,inUseSeed )
%This function brings in pixel data (X and Y coordinates) and clusters
%these into groups.  The XY coordinates relate to geographic locations on a
%map, so these groups are geographic regions.

%We only want to cluster the data that is on the map of interest.  In this
%case, there are two maps, so we only want the data from the appropriate
%map.
%An array of which rows belong and which do not.
outRowsToCluster = ismember([inRawData{1+inHeaders:end,inLocationColumn}],inResponse);
outXY = zeros(sum(outRowsToCluster),3); %the XY coordinates of the final data

%Sort through the data and remove rows that do not belong to the right map
j=1;
for i=1:length(outRowsToCluster)
    if outRowsToCluster(i) %is this from the right map?
        if strcmp(inRawData{i+inHeaders,inX},'') %check for missing data
            outRowsToCluster(i) = 0; %mark missing data as -1, this may be unnecessary
            outXY(j,3) = i+inHeaders; %enter the row that the data comes from
            j = j+1;
        else
            outXY(j,1) = inRawData{i+inHeaders,inX}; %enter the x data
            outXY(j,2) = inRawData{i+inHeaders,inY}; %enter the y data
            outXY(j,3) = i+inHeaders; %enter the row that the data comes from
            j = j+1;
        end
    end
end

%filter out missing data (0,0)
outXY = outXY(~ismember( outXY(:,1),0),:);

%k-means clustering.
%Note: this creates different clusters every time unless there is a set of
%suggested starting centroids (inSeed).
if inUseSeed
    [outclusterID,outCentroidCenters] = kmeans(outXY(:,1:2),inNumClusters,'Start',inSeed);
else
    [outclusterID,outCentroidCenters] = kmeans(outXY(:,1:2),inNumClusters);
end

%Plot the results.
figure;
hold on
imshow(inImage)
hold on
color = ['y','m','g','c','b','w','k','y','m','g','c','b','w','k','y','m','g','c','b','w','k'];
for i=1:length(outclusterID)
   plot(outXY(i,1),outXY(i,2),color(outclusterID(i)),'MarkerSize',5,'Marker','*');
   hold on
end
plot(outCentroidCenters(:,1),outCentroidCenters(:,2),'ro','MarkerSize',20);

title 'Location Data';
xlabel 'X (px)';
ylabel 'Y (px)';

end

