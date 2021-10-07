function [outInfo] = calcDendMetaData(dendriteData)
fldz = fields(dendriteData);
numConditions = length(fldz);
for i = 1:numConditions
    condition = dendriteData.(fldz{i});
    outInfo.(fldz{i}) = calcMeta(condition);
end

end

function Aout = calcMeta(condition)
condition = rmfield(condition,'group');
fieldz = fields(condition);
numSyn = 0;
numNeedLength = 0;
totLength = 0;
NEEDTODELETEONE = length(fieldz) - length(unique(fieldz));

numDendrites = length(fieldz);
for i = 1:numDendrites
    sz = size(condition.(fieldz{i}).data.synapseMatrix);
    numD0 = sum(logical(condition.(fieldz{i}).data.synapseMatrix(:,1)));
    numSyn = numSyn + sz(1);
    
    Aout.numSyn = numSyn;
    
    if isfield(condition.(fieldz{i}).scoringData,'skeleton')
        
        td = condition.(fieldz{i}).scoringData.skeleton.tracingData{1}.skeletonInMicron(:,4);
        savedTrace = max(td);
        totLength = totLength + savedTrace;
        synPerMicron(i) = numD0 / savedTrace;
    else
        fieldz{i}
        numNeedLength = numNeedLength + 1;
        
        
    end
end

Aout.numSyn = numSyn;
Aout.totLength = totLength;
Aout.numNeedLength = numNeedLength;
Aout.NEEDTODELETEONE = NEEDTODELETEONE;
Aout.synPerMicron = synPerMicron;
end