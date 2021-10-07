function [] = synClustOnFile(fpath)
    fn = fpath;
    scoringData = jbm_loadSynFile(fn);
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
    uisave('scoringData',['final_' fpath])
end


