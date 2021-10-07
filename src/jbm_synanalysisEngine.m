function jbm_synanalysisEngine(tag,handles)
global synana;
synana.gh.currentHandles = handles;

switch tag
    case 'new condition'
        newcondition();
    case 'delete condition'
        deletecondition();
    case 'add dendrites to condition'
        adddendrites();
    case 'delete dendrites from condition'
        deletedendrites();
    case 'new animal'
        newanimal();
    case 'delete animal'
        deleteanimal();
    case 'return data'
        returndata();
    case 'update info'
        updateinfo();
    case 'save'
        saveIt();
    case 'load'
        loadIt();
end
end

function saveIt()
global synana;
condition = synana.condition;
uisave('condition','.ana');
end

function loadIt()
global synana;
synana.condition =[];
[fn pn] = uigetfile();

if fn~=0
    filePath = [pn fn];
    temp = load(filePath,'-mat');
    synana.condition = temp.condition;
elseif fn == 0
    return;
end
updateinfo();
end

function deleteanimal()
global synana;
indx = synana.clickIndx.animalsByConditionTable;
conditions = fields(synana.condition);
if size(indx)~= [1 2]
    disp('error, please only select one animal')
elseif size(indx) == [1 2]
    animalz = fields(synana.condition.(conditions{indx(2)}).animals);
    synana.condition.(conditions{indx(2)}).animals = rmfield(synana.condition.(conditions{indx(2)}).animals,animalz{indx(1)});
end
updateinfo()
end

function newanimal()
global synana;
conditions = fields(synana.condition);
indx = synana.clickIndx.dendritesByConditionTable;
cIndx = indx(:,2);
if length(unique(cIndx)) > 1
    disp('Error, only select one condition at a time');
elseif length(unique(cIndx)) == 1
    animalName = inputdlg('Animal code: ');
    if isempty(animalName)
        return
    else
        cIndx = unique(cIndx);
        
        
        synana.condition.(conditions{cIndx}).animals.(animalName{1}).fns = ...
            synana.condition.(conditions{cIndx}).dendrites.fns(indx(:,1));
        synana.condition.(conditions{cIndx}).animals.(animalName{1}).fpaths = ...
            synana.condition.(conditions{cIndx}).dendrites.fpaths(indx(:,1));
        
        
    end
    
end
updateinfo()
end

function deletecondition()
global synana;
conditions = fields(synana.condition);
indx = synana.clickIndx.dendritesByConditionTable;
indx = indx(:,2);
if length(unique(indx)) > 1
    disp('Error, only select one condition at a time');
elseif length(unique(indx)) == 1
    synana.condition = rmfield(synana.condition,conditions(indx));
    
end
updateinfo()
end

function deletedendrites()
global synana;
conditions = fields(synana.condition);
indx = synana.clickIndx.dendritesByConditionTable;
cIndx = indx(:,2);
if length(unique(cIndx)) > 1
    disp('Error, only select one condition at a time');
elseif length(unique(cIndx)) == 1
    cIndx = unique(cIndx);
    synana.condition.(conditions{cIndx}).dendrites.fns(indx(:,1)) = [];
    synana.condition.(conditions{cIndx}).dendrites.fpaths(indx(:,1)) = [];
    
    
end
updateinfo()
end

function newcondition()
global synana;

conditionName = inputdlg('New Condition Name','New Condition Name');
[fns,fpaths] = uigetfile('MultiSelect','On');

if iscell(fns)
    for i = 1:length(fns)
        fn = fns{i};
        fn = fn(1:end-4);
        fullPaths{i} = char([fpaths fn]);
        fileNames{i}  = fn;
    end
elseif ~iscell(fns)
    disp('Error, please select >1 dendrite when initializing a new condition');
    return
end

synana.condition.(char(conditionName)).dendrites.fns = fileNames;
synana.condition.(char(conditionName)).dendrites.fpaths = fullPaths;

updateinfo()

end

function updateinfo()
global synana;


counter = 1;
dendritesByAnimalColumnNames = {};

dendritesByAnimalData = {};
numConditions = length(fields(synana.condition));
conditions = fields(synana.condition);
if isempty(fields(synana.condition))
    set(synana.gh.currentHandles.dendritesByConditionTable,'Data',[],'ColumnName',[])
else
    for i = 1:numConditions
        conditionColumnNames{i} = conditions{i};
        dendriteDim = size(synana.condition.(conditions{i}).dendrites.fns);
        numDendrites = dendriteDim(2);
        
        for j = 1:numDendrites
            dendritesByConditionData(j,i) = synana.condition.(conditions{i}).dendrites.fns(j);
        end
        
        set(synana.gh.currentHandles.dendritesByConditionTable,'Data',dendritesByConditionData,'ColumnName',conditionColumnNames);
        
        if ~isfield(synana.condition.(conditions{i}),'animals')
        elseif isfield(synana.condition.(conditions{i}),'animals')
            numAnimals = length(fields(synana.condition.(conditions{i}).animals));
            animalsByConditionData(1:numAnimals,i) = fields(synana.condition.(conditions{i}).animals);
            set(synana.gh.currentHandles.animalsByConditionTable,'ColumnName',conditionColumnNames,'Data',animalsByConditionData);
            
            animalsInCondition = fields(synana.condition.(conditions{i}).animals);
            numAnimals = length(animalsInCondition);
            dendritesByAnimalColumnNames = [dendritesByAnimalColumnNames fields(synana.condition.(conditions{i}).animals)'];
            
            set(synana.gh.currentHandles.dendritesByAnimalTable,'ColumnName',dendritesByAnimalColumnNames,'Data',dendritesByAnimalData);
            for k = 1:numAnimals
                dendritesInAnimal = synana.condition.(conditions{i}).animals.(animalsInCondition{k}).fns;
                numDend = length(dendritesInAnimal);
                
                for l = 1:numDend
                    dendritesByAnimalData(l,counter) = dendritesInAnimal(l);
                end
                counter = counter +1 ;
            end
            set(synana.gh.currentHandles.dendritesByAnimalTable,'Data',dendritesByAnimalData);
            
            
            
        end
        
        
    end
    
end

if isfield(synana,'plotOpt')
    set(synana.gh.currentHandles.plotOpt,'Data',synana.plotOpt);
    axes(synana.gh.currentHandles.plotAxes');
    cla;
    plotOptIndx = synana.clickIndx.plotOpt(1);
    toPlot = synana.plotOpt(plotOptIndx);
    conditions = fields(synana.condition);
    numConditions = length(conditions);
    for i = 1:numConditions
        hold on;
        colorz = jet;
        colortoplot = colorz(ceil(63/i),:);
        try
            switch synana.totSpineShaft
                case 'Total'
                errorbar(synana.dendriteData.(conditions{i}).group.total.(toPlot{1}).avg,...
            synana.dendriteData.(conditions{i}).group.total.(toPlot{1}).ste,'Color',colortoplot);
                case 'Spine'
                errorbar(synana.dendriteData.(conditions{i}).group.spines.(toPlot{1}).avg,...
            synana.dendriteData.(conditions{i}).group.total.(toPlot{1}).ste,'Color',colortoplot);
                case 'Shaft'
                    errorbar(synana.dendriteData.(conditions{i}).group.shafts.(toPlot{1}).avg,...
            synana.dendriteData.(conditions{i}).group.total.(toPlot{1}).ste,'Color',colortoplot);
                
            end
        
            end
    end
    
else
end
legend(conditions);
grid on;
end

function adddendrites()
global synana;
conditions = fields(synana.condition);
indx = synana.clickIndx.dendritesByConditionTable;
indx = indx(:,2);
if length(unique(indx)) > 1
    disp('Error, only select one condition at a time');
else
    
    [fns,fpaths] = uigetfile('Add group files: ','MultiSelect','On');
    
    if iscell(fns)
        for i = 1:length(fns)
            fn = fns{i};
            fn = fn(1:end-4);
            fullPaths{i} = char([fpaths fn]);
            fileNames{i}  = fn;
        end
        
    elseif ischar(fns)
        fullPaths{1} = char([fpaths fns(1:end-4)]);
        fileNames{1} = fns(1:end-4);
    elseif fns == 0
        return;
    end
    
    
    
    currentCondition = conditions{indx};
    synana.condition.(currentCondition).dendrites.fns = [synana.condition.(currentCondition).dendrites.fns fileNames];
    synana.condition.(currentCondition).dendrites.fpaths = [synana.condition.(currentCondition).dendrites.fpaths fullPaths];
    
    updateinfo()
end

end

function returndata()
global synana;
conditions = synana.condition;

dendriteData = returndendritedata(conditions);
assignin('base','dendriteData',dendriteData);
synana.dendriteData = dendriteData;

    try
    animalData = returnanimaldata(conditions);
    synana.animalData = animalData;
    assignin('base','animalData',animalData);

    catch
        ;
    end

updateinfo();

calcDispMeta(dendriteData);

end

function dendriteData = returndendritedata(conditions)
numConditions = length(fields(conditions));
conNames = fields(conditions);
for i = 1:numConditions
    indCond = conNames{i};
    dendrites = conditions.(indCond).dendrites;
    dendriteData.(indCond) = createdendriteconditiondataset(dendrites);
end
end

function indCond = createdendriteconditiondataset(dendrites)

fileNames = dendrites.fns;
filePaths = dendrites.fpaths;

for i = 1:length(fileNames)
    dendrite = fileNames{i};
    if strcmp(dendrite(end-3:end),'.syn')
        dendriteName = dendrite(1:end-4);
    else
        dendriteName = dendrite;
        disp(['Resave ' dendriteName 'with .syn']);
        
    end
    indCond.(dendriteName).fn = fileNames(i);
    
    
    
    currentDendrite = [filePaths{i} '.mat'];
    
    currentDendrite = load(currentDendrite,'-mat');
    originalScoringData = currentDendrite.scoringData;
    
    scoringData = genericCleanScoringData(originalScoringData);
    indCond.(dendriteName).scoringData = scoringData;
    
    [indCond.(dendriteName).dynamics,indCond.(dendriteName).data] = jbm_processSynapseMatrix(scoringData.synapseMatrix,'2.3',scoringData);
    dynamicsFields = fields(indCond.(dendriteName).dynamics.total);
    numDynamicsFields = length(dynamicsFields);
    putativeGroupFields = fields(indCond.(dendriteName).dynamics);
    putativeNumGroups = length(putativeGroupFields);
    
    
    for m = 1:3
        for j = 1:numDynamicsFields
            
            try
            indCond.group.(putativeGroupFields{m}).(dynamicsFields{j}).mtx(i,:) = indCond.(dendriteName).dynamics.(putativeGroupFields{m}).(dynamicsFields{j});
            catch
               % if dendrite to be added is larger
               dendLength = length(indCond.(dendriteName).dynamics.(putativeGroupFields{m}).(dynamicsFields{j}));
               mtxDim = size(indCond.group.(putativeGroupFields{m}).(dynamicsFields{j}).mtx);
               mtxLength = mtxDim(2);
               
               if dendLength < mtxLength
                   nanPatched = nan(1,mtxLength);
                   nanPatched(1:dendLength) = indCond.(dendriteName).dynamics.(putativeGroupFields{m}).(dynamicsFields{j});
                   indCond.group.(putativeGroupFields{m}).(dynamicsFields{j}).mtx(i,:) = nanPatched;
                   
               elseif dendLength > mtxLength
                   disp('ERROR MISMATCH DENDRITE LARGER THAN MTX! FIX THIS BUG FOOL!')
                
               end
               %%
               % 
               % $$e^{\pi i} + 1 = 0$$
               % 
                
            end
            
        end
    end
    
    miscFields = fields(indCond.(dendriteName).dynamics.misc);
    numMiscFields = length(miscFields);
    for l = 1:numMiscFields
       
        try
            indCond.group.misc.(miscFields{l}).mtx(i,:) = indCond.(dendriteName).dynamics.misc.(miscFields{l});
            
        catch
            
        end
        
    end
    
end

groupFields = fields(indCond.group);
numGroups = length(groupFields);
for k = 1:3
    for l = 1:numDynamicsFields
        indCond.group.(groupFields{k}).(dynamicsFields{l}).avg = nanmean(indCond.group.(groupFields{k}).(dynamicsFields{l}).mtx);
        synmtx2 = indCond.group.(groupFields{k}).(dynamicsFields{l}).mtx;
        synmtx2 = ~isnan(synmtx2);
        sampleSize = sum(synmtx2,1);
        
        indCond.group.(groupFields{k}).(dynamicsFields{l}).ste = nanstd(indCond.group.(groupFields{k}).(dynamicsFields{l}).mtx)./sqrt(sampleSize);
%         indCond.group.(groupFields{k}).(dynamicsFields{l}).ste = nanstd(indCond.group.(groupFields{k}).(dynamicsFields{l}).mtx)/sqrt(length(fileNames));
        
        indCond.group.(groupFields{k}).(dynamicsFields{l}).std = nanstd(indCond.group.(groupFields{k}).(dynamicsFields{l}).mtx);
        
        
    end
end
global synana
synana.plotOpt = dynamicsFields;
end

function animalData = returnanimaldata(conditions)
numConditions = length(fields(conditions));
conNames = fields(conditions);
for i = 1:numConditions
    indCond = conNames{i};
    animals = conditions.(indCond).animals;
    animalData.(indCond) = createanimalconditiondataset(animals);
end

end

function indCond = createanimalconditiondataset(animals)
animalNames = fields(animals);
numAnimals = length(animalNames);

for i = 1:numAnimals
    fileNames = animals.(animalNames{i}).fns;
    filePaths = animals.(animalNames{i}).fpaths;
    animalName = animalNames{i}
    
    compositeSynapseMatrix = [];
    
    for j = 1:length(fileNames)
        dendrite = fileNames{j};
        if strcmp(dendrite(end-3:end),'.syn')
            dendriteName = dendrite(1:end-4);
        else
            dendriteName = dendrite;
            disp(['Resave ' dendriteName 'with .syn']);

        end
        currentDendrite = [filePaths{j} '.mat'];
    
        currentDendrite = load(currentDendrite,'-mat');
        originalScoringData = currentDendrite.scoringData;
    
        scoringData = genericCleanScoringData(originalScoringData);
        dendriticSynapseMatrix = scoringData.synapseMatrix;
        compositeSynapseMatrix = vertcat(compositeSynapseMatrix,dendriticSynapseMatrix);
        
  
    end
    [indCond.(animalName).dynamics,indCond.(animalName).data] = jbm_processSynapseMatrix(...
        compositeSynapseMatrix,'2.3');
    
    
    
    
    dynamicsFields = fields(indCond.(animalName).dynamics.total);
    numDynamicsFields = length(dynamicsFields);
    putativeGroupFields = fields(indCond.(animalName).dynamics);
    putativeNumGroups = length(putativeGroupFields);
    for m = 1:putativeNumGroups
        for j = 1:numDynamicsFields
            
            indCond.group.(putativeGroupFields{m}).(dynamicsFields{j}).mtx(i,:) = indCond.(animalName).dynamics.total.(dynamicsFields{j});
            
            
        end
    end
    
    
end
groupFields = fields(indCond.group);
numGroups = length(groupFields);
for k = 1:numGroups
    for l = 1:numDynamicsFields
        indCond.group.(groupFields{k}).(dynamicsFields{l}).avg = mean(indCond.group.total.(dynamicsFields{l}).mtx);
        indCond.group.(groupFields{k}).(dynamicsFields{l}).ste = std(indCond.group.total.(dynamicsFields{l}).mtx)/sqrt(length(fileNames));
        indCond.group.(groupFields{k}).(dynamicsFields{l}).std = std(indCond.group.total.(dynamicsFields{l}).mtx);
        
        
    end
end
global synana
synana.plotOpt = dynamicsFields;

end

function calcDispMeta(dendriteData)
numConditions = length(fields(dendriteData));
conditions = fields(dendriteData);
metaInfo.grandTotal.totalSyn = 0;
metaInfo.grandTotal.numSpine = 0;
metaInfo.grandTotal.numShaft = 0;
metaInfo.grandTotal.lengthScored=  0;

for i = 1:numConditions
    metaInfo.(conditions{i}).totalSyn =0    ;
    metaInfo.(conditions{i}).numSpine = 0;
    metaInfo.(conditions{i}).numShaft = 0;
    metaInfo.(conditions{i}).totalLengthInMicrons = 0;

    condition = dendriteData.(conditions{i});
    condition = rmfield(condition,'group');
    dendrites = fields(condition);
    numDendrites = length(dendrites);
    for j = 1:numDendrites
        dendrite = condition.(dendrites{j});
        dendriteTotalSyn = size(dendrite.data.synapseMatrix,1);
        dendriteNumSpine = size(dendrite.data.spineMatrix,1);
        dendriteNumShaft = size(dendrite.data.shaftMatrix,1);
        
        if dendriteTotalSyn < (dendriteNumSpine+dendriteNumShaft)
            disp(dendrites{j});
        else
        end
        
        try
        tD = dendrite.scoringData.skeleton.tracingData{1};
        dendriteLength = max(tD.skeletonInMicron(:,4));
        catch
            dendriteLength = 0;
            disp([dendrites{j} 'LACKS LENGTH']);
        end
        metaInfo.(conditions{i}).totalSyn =  metaInfo.(conditions{i}).totalSyn + dendriteTotalSyn   ;
    metaInfo.(conditions{i}).numSpine =     metaInfo.(conditions{i}).numSpine + dendriteNumSpine;

    metaInfo.(conditions{i}).numShaft = metaInfo.(conditions{i}).numShaft + dendriteNumShaft;
    metaInfo.(conditions{i}).totalLengthInMicrons = metaInfo.(conditions{i}).totalLengthInMicrons + dendriteLength;
        
        
        
        
        
    end
    metaInfo.grandTotal.totalSyn = metaInfo.grandTotal.totalSyn + metaInfo.(conditions{i}).totalSyn;
    metaInfo.grandTotal.numSpine = metaInfo.grandTotal.numSpine + metaInfo.(conditions{i}).numSpine;
    metaInfo.grandTotal.numShaft = metaInfo.grandTotal.numShaft + metaInfo.(conditions{i}).numShaft;
    metaInfo.grandTotal.lengthScored = metaInfo.grandTotal.lengthScored + metaInfo.(conditions{i}).totalLengthInMicrons;

end
assignin('base','metaDendriteInfo',metaInfo);
end









% ARCHIVE
% % % %     data = scoringData;
% % % %     data.presenceMatrix = data.synapseMatrix>0;
% % % %     Aout.(condition).(dendrite).metrics = h_routinesForInVivoAnalysis(1:4,data,0);
% % % %     Aout.(condition).(dendrite).presenceMatrix = data.presenceMatrix;
% % % %
% % % %     % Spine Metrics
% % % %     synapseMatrix = scoringData.synapseMatrix;
% % % %     [synapseIndex,timepointIndex] = find(synapseMatrix == 2);
% % % %     synapseIndex = unique(synapseIndex);
% % % %     spineData.presenceMatrix = synapseMatrix(synapseIndex,:);
% % % %     spineData.presenceMatrix = spineData.presenceMatrix > 0;
% % % %     Aout.(condition).(dendrite).spineMetrics = h_routinesForInVivoAnalysis(1:4,spineData,0);
% % % %     Aout.(condition).(dendrite).spinePresenceMatrix = spineData.presenceMatrix;
% % % %
% % % %     % Shaft Metrics
% % % %     shaftData.presenceMatrix = synapseMatrix;
% % % %     shaftData.presenceMatrix(synapseIndex,:) = [];
% % % %     [redOnlyIndex,tpIndx] = find(shaftData.presenceMatrix == 4); % Ignore spine only category right now
% % % %     redOnlyIndex = unique(redOnlyIndex);
% % % %     shaftData.presenceMatrix(redOnlyIndex,:) = [];
% % % %     shaftData.presenceMatrix = shaftData.presenceMatrix > 0;
% % % %     Aout.(condition).(dendrite).shaftMetrics = h_routinesForInVivoAnalysis(1:4,shaftData,0);
% % % %     Aout.(condition).(dendrite).shaftPresenceMatrix = shaftData.presenceMatrix;
% % % %
% % % %
% % % %     % JBM MODS
% % % %     Aout.(condition).(dendrite).metrics.normDens = ...
% % % %     Aout.(condition).(dendrite).metrics.synapseNum / ...
% % % %     Aout.(condition).(dendrite).metrics.synapseNum(1);
% % % %
% % % %     Aout.(condition).(dendrite).metrics.normElim = ...
% % % %         Aout.(condition).(dendrite).metrics.elimination ./ ...
% % % %         Aout.(condition).(dendrite).metrics.synapseNum(1:end-1);
% % % %
% % % %      Aout.(condition).(dendrite).metrics.normAdd = ...
% % % %         Aout.(condition).(dendrite).metrics.addition ./ ...
% % % %         Aout.(condition).(dendrite).metrics.synapseNum(2:end);
% % % %
% % % %     Aout.(condition).(dendrite).metrics.TOR = ...
% % % %         (Aout.(condition).(dendrite).metrics.addition + Aout.(condition).(dendrite).metrics.elimination) ./ ...
% % % %         (2*(Aout.(condition).(dendrite).metrics.addition + Aout.(condition).(dendrite).metrics.synapseNum(1:end-1)));
% % % %
% % % %
% % % %     % JBM MODS FOR SPINES
% % % %     Aout.(condition).(dendrite).spineMetrics.normDens = ...
% % % %     Aout.(condition).(dendrite).spineMetrics.synapseNum / ...
% % % %     Aout.(condition).(dendrite).spineMetrics.synapseNum(1);
% % % %
% % % %     Aout.(condition).(dendrite).spineMetrics.normElim = ...
% % % %         Aout.(condition).(dendrite).spineMetrics.elimination ./ ...
% % % %         Aout.(condition).(dendrite).spineMetrics.synapseNum(1:end-1);
% % % %
% % % %      Aout.(condition).(dendrite).spineMetrics.normAdd = ...
% % % %         Aout.(condition).(dendrite).spineMetrics.addition ./ ...
% % % %         Aout.(condition).(dendrite).spineMetrics.synapseNum(2:end);
% % % %
% % % %     Aout.(condition).(dendrite).spineMetrics.TOR = ...
% % % %         (Aout.(condition).(dendrite).spineMetrics.addition + Aout.(condition).(dendrite).spineMetrics.elimination) ./ ...
% % % %         (2*(Aout.(condition).(dendrite).spineMetrics.addition + Aout.(condition).(dendrite).spineMetrics.synapseNum(1:end-1)));
% % % %
% % % %     %JBM MODS FOR SHAFTS
% % % %     Aout.(condition).(dendrite).shaftMetrics.normDens = ...
% % % %     Aout.(condition).(dendrite).shaftMetrics.synapseNum / ...
% % % %     Aout.(condition).(dendrite).shaftMetrics.synapseNum(1);
% % % %
% % % %     Aout.(condition).(dendrite).shaftMetrics.normElim = ...
% % % %         Aout.(condition).(dendrite).shaftMetrics.elimination ./ ...
% % % %         Aout.(condition).(dendrite).shaftMetrics.synapseNum(1:end-1);
% % % %
% % % %      Aout.(condition).(dendrite).shaftMetrics.normAdd = ...
% % % %         Aout.(condition).(dendrite).shaftMetrics.addition ./ ...
% % % %         Aout.(condition).(dendrite).shaftMetrics.synapseNum(2:end);
% % % %
% % % %     Aout.(condition).(dendrite).shaftMetrics.TOR = ...
% % % %         (Aout.(condition).(dendrite).shaftMetrics.addition + Aout.(condition).(dendrite).shaftMetrics.elimination) ./ ...
% % % %         (2*(Aout.(condition).(dendrite).shaftMetrics.addition + Aout.(condition).(dendrite).shaftMetrics.synapseNum(1:end-1)));
% % %
% % %
% % %
% % %     % Shaft MTX
% % %     Aout.(condition).shaftGroup.shaftMtx.survivalFcn(ii,:) = Aout.(condition).(dendrite).shaftMetrics.survivalFcn;
% % %     Aout.(condition).shaftGroup.shaftMtx.normDens(ii,:) = Aout.(condition).(dendrite).shaftMetrics.normDens;
% % %     Aout.(condition).shaftGroup.shaftMtx.normAdd(ii,:) = Aout.(condition).(dendrite).shaftMetrics.normAdd;
% % %     Aout.(condition).shaftGroup.shaftMtx.normElim(ii,:) = Aout.(condition).(dendrite).shaftMetrics.normElim;
% % %     Aout.(condition).shaftGroup.shaftMtx.percentDynamic(ii,:) = Aout.(condition).(dendrite).shaftMetrics.normAdd + Aout.(condition).(dendrite).shaftMetrics.normElim;
% % %     Aout.(condition).shaftGroup.shaftMtx.TOR(ii,:) = Aout.(condition).(dendrite).shaftMetrics.TOR;
% % %     Aout.(condition).shaftGroup.shaftMtx.lifetimes(ii,:) = calculateSynapseLifetimes(Aout.(condition).(dendrite).shaftPresenceMatrix);
% % %
% % %     % Spine MTX
% % %     Aout.(condition).spineGroup.spineMtx.survivalFcn(ii,:) = Aout.(condition).(dendrite).spineMetrics.survivalFcn;
% % %     Aout.(condition).spineGroup.spineMtx.normDens(ii,:) = Aout.(condition).(dendrite).spineMetrics.normDens;
% % %     Aout.(condition).spineGroup.spineMtx.normAdd(ii,:) = Aout.(condition).(dendrite).spineMetrics.normAdd;
% % %     Aout.(condition).spineGroup.spineMtx.normElim(ii,:) = Aout.(condition).(dendrite).spineMetrics.normElim;
% % %     Aout.(condition).spineGroup.spineMtx.percentDynamic(ii,:) = Aout.(condition).(dendrite).spineMetrics.normAdd + Aout.(condition).(dendrite).spineMetrics.normElim;
% % %     Aout.(condition).spineGroup.spineMtx.TOR(ii,:) = Aout.(condition).(dendrite).spineMetrics.TOR;
% % %     Aout.(condition).spineGroup.spineMtx.lifetimes(ii,:) = calculateSynapseLifetimes(Aout.(condition).(dendrite).spinePresenceMatrix);
% % %
% % %
% % %     % MTX
% % %     Aout.(condition).group.mtx.survivalFcn(ii,:) = Aout.(condition).(dendrite).metrics.survivalFcn;
% % %     Aout.(condition).group.mtx.normDens(ii,:) = Aout.(condition).(dendrite).metrics.normDens;
% % %     Aout.(condition).group.mtx.normAdd(ii,:) = Aout.(condition).(dendrite).metrics.normAdd;
% % %     Aout.(condition).group.mtx.normElim(ii,:) = Aout.(condition).(dendrite).metrics.normElim;
% % %     Aout.(condition).group.mtx.percentDynamic(ii,:) = Aout.(condition).(dendrite).metrics.normAdd + Aout.(condition).(dendrite).metrics.normElim;
% % %     Aout.(condition).group.mtx.TOR(ii,:) = Aout.(condition).(dendrite).metrics.TOR;
% % %     Aout.(condition).group.mtx.lifetimes(ii,:) = calculateSynapseLifetimes(Aout.(condition).(dendrite).presenceMatrix);
% %
% % end
% %
% % % GROUPINGS
% % Aout.(condition).group.avg.survivalFcn = mean(Aout.(condition).group.mtx.survivalFcn);
% % Aout.(condition).group.avg.normElim =mean(Aout.(condition).group.mtx.normElim);
% % Aout.(condition).group.avg.normAdd =mean(Aout.(condition).group.mtx.normAdd);
% % Aout.(condition).group.avg.normDens =mean(Aout.(condition).group.mtx.normDens);
% % Aout.(condition).group.avg.percentDynamic = mean(Aout.(condition).group.mtx.percentDynamic);
% % Aout.(condition).group.avg.TOR = mean(Aout.(condition).group.mtx.TOR);
% % Aout.(condition).group.avg.lifetimes = mean(Aout.(condition).group.mtx.lifetimes);
% %
% % Aout.(condition).group.std.survivalFcn = std(Aout.(condition).group.mtx.survivalFcn);
% % Aout.(condition).group.std.normElim =std(Aout.(condition).group.mtx.normElim)
% % Aout.(condition).group.std.normAdd =std(Aout.(condition).group.mtx.normAdd)
% % Aout.(condition).group.std.normDens =std(Aout.(condition).group.mtx.normDens)
% % Aout.(condition).group.std.percentDynamic =std(Aout.(condition).group.mtx.percentDynamic)
% % Aout.(condition).group.std.TOR = std(Aout.(condition).group.mtx.TOR)
% % Aout.(condition).group.std.lifetimes = std(Aout.(condition).group.mtx.lifetimes)
% %
% % Aout.(condition).group.ste.survivalFcn = std(Aout.(condition).group.mtx.survivalFcn) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.normElim =std(Aout.(condition).group.mtx.normElim) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.normAdd =std(Aout.(condition).group.mtx.normAdd) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.normDens =std(Aout.(condition).group.mtx.normDens) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.percentDynamic =std(Aout.(condition).group.mtx.percentDynamic) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.TOR =std(Aout.(condition).group.mtx.TOR) / sqrt(length(fileNames));
% % Aout.(condition).group.ste.lifetimes =std(Aout.(condition).group.mtx.lifetimes) / sqrt(length(fileNames));
% %
% %
% % % SPINE GROUPINGS
% % Aout.(condition).spineGroup.avg.survivalFcn = mean(Aout.(condition).spineGroup.spineMtx.survivalFcn);
% % Aout.(condition).spineGroup.avg.normElim =mean(Aout.(condition).spineGroup.spineMtx.normElim);
% % Aout.(condition).spineGroup.avg.normAdd =mean(Aout.(condition).spineGroup.spineMtx.normAdd);
% % Aout.(condition).spineGroup.avg.normDens =mean(Aout.(condition).spineGroup.spineMtx.normDens);
% % Aout.(condition).spineGroup.avg.percentDynamic = mean(Aout.(condition).spineGroup.spineMtx.percentDynamic);
% % Aout.(condition).spineGroup.avg.TOR = mean(Aout.(condition).spineGroup.spineMtx.TOR);
% % Aout.(condition).spineGroup.avg.lifetimes = mean(Aout.(condition).spineGroup.spineMtx.lifetimes);
% %
% % Aout.(condition).spineGroup.std.survivalFcn = std(Aout.(condition).spineGroup.spineMtx.survivalFcn);
% % Aout.(condition).spineGroup.std.normElim =std(Aout.(condition).spineGroup.spineMtx.normElim)
% % Aout.(condition).spineGroup.std.normAdd =std(Aout.(condition).spineGroup.spineMtx.normAdd)
% % Aout.(condition).spineGroup.std.normDens =std(Aout.(condition).spineGroup.spineMtx.normDens)
% % Aout.(condition).spineGroup.std.percentDynamic =std(Aout.(condition).spineGroup.spineMtx.percentDynamic)
% % Aout.(condition).spineGroup.std.TOR = std(Aout.(condition).spineGroup.spineMtx.TOR)
% % Aout.(condition).spineGroup.std.lifetimes = std(Aout.(condition).spineGroup.spineMtx.lifetimes)
% %
% % Aout.(condition).spineGroup.ste.survivalFcn = std(Aout.(condition).spineGroup.spineMtx.survivalFcn) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.normElim =std(Aout.(condition).spineGroup.spineMtx.normElim) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.normAdd =std(Aout.(condition).spineGroup.spineMtx.normAdd) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.normDens =std(Aout.(condition).spineGroup.spineMtx.normDens) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.percentDynamic =std(Aout.(condition).spineGroup.spineMtx.percentDynamic) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.TOR =std(Aout.(condition).spineGroup.spineMtx.TOR) / sqrt(length(fileNames));
% % Aout.(condition).spineGroup.ste.lifetimes =std(Aout.(condition).spineGroup.spineMtx.lifetimes) / sqrt(length(fileNames));
% %
% %
% % % SHAFT GROUPINGS
% %
% % Aout.(condition).shaftGroup.avg.survivalFcn = mean(Aout.(condition).shaftGroup.shaftMtx.survivalFcn);
% % Aout.(condition).shaftGroup.avg.normElim =mean(Aout.(condition).shaftGroup.shaftMtx.normElim);
% % Aout.(condition).shaftGroup.avg.normAdd =mean(Aout.(condition).shaftGroup.shaftMtx.normAdd);
% % Aout.(condition).shaftGroup.avg.normDens =mean(Aout.(condition).shaftGroup.shaftMtx.normDens);
% % Aout.(condition).shaftGroup.avg.percentDynamic = mean(Aout.(condition).shaftGroup.shaftMtx.percentDynamic);
% % Aout.(condition).shaftGroup.avg.TOR = mean(Aout.(condition).shaftGroup.shaftMtx.TOR);
% % Aout.(condition).shaftGroup.avg.lifetimes = mean(Aout.(condition).shaftGroup.shaftMtx.lifetimes);
% %
% % Aout.(condition).shaftGroup.std.survivalFcn = std(Aout.(condition).shaftGroup.shaftMtx.survivalFcn);
% % Aout.(condition).shaftGroup.std.normElim =std(Aout.(condition).shaftGroup.shaftMtx.normElim)
% % Aout.(condition).shaftGroup.std.normAdd =std(Aout.(condition).shaftGroup.shaftMtx.normAdd)
% % Aout.(condition).shaftGroup.std.normDens =std(Aout.(condition).shaftGroup.shaftMtx.normDens)
% % Aout.(condition).shaftGroup.std.percentDynamic =std(Aout.(condition).shaftGroup.shaftMtx.percentDynamic)
% % Aout.(condition).shaftGroup.std.TOR = std(Aout.(condition).shaftGroup.shaftMtx.TOR)
% % Aout.(condition).shaftGroup.std.lifetimes = std(Aout.(condition).shaftGroup.shaftMtx.lifetimes)
% %
% %
% % Aout.(condition).shaftGroup.ste.survivalFcn = std(Aout.(condition).shaftGroup.shaftMtx.survivalFcn) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.normElim =std(Aout.(condition).shaftGroup.shaftMtx.normElim) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.normAdd =std(Aout.(condition).shaftGroup.shaftMtx.normAdd) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.normDens =std(Aout.(condition).shaftGroup.shaftMtx.normDens) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.percentDynamic =std(Aout.(condition).shaftGroup.shaftMtx.percentDynamic) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.TOR =std(Aout.(condition).shaftGroup.shaftMtx.TOR) / sqrt(length(fileNames));
% % Aout.(condition).shaftGroup.ste.lifetimes =std(Aout.(condition).shaftGroup.shaftMtx.lifetimes) / sqrt(length(fileNames));
% %
% %
% % Aout = Aout.(condition)
