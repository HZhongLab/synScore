function scoringData = j_deleteSynapseFromScoringData(scoringData,index)
scoringData.synapseID(index) = [];
scoringData.synapseMatrix(index,:) = [];
scoringData.synapseNotes(index,:) = [];
if isfield(scoringData,'synapseZ')
    scoringData.synapseZ(index,:) = [];

end
scoringData.roiCoordinates(:,:,index) = [];

