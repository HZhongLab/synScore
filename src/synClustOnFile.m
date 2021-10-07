function [] = synClustOnFile(fpath)
   
    scoringData = jbm_loadSynFile(fpath);

    if ~isfield(scoringData,'distances')
        synapseMatrix = scoringData.synapseMatrix;
        synSize = size(synapseMatrix);
        numDays = synSize(2);

        for i = 1:numDays
            [obj.clustData(i).synIDs,obj.clustData(i).micronsAlongDendrite,graphParameters] = getPosAlongDendrite(scoringData,i);
            obj.graphParameters.skeleton(i) = graphParameters.skeleton;
            obj.graphParameters.synapses(i) = graphParameters.synapses;
            obj.graphParameters.coordinatesOnShaft(i) = graphParameters.coordinatesOnShaft;
        end

        scoringData.distances = obj;
    else
        scoringData = scoringData;
    end
    save(['CLUSTERED_' fpath],'scoringData');
end


