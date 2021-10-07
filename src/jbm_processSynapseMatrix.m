function [dynamics,data] = jbm_processSynapseMatrix(synapseMatrix,versionNumber,scoringData)
switch versionNumber
    case '2.3'
        %%% Data: Create different matrices based on original synpase
        %%% matrix
        
        % Synapse Matrix
        data.synapseMatrix = synapseMatrix;
        
        % Total Presence Matrix
        presenceMatrix = double(synapseMatrix > 0);
        data.presenceMatrix = presenceMatrix;
        
        % Parse Spine Matrix
        [spineIndx,spTPIndx] = find(synapseMatrix == 2);
        spineIndx = unique(spineIndx);
        spineMatrix = synapseMatrix(spineIndx,:);
        spinePresenceMatrix = double(spineMatrix > 0);
        data.spineMatrix = spineMatrix;
        data.spinePresenceMatrix = spinePresenceMatrix;
        
        % Parse Shaft Matrix (Ignore 4s)
        shaftMatrix = synapseMatrix;
        shaftMatrix(spineIndx,:) = [];
        [redOnlyIndx,roTPIndx] = find(shaftMatrix == 4);
        redOnlyIndx = unique(redOnlyIndx);
        shaftMatrix(redOnlyIndx,:) = [];
        shaftPresenceMatrix = double(shaftMatrix > 0);
        data.shaftMatrix = shaftMatrix;
        data.shaftPresenceMatrix = shaftPresenceMatrix;
        
        % Parse Unsures
        [unsIndx,unsTPIndx] = find(synapseMatrix == 3);
        unsIndx = unique(unsIndx);
        unsMatrix = synapseMatrix(unsIndx,:);
        unsPresenceMatrix = double(unsMatrix > 0);
        data.unsMatrix = unsMatrix;
        data.unsPresenceMatrix = unsPresenceMatrix;
        
      

        
            
        
        %%% Dynamics: creating new dynamics subfields based on different
        %%% matrices from above will automatically be recognized in
        %%% jbm_synanalysis
        
        dynamics.total = calcDynamics(presenceMatrix,scoringData);
        dynamics.spines = calcDynamics(spinePresenceMatrix,scoringData);
        dynamics.shafts = calcDynamics(shaftPresenceMatrix,scoringData);
     
        dynamics.misc = calcMiscDynamics(presenceMatrix,shaftPresenceMatrix,spinePresenceMatrix,dynamics,unsMatrix);
        dynamics.misc2 = calcMisc2Dynamics(presenceMatrix,shaftPresenceMatrix,spinePresenceMatrix,dynamics,unsMatrix);
       
        
end
end

function Aout = calcDynamics(presenceMatrix,scoringData)
% Density
scoringData;
dataDim = size(presenceMatrix);
numTP = dataDim(2);
numSyn = sum(presenceMatrix,1);
normDens = numSyn / numSyn(1);

norm2BaselineDens = numSyn / mean(numSyn(1:3));
norm2Day2Dens = numSyn / numSyn(2);


% Survival Fraction
d1Indx = find(logical(presenceMatrix(:,1)));
d2Indx = find(logical(presenceMatrix(:,2)));
d3Indx = find(logical(presenceMatrix(:,3)));
d4Indx = find(logical(presenceMatrix(:,4)));
d5Indx = find(logical(presenceMatrix(:,5)));

survivalFraction =  mean(presenceMatrix(d1Indx,:),1);
% D1:3 Survival Fraction
d13SF = mean(presenceMatrix(d1Indx,1:3),1);
d46SF = mean(presenceMatrix(d4Indx,4:6),1);

% Birthing Function
d1BirthIndx = find(logical(presenceMatrix(:,end)));
d3BirthIndx = find(logical(presenceMatrix(:,3)));
d6BirthIndx = find(logical(presenceMatrix(:,6)));
%d7BirthIndx = find(logical(presenceMatrix(:,7)));

birthingFraction = mean(presenceMatrix(d1BirthIndx,:),1);
d13BF = mean(presenceMatrix(d3BirthIndx,1:3),1);
d46BF = mean(presenceMatrix(d6BirthIndx,4:6),1);

% Running Survival Fraction
onethreeSF = mean(presenceMatrix(d1Indx,1:3),1);
twofourSF = mean(presenceMatrix(d2Indx,2:4),1);
threefiveSF = mean(presenceMatrix(d3Indx,3:5),1);
foursixSF = mean(presenceMatrix(d4Indx,4:6),1);
%fivesevenSF = mean(presenceMatrix(d5Indx,5:7),1);

%duplicateRunning = [onethreeSF;twofourSF;threefiveSF;foursixSF;fivesevenSF];
%duplicateRunning = mean(duplicateRunning,1);
% Normalized Survival Fraction (to Check for Linearity)

d0Matrix = presenceMatrix(d1Indx,:);
sfDensity = sum(d0Matrix,1);




previousDays = sfDensity(1:end-1);
nextDays = sfDensity(2:end);
normalizedSF = [(nextDays ./ previousDays)];

% 1 minus normalizedSF
siz = size(normalizedSF);
UnoMinusNormalizedSFones = ones(siz) - normalizedSF;

% Eliminations of Old and New Synapses
oldDiffMatrix = diff(d0Matrix,1,2);
oldElimMatrix = (oldDiffMatrix == -1);
oldNumElim = sum(oldElimMatrix,1);
numD0Syn = sum(d0Matrix,1);
oldNormElim = oldNumElim ./ numD0Syn(1:end-1);

newMatrix = presenceMatrix;
newMatrix(d1Indx,:) = [];
newDiffMatrix = diff(newMatrix,1,2);
newElimMatrix = (newDiffMatrix == -1);
newNumElim = sum(newElimMatrix,1);

newNormElim = newNumElim ./ numSyn(1:end-1);


% Number and Normalized Eliminations and Additions 
diffMatrix = diff(presenceMatrix,1,2);
eliminationMatrix = (diffMatrix == -1);
additionMatrix = (diffMatrix == 1);
numElim = sum(eliminationMatrix,1);
numAdd = sum(additionMatrix,1);
normElim = numElim ./ numSyn(1:end-1);
normAdd = numAdd ./ numSyn(2:end);

% Number and Normalized Hard Transients (0 1 0), ignoring D-0 and D-end ([1
% 0 0 ..] and [.. 0 0 1], respectively)

hardTransIndx = find(sum(presenceMatrix,2)==1);
hardTransMatrix = presenceMatrix(hardTransIndx,:);
numHardTrans = sum(hardTransMatrix,1);
normHardTrans = numHardTrans ./ numSyn;




% Soft Transients (anything that is seen to be added and subsequently
% eliminated throughout the timecourse)
temp = diffMatrix(:,1:6) .^ 2;
softTransIndx = find(sum(temp,2)==2);

if isempty(softTransIndx)
    numSoftTransAdd = zeros(1,numTP-1);
    normSoftTransAdd = numSoftTransAdd;
    numSoftTransElim = numSoftTransAdd;
    normSoftTransElim = numSoftTransAdd;
else
    softDiffMatrix = diffMatrix(softTransIndx,:);
    numSoftTransAdd = sum(softDiffMatrix == 1,1);
    numSoftTransElim = sum(softDiffMatrix == -1,1);
    normSoftTransAdd = numSoftTransAdd ./ numSyn(2:end);
    normSoftTransElim = numSoftTransElim ./ numSyn(1:end-1);
end

% TOR
TOR = (numAdd + numElim) ./ (2*(numAdd+numSyn(1:end-1)));

% Total Syn Lifetimes No Exclusions
totalSynLifetimes = calculateSynapseLifetimes(presenceMatrix);

% Lifetime of Added Synapses NEEDS TO FACTOR IN
trimmedAdditionMatrix = additionMatrix(:,3:end);
[addedIndx,dayAdded] = find(trimmedAdditionMatrix>0);
addedSynapses = unique(addedIndx);
postTrimmingAdditions = presenceMatrix(addedSynapses,:);
addedAfterTrimmingLifetimes = calculateSynapseLifetimes(postTrimmingAdditions);
postTrimLifetimes = sum(postTrimmingAdditions,2);
totalAvgPostTrimmingLifetime = mean(postTrimLifetimes);

[goneLastDayIndx] = find(postTrimmingAdditions(:,end) == 0);
addedAndEliminatedIndx = goneLastDayIndx;
postTrimmingAdditionsEliminated = postTrimmingAdditions(addedAndEliminatedIndx,4:end);
relativeLifetimesAddedAndEliminatedAfterTrimming = calculateSynapseLifetimes(postTrimmingAdditionsEliminated);
postTrimTransientLifetimes = sum(postTrimmingAdditionsEliminated,2);
eliminatedAvgPostTrimmingAddedLifetime = mean(postTrimTransientLifetimes);

Aout.d13SF = d13SF;
Aout.d46SF = d46SF;
Aout.d13BF = d13BF;

Aout.percentDynamic = (normAdd + normElim) * 100;

Aout.d46BF = d46BF; 
Aout.numSyn = numSyn;
Aout.normDens = normDens;
Aout.numAdd = numAdd;
Aout.normAdd = normAdd;
Aout.numElim = numElim;
Aout.normElim = normElim;
Aout.survivalFraction = survivalFraction;
Aout.numHardTrans = numHardTrans;
Aout.normHardTrans = normHardTrans;
Aout.numSoftTransAdd = numSoftTransAdd;
Aout.normSoftTransAdd = normSoftTransAdd;
Aout.numSoftTransElim = numSoftTransElim;
Aout.normSoftTransElim = normSoftTransElim;
Aout.TOR = TOR;
Aout.normSurvivalFraction = normalizedSF;
Aout.UnoMinusNormalizedSFones = UnoMinusNormalizedSFones;
Aout.oldNormElim = oldNormElim;
Aout.newNormElim = newNormElim;
Aout.totalSynLifetimes = totalSynLifetimes;
Aout.addedAfterTrimmingLifetimes = addedAfterTrimmingLifetimes;
Aout.totalAvgPostTrimmingLifetime = totalAvgPostTrimmingLifetime;
Aout.eliminatedAvgPostTrimmingAddedLifetime = eliminatedAvgPostTrimmingAddedLifetime;
Aout.relativeLifetimesAddedAndEliminatedAfterTrimming = relativeLifetimesAddedAndEliminatedAfterTrimming;
Aout.norm2BaselineDens = norm2BaselineDens;
Aout.norm2Day2Dens = norm2Day2Dens;

Aout.birthingFraction = birthingFraction;
end

function Bout = calcMiscDynamics(totalMatrix,shaftMatrix,spineMatrix,dynamics,ogUnsMatrix)
%spine:shaft ratio during baseline
blSpineMatrix = spineMatrix(:,1:3);
blShaftMatrix = shaftMatrix(:,1:3);
blTotalMatrix = totalMatrix(:,1:3);

blNumSpines = double(sum(logical(sum(blSpineMatrix,2))));
blNumShafts = double(sum(logical(sum(blShaftMatrix,2))));
blNumTotal = double(sum(logical(sum(blTotalMatrix,2))));

Bout.spineShaftRatioBaseline = blNumSpines / blNumShafts

Bout.normTotalAdditions = sum(dynamics.total.numAdd(:,3:6),2) / dynamics.total.numSyn(3)

absentD1TotalMatrix = find(logical(totalMatrix(:,1)) == 0);
addedTotMatrix = totalMatrix(absentD1TotalMatrix,:);
addedPersistentIndx = find(logical(addedTotMatrix(:,7)) == 1);
addedPersistentMatrix = addedTotMatrix(addedPersistentIndx,:);

diffPersistentMatrix = diff(addedPersistentMatrix,1,2);
diffPersistentExpmtMatrix = diffPersistentMatrix(:,3:6);
numPersistentAdds = length(find(diffPersistentExpmtMatrix == 1));


Bout.normPersistentsAddedWholeTimecourse = sum(addedPersistentMatrix(:,(2:end)),1) ./ dynamics.total.numSyn(2:end)


alwaysPersistentIndx = find(sum(totalMatrix,2) == size(totalMatrix,2));
Bout.newPersistentFraction = numPersistentAdds / (numPersistentAdds + length(alwaysPersistentIndx));
Bout.numTotalAdds = sum(dynamics.total.numAdd(3:6));
Bout.numSpineAdds = sum(dynamics.spines.numAdd(3:6));
Bout.numShaftAdds = sum(dynamics.shafts.numAdd(3:6));




Bout.numPersistentAdds = numPersistentAdds
normPersAddedExpmt = numPersistentAdds / dynamics.total.numSyn(3);
Bout.normPersAddedExpmt = normPersAddedExpmt;
    
% addedTEMPmtx2 = presenceMatrix(abzenttD1Indx,:);
% addedPERSISTENTindx = find(logical(addedTEMPmtx2(:,end)) == 1);
% if length(addedPERSISTENTindx) == 1
%     numPersAdded = addedTEMPmtx2;
% else
% numPersAdded = sum(addedTEMPmtx2(addedPERSISTENTindx,:));
% end
% 
% 
% 
% 
% numPersTotalAddedExpmt = sum(dynamics.total.numPersAdded(4:7));
% Bout.numPersTotalAddedExpmt = numPersTotalAddedExpmt;
% Bout.normPersTotalAddedExpmt = numPersTotalAddedExpmt / dynamics.total.numSyn(3);


numTransTotalAddedExpmt = sum(dynamics.total.numSoftTransAdd(3:6));

Bout.numTransTotalAddedExpmt = numTransTotalAddedExpmt;
Bout.normTransTotalAdded = numTransTotalAddedExpmt / dynamics.total.numSyn(3);

numTransSpinesAddeddExpmt = sum(dynamics.spines.numSoftTransAdd(3:6))
Bout.normTransSpinesAdded = numTransSpinesAddeddExpmt / dynamics.total.numSyn(3);
Bout.numTransSpinesAddedExpmt = numTransSpinesAddeddExpmt;
Bout.numTransShaftsAddedExpmt = sum(dynamics.shafts.numSoftTransAdd(3:6))
Bout.normTransShaftsAdded = sum(dynamics.shafts.numSoftTransAdd(3:6)) / dynamics.total.numSyn(3);


numSpinesAddedExpmt = sum(dynamics.spines.numAdd(3:6))
Bout.normSpinesAdded = numSpinesAddedExpmt / dynamics.total.numSyn(3);
Bout.normShaftsAdded = sum(dynamics.shafts.numAdd(3:6)) / dynamics.total.numSyn(3)

Bout.norm2SpinesSpinesAdded = numSpinesAddedExpmt / blNumSpines;

Bout.numSpine = dynamics.spines.numSyn


[unsIndx,unsTPIndx] = find(ogUnsMatrix(:,3:6) == 3);
        unsIndx = unique(unsIndx);
        newUnsMatrix = ogUnsMatrix(unsIndx,:);
        
        
       
        Bout.numUnsuresExpmt = length(find(ogUnsMatrix(:,3:6)==3))
        Bout.normUnsuresExpmt = Bout.numUnsuresExpmt / mean(dynamics.total.numSyn(1:3))

        
        Bout.blNormAdditions = dynamics.total.normAdd(2);
        Bout.expmtNormAdditions = mean(dynamics.total.normAdd(3:6))
        
        Bout.blNormEliminations = dynamics.total.normElim(2);
        Bout.expmtNormEliminations = mean(dynamics.total.normElim(3:6));
        
          diffMatrix2 = diff(totalMatrix,1,2);
            [addedSyn4,addedTP4] = find(diffMatrix2(:,3) == 1);
            [addedSyn5,addedTP5] = find(diffMatrix2(:,4) == 1);

            prz = totalMatrix(addedSyn4,:);
            prz2 = totalMatrix(addedSyn5,:);
            

            data.addedD4Mtx = prz;
            data.addedD5Mtx = prz2;
            
            data.addedD4D5Matrix = vertcat(prz,prz2)

end

function Cout = calcMisc2Dynamics(presenceMatrix,shaftPresenceMatrix,spinePresenceMatrix,dynamics,ogUnsMatrix)
diffMatrix = diff(presenceMatrix,1,2);
[addedSyn4,addedTP4] = find(diffMatrix(:,3) == 1);
[addedSyn5,addedTP5] = find(diffMatrix(:,4) == 1);

prz = presenceMatrix(addedSyn4,4:7);
prz2 = presenceMatrix(addedSyn5,5:7);


Cout.addedD4Mtx = prz;
Cout.addedD5Mtx = prz2;




end