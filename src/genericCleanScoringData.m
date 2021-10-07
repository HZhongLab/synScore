function [cleanedScoringData] = genericCleanScoringData(scoringData)

emptySynapses = find(sum(scoringData.synapseMatrix,2) == 0);
cleanedScoringData = deleteSynapseFromScoringData(scoringData,emptySynapses);


end

