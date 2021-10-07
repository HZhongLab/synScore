function [synIDs,micronsAlongDendrite,graphParameters] = getPosAlongDendrite(scoringData,imagingDay)
 

  skeletonValues = [scoringData.skeleton.tracingData{imagingDay}.tracingMarks.pos];
  skeleton.x = skeletonValues(1:3:end);
  skeleton.y = skeletonValues(2:3:end);
  skeleton.z = skeletonValues(3:3:end);

  % NEED TO MAKE THIS MODULAR FOR DIFFERENT ZOOMS
  skeleton.x = skeleton.x * 0.0887;
  skeleton.y = skeleton.y * 0.0887;
  skeleton.z = skeleton.z * 0.8;

  synapseMatrix = scoringData.synapseMatrix;
  doiSynapseMatrix = synapseMatrix(:,imagingDay);

  doiRoiCoordinates = scoringData.roiCoordinates(:,imagingDay,logical(doiSynapseMatrix));

  synSize = size(doiRoiCoordinates);
  numSyn = synSize(3);
  synIDs = str2double(scoringData.synapseID(logical(doiSynapseMatrix)));

  for i = 1:numSyn
    synapses.x(i) = doiRoiCoordinates(1,1,i);
    synapses.y(i) = doiRoiCoordinates(2,1,i);
  end
  synapses.z = scoringData.synapseZ(logical(doiSynapseMatrix),imagingDay);
  
  synapses.x = synapses.x*0.0887;
  synapses.y = synapses.y*0.0887;
  synapses.z = synapses.z*0.8;

    closestPointsOnDendrite = distance2curve([skeleton.x' skeleton.y' skeleton.z' ...
    ],[synapses.x' synapses.y' synapses.z],'linear');

  numSkeletonPairs = length(skeleton.y) - 1;
    
  for i = 1:numSyn
    synapseLocationOnShaft = closestPointsOnDendrite(i,:);
    for j = 1:length(skeleton.y)
      skeletonPoint = [skeleton.x(j) skeleton.y(j) skeleton.z(j)];
      synapseToSkeletonDistance(j) = pdist([skeletonPoint;synapseLocationOnShaft],'euclidean');
    end

    closestSkelMark = find(synapseToSkeletonDistance==min(synapseToSkeletonDistance));
    if closestSkelMark == 1
      skelMarkRange = 1:3;
    elseif closestSkelMark == length(skeleton.y)
      numSkelMarks = length(skeleton.x);
      skelMarkRange = numSkelMarks-2:numSkelMarks;
    else
      skelMarkRange = closestSkelMark-1:closestSkelMark+1;
    end

    for k = 1:2
      dendriticSegmentToTest = [skeleton.x(skelMarkRange(k:k+1))' skeleton.y(skelMarkRange(k:k+1))' ...
        skeleton.z(skelMarkRange(k:k+1))'];

      [point,distance(k),t] = distance2curve(dendriticSegmentToTest,synapseLocationOnShaft);
    end

    flankingSkelMarks = skelMarkRange((find(distance==min(distance))):(find(distance == min(distance))+1));
    previousSkelMark = min(flankingSkelMarks);

    synArcCurve = [skeleton.x(1:previousSkelMark)' skeleton.y(1:previousSkelMark)' skeleton.z(1:previousSkelMark)'; ...
      synapseLocationOnShaft];

    micronsAlongDendrite(i) = arclength(synArcCurve(:,1),synArcCurve(:,2),synArcCurve(:,3));

    graphParameters.skeleton = skeleton;
    graphParameters.synapses = synapses;
    graphParameters.coordinatesOnShaft.x = closestPointsOnDendrite(:,1);
    graphParameters.coordinatesOnShaft.y = closestPointsOnDendrite(:,2);
    graphParameters.coordinatesOnShaft.z = closestPointsOnDendrite(:,3);


end
end

