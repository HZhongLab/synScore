function [idx] = idxFromID(ID)
    global jbm
    ID = num2str(ID);
    idx = find(strcmp([jbm.scoringData.synapseID],ID));
return
