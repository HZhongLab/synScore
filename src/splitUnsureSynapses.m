function modSynMtx = splitUnsureSynapses(synapseMatrix,flag)
modSynMtx = synapseMatrix;
num3s = length(synapseMatrix(synapseMatrix==flag));
temp = size(synapseMatrix);
numSyn = temp(1);
numDays = temp(2);  


[synapses,days] = find(modSynMtx == flag);
synToMod = modSynMtx(unique(synapses),:);
modSynMtx(unique(synapses),:) = []
[synapses,days] = find(synToMod == flag);

toAdd = [];

for i = 1:length(synapses)
    splitSyn = [zeros(1,numDays); zeros(1,numDays)];
    splitSyn(1,1:days(i)-1) = synToMod(synapses(i),1:days(i)-1);
    splitSyn(2,days(i)+1:end) = synToMod(synapses(i),days(i)+1:end);
    toAdd = [toAdd; splitSyn]
keyboard    
  
   
end

