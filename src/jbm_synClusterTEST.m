function [micronAlongDendrite,synapseIDs] =  jmb_synClusterTEST(fn,dayOfInterest)
scoringData = jbm_loadSynFile(fn);

tp_temp = dayOfInterest;
skelVal = [scoringData.skeleton.tracingData{dayOfInterest}.tracingMarks.pos];
skelX = skelVal(1:3:end);
skelY = skelVal(2:3:end);
skelZ = skelVal(3:3:end);

skelX = skelX*0.0887 %hardcoded pixel size
skelY = skelY*0.0887
skelZ = skelZ*0.8

synapseMatrix = scoringData.synapseMatrix;
dayOfInterestSynapseMatrix = synapseMatrix(:,tp_temp);


daysRoiCoordinates = scoringData.roiCoordinates(:,tp_temp,logical(dayOfInterestSynapseMatrix))

synSize = size(daysRoiCoordinates);
numDay = synSize(2);
numSyn = synSize(3);

for i = 1:numSyn
    synX(i) = daysRoiCoordinates(1,1,i);
    synY(i) = daysRoiCoordinates(2,1,i);
end

synZ = scoringData.synapseZ(logical(dayOfInterestSynapseMatrix),tp_temp);




%ind2Rm = find(synZ==0);
%synX(ind2Rm) = [];
%synY(ind2Rm) = [];
%synZ(ind2Rm) = [];
%synZ = synZ;
%skelZ = skelZ;

synX = synX*0.0887
synY = synY*0.0887
synZ = synZ*0.8

figure
plot3(skelX,skelY,skelZ,'o-')
hold on
plot3(synX,synY,synZ,'g*')

closestPoints = distance2curve([skelX' skelY' skelZ'],[synX' synY' synZ],...
    'linear')

plot3([synX',closestPoints(:,1)]',[synY',closestPoints(:,2)]',[synZ,closestPoints(:,3)]','color',[1 0 0])

synapseIDText = scoringData.synapseID(logical(dayOfInterestSynapseMatrix));

text(synX,synY,synZ,synapseIDText');


numSkelPairs = length(skelX) - 1;

for i = 1:numSyn
  synapseLocationOnShaft = closestPoints(i,:);
  for j = 1:length(skelZ)
    skelPoint = [skelX(j) skelY(j) skelZ(j)];
    synToSkelPoint(j) = pdist([skelPoint; synapseLocationOnShaft],'euclidean');

  end
  closestPointIndex = find(synToSkelPoint==min(synToSkelPoint));
  if closestPointIndex == 1
    closestPointRange = 1:3
  elseif closestPointIndex == length(skelX)
    numSkelPoints = length(skelX);
    closestPointRange = numSkelPoints-2:numSkelPoints
  else
    closestPointRange = closestPointIndex-1:closestPointIndex+1
  end

  for k = 1:2
      segmentToTest = [skelX(closestPointRange(k:k+1))' skelY(closestPointRange(k:k+1))' ...
        skelZ(closestPointRange(k:k+1))']

        [xxx,yyy(k),ttt] = distance2curve(segmentToTest,synapseLocationOnShaft)
  end
  indxxxxzzz = find(yyy==min(yyy))
  pointsInBetween = closestPointRange(indxxxxzzz:indxxxxzzz+1)
  pointBefore = min(pointsInBetween)
  distAlongDendrite = [skelX(1:pointBefore)' skelY(1:pointBefore)' skelZ(1:pointBefore)'; synapseLocationOnShaft]
  micronAlongDendrite(i) = arclength(distAlongDendrite(:,1),distAlongDendrite(:,2),distAlongDendrite(:,3))
  synapseIDs = scoringData.synapseID(logical(dayOfInterestSynapseMatrix))
end
