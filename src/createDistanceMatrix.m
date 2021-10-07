function [Aout] = createDistanceMatrix(clustData,scoringData)

synapseMatrix = scoringData.synapseMatrix;
allSynapseIDs = str2double(scoringData.synapseID);
distanceMatrix = zeros(size(synapseMatrix));
for i = 1:length(clustData)
    clustIDs = clustData(i).synIDs;
    for j = 1:length(clustIDs)
        synDex = find(allSynapseIDs == clustIDs(j));
        distanceMatrix(synDex,i) = clustData(i).micronsAlongDendrite(j);
    end
end


k=1;
for i = 1:size(distanceMatrix,1)
    if sum(logical(distanceMatrix(i,:))) == 8
        persistentDistanceMatrix(k,:) = distanceMatrix(i,:);
        k = k + 1;
    end
end

% for i = 1:size(persistentDistanceMatrix,2)
%    closestPoint(i) = min(persistentDistanceMatrix(:,i));
%    closestSynDex(i) = find(persistentDistanceMatrix(:,i) == closestPoint(i));
% end
%
% test = sum(closestSynDex/closestSynDex(1))
% if test ~= size(persistentDistanceMatrix,2)
%     disp('ERROR'); return;
% else
% end

   
        closestPointOnTP1 = min(persistentDistanceMatrix(:,1));
        closestSynDex = find(persistentDistanceMatrix(:,1) == closestPointOnTP1);
        for i = 1:size(persistentDistanceMatrix,2)
            closestPoint(i) = persistentDistanceMatrix(closestSynDex,i);
        end
        
        
        for i = 1:size(persistentDistanceMatrix,2)
            dayDistanceMatrix = distanceMatrix(:,i);
            dayDistanceMatrix(dayDistanceMatrix == 0) = dayDistanceMatrix(dayDistanceMatrix==0) + closestPoint(i);
            dayDistanceMatrix = dayDistanceMatrix - closestPoint(i);
            subDistanceMatrix(:,i) = dayDistanceMatrix;
        end
        subDistanceMatrix(subDistanceMatrix == 0) = NaN;
        
        
        
        [temp,sortedIndx] = sort(persistentDistanceMatrix(:,1));
       
        sortedPersistentDistanceMtx = persistentDistanceMatrix(sortedIndx,:);
        
        Aout.distanceMatrix = distanceMatrix;
        Aout.subDistanceMatrix = subDistanceMatrix;
        
        %D0 Two-Point Quantization
       twoPointQuantFactor = sortedPersistentDistanceMtx(end,:)-sortedPersistentDistanceMtx(1,:);
       twoPointQuantFactor = twoPointQuantFactor / twoPointQuantFactor(1);
       
       for i = 1:length(clustData)
          daySubDistanceMatrix = subDistanceMatrix(:,i);
          twoPointQuantMtx(:,i) = daySubDistanceMatrix / twoPointQuantFactor(i)
       end
        Aout.twoPointQuantMtx = twoPointQuantMtx;
        %D0 Cumulative Quantization
%         Aout.cumQuantMtx = generateCumQuantMtx(subDistanceMatrix);
        
        % Baseline Two-Point
        
        % Baseline Cumulative
        
        % Average Two-Point
        
        % Average Cuulative (Problematic w/ Trimming: Movement?)
        
        




end

function cumQuantMtx = generateCumQuantMtx(subDistanceMatrix)
numDaysPresent = sum(~isnan(subDistanceMatrix),2);
[persistentSynDex] = find(numDaysPresent == size(subDistanceMatrix,2));
persistentSynMatrix = subDistanceMatrix(persistentSynDex,:);
[temp,d0SortDex] = sort(persistentSynMatrix(:,1));
sortedPSM = persistentSynMatrix(d0SortDex,:);
pDiffMtx = diff(sortedPSM);
k = 1;
for i = 1:size(pDiffMtx,1)
    synDiff = pDiffMtx(i,:)
    synDiff = synDiff ./ abs(synDiff);
    if sum(synDiff) ~= size(subDistanceMatrix,2)
        toDelDex(k) = i+1;
        k = k + 1;
    end
    
end
sortedPSM(toDelDex,:) = [];
[t,tidx] = sort(sortedPSM(:,1))
sortedPSM = sortedPSM(tidx,:); %Probably redundant

pDiffMtx = diff(sortedPSM)

for i = 1:size(pDiffMtx,1)
    quantFactor(i,:) = pDiffMtx(i,:) / pDiffMtx(i,1);
end

for i = 1:size(subDistanceMatrix,2)
    distances = subDistanceMatrix(:,i);
    persistents = sortedPSM(:,i)
    persistentDiff = diff(persistents);
end


end

