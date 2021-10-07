classdef synClust
  properties
    scoringData;
    numDays;
    numSyn;
    graphParameters;
    distanceMatrix;
    subDistanceMatrix;
    clustData;
    twoPointQuantMatrix;
    
  end

  methods
    function obj = synClust(fn)
      obj.scoringData = jbm_loadSynFile(fn);
      synapseMatrix = obj.scoringData.synapseMatrix;
      synSize = size(synapseMatrix);
      obj.numDays = synSize(2);
      obj.numSyn = synSize(1);
        for i = 1:obj.numDays
            [obj.clustData(i).synIDs,obj.clustData(i).micronsAlongDendrite,graphParameters] = getPosAlongDendrite(obj.scoringData,i);
            obj.graphParameters.skeleton(i) = graphParameters.skeleton;
            obj.graphParameters.synapses(i) = graphParameters.synapses;
            obj.graphParameters.coordinatesOnShaft(i) = graphParameters.coordinatesOnShaft;
        end
        
      Aout = createDistanceMatrix(obj.clustData,obj.scoringData);
      obj.distanceMatrix = Aout.distanceMatrix;
      obj.subDistanceMatrix = Aout.subDistanceMatrix;
      obj.twoPointQuantMatrix = Aout.twoPointQuantMtx;
    end
    
    function vis3D(obj)
        figure; subplot(2,4,1);
        for i = 1:obj.numDays
            subplot(2,4,i);
            hold on;
            plot3(obj.graphParameters.skeleton(i).x,obj.graphParameters.skeleton(i).y,obj.graphParameters.skeleton(i).z,'o-');
            plot3(obj.graphParameters.synapses(i).x,obj.graphParameters.synapses(i).y,obj.graphParameters.synapses(i).z,'g*');
            
            plot3([obj.graphParameters.synapses(i).x',obj.graphParameters.coordinatesOnShaft(i).x]',...
                [obj.graphParameters.synapses(i).y',obj.graphParameters.coordinatesOnShaft(i).y]',...
                [obj.graphParameters.synapses(i).z,obj.graphParameters.coordinatesOnShaft(i).z]',...
                'color',[1 0 0]);
            
            title(['TP ' num2str(i)])
            
            text(obj.graphParameters.synapses(i).x,obj.graphParameters.synapses(i).y,obj.graphParameters.synapses(i).z,...
                num2str(obj.clustData(i).synIDs'));
                
            
        end
    end

    function Aout = dynClust(obj,clusterThreshold)
                        
        presenceMatrix = logical(obj.scoringData.synapseMatrix);
        
        diffMatrix = diff(presenceMatrix,1,2);
        
        addMatrix = (diffMatrix == 1);
        elimMatrix = (diffMatrix == - 1);
        
        isAddMatrix = zeros(size(diffMatrix,1),size(diffMatrix,2)+1);
        isElimMatrix = zeros(size(diffMatrix,1),size(diffMatrix,2)+1);
        
        isAddMatrix(:,2:end) = addMatrix;
        isElimMatrix(:,1:end-1) = elimMatrix;
        addDistanceMatrix = zeros(size(diffMatrix,1),size(diffMatrix,2)+1);
        elimDistanceMatrix = zeros(size(diffMatrix,1),size(diffMatrix,2)+1);
        
        
        
        [addIndx,addTP] = find(isAddMatrix == 1);
        [elimIndx,elimTP] = find(isElimMatrix == 1);
        
        
        for i = 1:length(elimIndx)
            elimDistanceMatrix(elimIndx(i),elimTP(i)) = obj.subDistanceMatrix(elimIndx(i),elimTP(i))
        end
        
        sortedElimDistanceMatrix = sort(elimDistanceMatrix);
        sortedElimDistanceMatrix(sortedElimDistanceMatrix==0) = NaN
        diffSortElimDistMtx = diff(sortedElimDistanceMatrix);
        ;
        
        for i = 1:(obj.numDays-1)
            numEliminatedClusteredSyn(i) = 0;
            elimdayInterSynDist = diffSortElimDistMtx(:,i)
            elimdayInterSynDist = elimdayInterSynDist(~isnan(elimdayInterSynDist));
            eClusters = jbm_euclideanSynapseCluster(elimdayInterSynDist,3)
            
            Aout.eClusters{i} = eClusters
            numEliminatedClusteredSyn(i) = sum(eClusters)
            if eClusters == 0
                numElimClusters(i) = 0
            else
                numElimClusters(i) = length(eClusters)
            end
        end
        Aout.numElimClusters = numElimClusters
        Aout.numEliminatedClusteredSyn = numEliminatedClusteredSyn
        
        
        
        for i = 1:length(addIndx)
            addDistanceMatrix(addIndx(i),addTP(i)) = obj.subDistanceMatrix(addIndx(i),addTP(i));
        end
        
        sortedAddDistanceMatrix = sort(addDistanceMatrix);
        sortedAddDistanceMatrix(sortedAddDistanceMatrix==0) = NaN;
        diffSortAddDistMtx = diff(sortedAddDistanceMatrix);
        
        for i = 2:obj.numDays
            numAddedClusteredSyn(i) = 0;
           adddayInterSynDist = diffSortAddDistMtx(:,i);
           adddayInterSynDist = adddayInterSynDist(~isnan(adddayInterSynDist));
           clusters = jbm_euclideanSynapseCluster(adddayInterSynDist,3);
           Aout.clusters{i-1} = clusters;
           numAddedClusteredSyn(i) = sum(clusters);
           if clusters == 0
               numAddClusterz(i-1) = 0;
           else
               numAddClusterz(i-1) = length(clusters);
           end
            
        end
        Aout.numAddedClusteredSyn = numAddedClusteredSyn
        Aout.numAddClusterz = numAddClusterz
        Aout.addIndx = addIndx;
        Aout.addTP = addTP;
        Aout.isAddMatrix = isAddMatrix;
        Aout.addDistanceMatrix = addDistanceMatrix;
        Aout.sortedAddDistanceMatrix = sortedAddDistanceMatrix;
        Aout.diffSortAddDistMtx = diffSortAddDistMtx;
        
        
        
        
    end
    
    function Aout = qualityControl(obj)
        subDistanceMatrix = obj.subDistanceMatrix;
        twoPointQuantMatrix = obj.twoPointQuantMatrix;
        twoPointQuantMatrix(isnan(twoPointQuantMatrix)) = 0;
        [numSyn,numTP] = size(subDistanceMatrix);
        twoPQPIndx = find(sum(logical(twoPointQuantMatrix),2) == numTP);
        twoPQPMtx = twoPointQuantMatrix(twoPQPIndx,:);
        figure(4);
        hold on;
        for i = 1:length(twoPQPMtx)
            plot(twoPQPMtx(i,:))
            twoPQlocDiff(i) = range(twoPQPMtx(i,:));
        end
        title('two point quantize location')
        
        figure(5); hold on;
        for i = 1:length(twoPQPMtx)
            plot(twoPQPMtx(i,:) - twoPQPMtx(i,1));
        end
        title('zero two point quantize')
        
        
        subDistanceMatrix = obj.subDistanceMatrix;
        subDistanceMatrix(isnan(subDistanceMatrix)) = 0;
        [numSyn,numTP] = size(subDistanceMatrix);
        persIndx = find(sum(logical(subDistanceMatrix),2) == numTP);
        persistentSubDistanceMatrix = subDistanceMatrix(persIndx,:);
        figure(1);
        hold on;        
        for i = 1:length(persistentSubDistanceMatrix)
            plot(persistentSubDistanceMatrix(i,:));
            locationDiff(i) = range(persistentSubDistanceMatrix(i,:));
        end
        title('no quantize location');
        
        figure(2); hold on;
        for i = 1:length(persistentSubDistanceMatrix)
            plot(persistentSubDistanceMatrix(i,:) - persistentSubDistanceMatrix(i,1));
        end
        title('Range')
        figure(3);
        hold on;
        plot(ones(size(locationDiff)),locationDiff,'*r');
        title('no quantize range');
        global synQC
        Aout.maxLocationDiff = max(max(locationDiff))
        Aout.meanLocationDiff = mean(mean(locationDiff))
    end
    
  end
end

