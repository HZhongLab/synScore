function jbm_synapsescoringengine(tag,handles)


global jbm;
global h_img3;
global synScore;
global genFluor;

jbm.scoringData.versionInfo.version = '3.0';
jbm.scoringData.versionInfo.conventions = ['\n\n0 = absent \n1 = shaft (blue) \n2 = spine (purple) \n3 = unsure (cyan) \n4 = spine no psd (yellow) \n\n'];

synScore.SHAFT_COLOR = [0 0 1]; % Blue
synScore.SPINE_COLOR = [1 0 1]; % Purple
synScore.UNSURE_COLOR = [0 1 1]; % Cyan
synScore.SPO_COLOR = [1 1 0]; % Yellow

[selectedInstance,handles,currentStruct,currentStructName] = h_getCurrendInd3(handles);
allInstances = fieldnames(h_img3);

isCommonField = find(strcmp(allInstances,'common'));
disp(isCommonField)
if exist('isCommonField')
    allInstances(isCommonField) = [];
else
end

jbm.instancesOpen = allInstances;

switch tag
    case 'focus'
        focus(handles)
    case 'setZ'
        setZ(handles)
    case 'setZAll'
        setZAll(handles)
    case 'load fn'
        loadSynWithFN(handles);
    case 'print conventions'
        printconventions()
    case 'return data'
        returndata();
    case 'edit note'
        editnote(handles);
    case 'create new dataset'
        createnewdataset(handles);
    case 'group load'
        batchgroupload();
    case 'close all instances'
        closeallinstances();
    case 'group zoom alignment'
        groupzoomalignment(GROUP_ZOOM_FACTOR);
    case 'new synapse'
        newsynapse(handles);
    case 'update info'
        updateinfo(handles);
    case 'print notes'
        printnotes();
    case 'update verification'
        updateverification(handles);
    case 'save'
        saveScoringData(handles);
    case 'load'
        loadScoringData(handles)
    case 'updateinfo'
        updateinfo(handles);
    case 'global sync'
        globalsync(handles);
    case 'update skeleton info'
        updateskeletoninfo(handles)
    case 'append skeleton'
        appendskeleton(handles);
    case 'load skeleton data'
        loadskeletondata(handles)
    case 'general note'
        generalnote(handles)
    case 'active plotter'
        activePlotter()
    case 'makebgroi'
        makebgroi(handles)
    case 'generateFluorROIs'
        generateFluorROIs(handles)
    case 'dec_fluorsize'
        dec_fluorsize(handles)
    case 'inc_fluorsize'
        inc_fluorsize(handles)
    case 'finish_fluor'
        finfluor(handles)
    case 'final_fluor_calc'
        finalFluorCalc(handles)
    case 'updateROIcoordinates'
        updateROIcoordinates(handles)
        
    case 'great_synapse'
        greatSynapse(handles)
end

end

%% %%% Fluorescent Intensity 8-9-2018 JBM -- Stanford %%% %%

% 1. Generate your fluorescent rois
function generateFluorROIs(handles)
global jbm;
global h_img3;

updateROIcoordinates(handles);

jbm.default_roi_diameter = 5;

synMatrix = jbm.scoringData.synapseMatrix;

numSyn = size(jbm.knobs,1);
numDays = size(jbm.knobs,2);

try
    fluorDataPresent = ~isempty(jbm.scoringData.fluorData);
catch
    fluorDataPresent = isfield(jbm.scoringData,'fluorData');
end

if ~fluorDataPresent
    disp('DETECTED EMPTY FLUORDATA');
    jbm.scoringData.fluorData = cell(numSyn,numDays);
    for syn = 1:numSyn
        for day=1:numDays
            jbm.scoringData.fluorData{syn,day}.fin = 0;
            jbm.scoringData.fluorData{syn,day}.high_quality = 0;
            
        end
    end
else
end

% Delete previous fluorROIs
if ~isempty(jbm.scoringData.fluorData)
    for i = 1:numSyn
        for j = 1:numDays
            try
                delete(jbm.scoringData.fluorData{i,j}.knob);
            catch
            end
            
            try
                if ~isfield(jbm.scoringData.fluorData{j,i},'fin')
                    jbm.scoringData.fluorData{j,i}.fin = 0;
                end
                
                if ~isfield(jbm.scoringData.fluorData{j,i},'high_quality')
                    jbm.scoringData.fluorData{j,i}.high_quality=0;
                end
            catch
            end
        end
    end
end



for i = 1:numDays
    for j = 1:numSyn
        if jbm.scoringData.synapseMatrix(j,i) ~= 0
            try
                xr = jbm.scoringData.fluorData{j,i}.xr;
                yr = jbm.scoringData.fluorData{j,i}.yr;
                
            catch
                jbm.scoringData.fluorData{j,i}.xr = jbm.default_roi_diameter;
                jbm.scoringData.fluorData{j,i}.yr = jbm.default_roi_diameter;
                jbm.scoringData.fluorData{j,i}.fin = 0;
                jbm.scoringData.fluorData{j,i}.high_quality=0;
                
                xr = jbm.scoringData.fluorData{j,i}.xr;
                yr = jbm.scoringData.fluorData{j,i}.yr;
            end
            
            
            syn = get(jbm.knobs(j,i));
            ud = syn.UserData;
            
            
            xCo = ud.xCo;
            yCo = ud.yCo;
            
            if ~(xCo == jbm.scoringData.roiCoordinates(1,i,j))
                errordlg('DISPARITY IN COORDINATES!');
                keyboard
            end
            
            if ~(yCo == jbm.scoringData.roiCoordinates(2,i,j))
                errordlg('DISPARITY IN COORDAINTES!');
                keyboard
            end
    
            
            zCo = jbm.scoringData.synapseZ(j,i);
    
            
            synDex = j;
            h = jbm_makeFluorROI3(handles,i,xCo,yCo,zCo,synDex,xr,yr);
            
            jbm.scoringData.fluorData{j,i}.knob = h;
            
        else
        end
        
        % If a new synapses is added and you generate more ROIs
%         if ~isfield(jbm.scoringData.fluorData{j,i},'fin')
%             jbm.scoringData.fluorData{j,i}.fin = 0;
%         end
%         
%         if ~isfield(jbm.scoringData.fluorData{j,i},'high_quality')
%             jbm.scoringData.fluorData{j,i}.high_quality=0;
%         end
        
        
    end
end

h_replot3(handles);
updateWeightGUI(handles);

end

function focus(handles)
global jbm;
global h_img3;

if ~isfield(jbm,'currentSynIdx')
    return
end

for day = 1:size(jbm.knobs,2)
    roiobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','fluorROI3');
    scoobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','scoringROI3');
    scoringROITextObj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3, 'Tag', 'scoringROI3text');
    set(roiobj,'visible','off');
    set(scoobj,'visible','off');
    set(scoringROITextObj,'visible','off');
    
    try
        set(jbm.scoringData.fluorData{jbm.currentSynIdx,day}.knob,'visible','on');
        % Haining adjust z to the particular synapse
        handles = h_img3.(jbm.instancesOpen{day}).gh.currentHandles;
        synZ = round(jbm.scoringData.synapseZ(jbm.currentSynIdx,day));
        set(handles.zStackStrLow, 'String', num2str(synZ));
        set(handles.zStackStrHigh, 'String', num2str(synZ));
        h_zStackQuality3(handles);
        h_replot3(handles);
    catch
    end
    
    
end
set(jbm.knobs(jbm.currentSynIdx,:),'visible','on');
set(jbm.textKnobs(jbm.currentSynIdx,:),'visible','on');
end

function setZAll(handles)
global jbm;
global h_img3;
global progressViewJBM;

for day = 1:size(jbm.knobs,2)
    if jbm.scoringData.synapseMatrix(jbm.currentSynIdx,day) ~= 0
        zHi = get(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.zStackStrHigh,'String');
        zLo = get(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.zStackStrLow,'String');
        zHi = str2num(zHi);
        zLo = str2num(zLo);
        plane = mean([zHi zLo]);
        jbm.scoringData.synapseZ(jbm.currentSynIdx,day) = plane;
        h_replot3(handles);
    else
    end
end

finfluor(handles);

for day = 1:size(jbm.knobs,2)
    roiobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','fluorROI3');
    scoobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','scoringROI3');
    scoringROITextObj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3, 'Tag', 'scoringROI3text');
    set(roiobj,'visible','on');
    set(scoobj,'visible','on');
    set(scoringROITextObj,'visible','on');
end


tog = progressViewJBM;

if tog == 1
    for day = 1:size(jbm.knobs,2)
        for syn = 1:size(jbm.knobs,1)
            try
                if jbm.scoringData.fluorData{syn,day}.fin == 1
                    set(jbm.scoringData.fluorData{syn,day}.knob,'visible','off');
                else
                end
                
              
            catch
            end
        end
    end
    
else
end

updateWeightGUI(handles);
end

function finfluor(handles)
global jbm;
for i = 1:size(jbm.knobs,2)
    jbm.scoringData.fluorData{jbm.currentSynIdx,i}.fin = 1;
    
end
h_replot3(handles);
end

function makebgroi(handles)
    global jbm;
    global h_img3;
    for day = 1:size(jbm.knobs,2)
        if ~isempty(jbm.scoringData.bgFluorData)
            try
                th = get(jbm.scoringData.bgFluorData{day}.knob,'UserData');
                th = th.texthandle;
                delete(th);
                delete(jbm.scoringData.bgFluorData{day}.knob);
                
            catch
            end
            
        else
        end
        
        jbm.scoringData.bgFluorData{day} = [];
    end
    
    % Go through and click on region without any signal 
    for day = 1:size(jbm.knobs,2)
        currentFigure = h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3;
        figure(currentFigure);
                
        zHi = get(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.zStackStrHigh,'String');
        zLo = get(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.zStackStrLow,'String');
        zHi = str2num(zHi);
        zLo = str2num(zLo);
        plane = mean([zHi zLo]);
        zCo = plane;
        
        
        aout = jbm_makeBGROI3(handles);
        aout.roiZ = plane;
        
        
        jbm.scoringData.bgFluorData{day} = aout;
    end
    
    updateWeightGUI(handles);
end

function updateWeightGUI(handles)
% print synaptic weight roi number
global h_img3;
global jbm;

updateROIcoordinates(handles);
for i = 1:length(jbm.instancesOpen)
    imageAxes = h_img3.(jbm.instancesOpen{i}).gh.currentHandles.imageAxes;
    selectedROI = findobj(imageAxes,'Selected','on');
    
    
    if ~isempty(selectedROI)
        [syn_num,~] = find(jbm.knobs == selectedROI);
        jbm.currentSynIdx = syn_num;
        syn_num = num2str(jbm.scoringData.synapseID{syn_num});
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syn_num_static,'String',syn_num)
        
        if jbm.scoringData.fluorData{jbm.currentSynIdx,i}.fin == 1
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.set_z_all_push,'Enable','off');
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.unfinalize_push,'Enable','on');
        else
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.set_z_all_push,'Enable','on');
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.unfinalize_push,'Enable','off');
            
        end
        
        if jbm.scoringData.fluorData{jbm.currentSynIdx,i}.high_quality == 1
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.great_synapse,'Enable','off');
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.notgreatpush,'Enable','on');
        else
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.great_synapse,'Enable','on');
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.notgreatpush,'Enable','off');
            
        end
    else
        syn_num = 'n/a';
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syn_num_static,'String',syn_num);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.great_synapse,'Enable','on');
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.notgreatpush,'Enable','off');
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.set_z_all_push,'Enable','on');
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.unfinalize_push,'Enable','off');
        
    end
end

synMatrix = jbm.scoringData.synapseMatrix;

numSyn = size(jbm.scoringData.fluorData,1);
numDays = size(jbm.scoringData.fluorData,2);

all_finished = 1;
for s = 1:numSyn
    for d = 1:numDays
        if ~isfield(jbm.scoringData.fluorData{s,d},'fin')
            all_finished = 0;
        elseif jbm.scoringData.fluorData{s,d}.fin == 0 || isempty(jbm.scoringData.bgFluorData)
            all_finished = 0;
        end
    end
end

if all_finished == 1
    
    for i = 1:length(jbm.instancesOpen)
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.calc_push,'Enable','on');
    end
else
    
    for i = 1:length(jbm.instancesOpen)
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.calc_push,'Enable','off');
    end
end


end

function finalFluorCalc(handles)

global jbm;

synMatrix = jbm.scoringData.synapseMatrix;

numSyn = size(jbm.knobs,1);
numDays = size(jbm.knobs,2);


% Delete previous fluorROIs
for i = 1:numDays
    for j = 1:numSyn
        try
            delete(jbm.scoringData.fluorData{j,i}.knob);
        catch
        end
    end
end

for i = 1:numDays
    for j = 1:numSyn
        if jbm.scoringData.synapseMatrix(j,i) ~= 0
            if isfield(jbm.scoringData.fluorData{j,i},'xr')
                xr = jbm.scoringData.fluorData{j,i}.xr;
                yr = jbm.scoringData.fluorData{j,i}.yr;
            else
                jbm.scoringData.fluorData{j,i}.xr = jbm.default_roi_diameter;
                jbm.scoringData.fluorData{j,i}.yr = jbm.default_roi_diameter;
                xr = jbm.scoringData.fluorData{j,i}.xr;
                yr = jbm.scoringData.fluorData{j,i}.yr;
            end
            
            syn = get(jbm.knobs(j,i));
            ud = syn.UserData;
            
            xCo = ud.xCo;
            yCo = ud.yCo;
            zCo = jbm.scoringData.synapseZ(j,i);
            
            if isfield(jbm.scoringData.fluorData{j,i}, 'high_quality')
                high_quality = jbm.scoringData.fluorData{j,i}.high_quality;
            else
                high_quality = 0;
            end
            
            if ~isfield(jbm.scoringData.fluorData{j,i},'fin')
                msg = ['Error: Synapse with index: ' j ' is not finished'];
                title = 'SYNAPSES NOT FINALIZED!';
                f = errordlg(msg);

                fin = 0

            else
                fin = jbm.scoringData.fluorData{j,i}.fin;
            end
            synDex = j;

            depthRadii = 3;
            aout = jbm_makeAndCalcROI3(handles,i,xCo,yCo,zCo,xr,yr,high_quality,fin,depthRadii);

            
            jbm.scoringData.fluorData{j,i} = aout;
            
                
            
        else
        end
    end
end

h_replot3(handles);

end

function greatSynapse(handles)
global jbm
global h_img3
for i = 1:size(jbm.knobs,2)
    jbm.scoringData.fluorData{jbm.currentSynIdx,i}.high_quality = 1;
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.great_synapse,'Enable','off');

end
h_replot3(handles);
updateinfo(handles);
end

%% %%% Synapse Scoring -- OHSU %%% %%

function printconventions()
global jbm;
fprintf(jbm.scoringData.versionInfo.conventions);
end

function editnote(handles)
global h_img3;
global jbm;

currentInstance = h_getCurrendInd3(handles);
currentInstance = jbm.instancesOpen{currentInstance};
noteConfirm = h_img3.(currentInstance).gh.currentHandles.synapseNoteConfirm;
noteField = h_img3.(currentInstance).gh.currentHandles.synapseNoteField;
noteEdit = h_img3.(currentInstance).gh.currentHandles.noteEdit;

set(noteField,'Enable','on','BackgroundColor','g');
set(noteConfirm,'Enable','on','BackgroundColor','g');
set(noteEdit,'Enable','off');
obj = findobj(h_img3.(currentInstance).gh.currentHandles.imageAxes,'Selected','on');
if isempty(obj)
    return
else
end
[tempX, tempY] = find(jbm.knobs == obj);



waitfor(noteConfirm,'Value',1);
userInputNote = get(noteField,'String');



jbm.scoringData.synapseNotes{tempX,tempY} = userInputNote;

set(h_img3.(currentInstance).gh.currentHandles.synapseNoteField,'Enable','off','BackgroundColor',[.941 .941 .941],'Value',0);
set(h_img3.(currentInstance).gh.currentHandles.synapseNoteConfirm,'Enable','off','BackgroundColor',[.941 .941 .941],'Value',0);

updateinfo(handles);

end

function returndata(~)
global jbm;

assignin('base','currentScoringData',jbm.scoringData);
assignin('base','currentSynapseMatrix',jbm.scoringData.synapseMatrix);
% assignin('base','currentSynapseNotes',jbm.scoringData.synapseNotes);
assignin('base','currentSynapseIDs',jbm.scoringData.synapseID);
disp('SCORING METADATA (currentScoringData):')
disp(jbm.scoringData)
disp('SYNAPSE MATRIX (Synapse ID // currentSynapseMatrix):');
[numSyn,numTP] = size(jbm.scoringData.synapseMatrix);


displayMatrix = zeros(numSyn,numTP+1);
for i = 1:numSyn
    displayMatrix(i,1) = str2num(jbm.scoringData.synapseID{i});
end

displayMatrix(:,2:end) = jbm.scoringData.synapseMatrix;

disp(displayMatrix)


end

function saveScoringData(handles)
global jbm;
try
    
    updateROIcoordinates(handles);
end
scoringData = jbm.scoringData;
numInst = length(jbm.instancesOpen);
if numInst == sum(scoringData.synapseVerification)
    
    uisave('scoringData',char(jbm.scoringData.datasetName));
else
    warndlg('NOT ALL TIMEPOINTS VERIFIED!')
    
    uisave('scoringData',['UNVERIFIED_' char(jbm.scoringData.datasetName)]);
    
end


end

function loadSynWithFN(handles)
global genFluor
synPath = genFluor.synPath;

global jbm;
temp = 'True'
global h_img3;
if strcmp(temp,'True') % Hacky as fuck
    
    filePath = synPath;
    temp = load(filePath,'-mat');
    
    if isfield(jbm,'scoringData')
        choice = 'Load'
        switch choice
            case 'Load'
                knobs = jbm.knobs;
                textKnobs = jbm.textKnobs;
                knobs = knobs(knobs~=0);
                textKnobs = textKnobs(textKnobs~=0);
                for ii = 1:numel(knobs) %Haining: do it one by one to prevent an error preventing deletion of others.
                    try delete(knobs(ii));catch,end%sometimes the ROI has been deleted by other methods,and this cause errors.
                end
                for ii = 1:numel(knobs) %Haining: do it one by one to prevent an error preventing deletion of others.
                    try delete(textKnobs(ii));catch,end
                end
                
                
                
                jbm.knobs = [];
                jbm.textKnobs = [];
                jbm.scoringData = temp.scoringData;
                
                
            case 'Go back'
                return
        end
    else %add by HN so that one don't need to initialize jbm global variable to load.
        jbm.knobs = [];
        jbm.textKnobs = [];
        jbm.scoringData = temp.scoringData;
    end
    
    dataDimensions = size(jbm.scoringData.synapseMatrix);
    numSyn = dataDimensions(1);
    numTP = dataDimensions(2);
    % tic
    % for iSyn = 1:numSyn
    %     for jTP = 1:numTP
    for jTP = 1:numTP % it is faster without keep changing axes.
        for iSyn = 1:numSyn
            ax = h_img3.(jbm.instancesOpen{jTP}).gh.currentHandles.imageAxes;
            xCo = jbm.scoringData.roiCoordinates(1,jTP,iSyn);
            yCo = jbm.scoringData.roiCoordinates(2,jTP,iSyn);
            synID = jbm.scoringData.synapseID{iSyn};
            
            jbm.knobs(iSyn,jTP) = drawscoringroi(ax,xCo,yCo,synID,[0 0 0]);
            UData = get(jbm.knobs(iSyn,jTP),'UserData');
            jbm.textKnobs(iSyn,jTP) = UData.texthandle;
            
        end
    end
    % toc
    
    colorScheme = get(h_img3.I1.gh.currentHandles.scoringColorScheme,'Value');
    if colorScheme == 1
        updatecolorscheme('+/-',handles);
    elseif colorScheme == 0
        updatecolorscheme('default',handles);
    else
    end
    
    updateinfo(handles);
    
    
end
end

function loadScoringData(handles)

global jbm;

global h_img3;
[fn pn] = uigetfile();
if fn~=0
    filePath = [pn fn];
    temp = load(filePath,'-mat');
    
    if isfield(jbm,'scoringData')
        choice = questdlg('Loading a dataset will delete any unsaved data. Are you sure you wish to proceed?',...
            'Load','Load','Go back','Go back');
        switch choice
            case 'Load'
                knobs = jbm.knobs;
                textKnobs = jbm.textKnobs;
                knobs = knobs(knobs~=0);
                textKnobs = textKnobs(textKnobs~=0);
                for ii = 1:numel(knobs) %Haining: do it one by one to prevent an error preventing deletion of others.
                    try delete(knobs(ii));catch,end%sometimes the ROI has been deleted by other methods,and this cause errors.
                end
                for ii = 1:numel(knobs) %Haining: do it one by one to prevent an error preventing deletion of others.
                    try delete(textKnobs(ii));catch,end
                end
                
                
                
                jbm.knobs = [];
                jbm.textKnobs = [];
                jbm.scoringData = temp.scoringData;
                
                
            case 'Go back'
                return
        end
    else %add by HN so that one don't need to initialize jbm global variable to load.
        jbm.knobs = [];
        jbm.textKnobs = [];
        jbm.scoringData = temp.scoringData;
    end
    
    dataDimensions = size(jbm.scoringData.synapseMatrix);
    numSyn = dataDimensions(1);
    numTP = dataDimensions(2);
    % tic
    % for iSyn = 1:numSyn
    %     for jTP = 1:numTP
    for jTP = 1:numTP % it is faster without keep changing axes.
        for iSyn = 1:numSyn
            ax = h_img3.(jbm.instancesOpen{jTP}).gh.currentHandles.imageAxes;
            xCo = jbm.scoringData.roiCoordinates(1,jTP,iSyn);
            yCo = jbm.scoringData.roiCoordinates(2,jTP,iSyn);
            synID = jbm.scoringData.synapseID{iSyn};
            
            jbm.knobs(iSyn,jTP) = drawscoringroi(ax,xCo,yCo,synID,[0 0 0]);
            UData = get(jbm.knobs(iSyn,jTP),'UserData');
            jbm.textKnobs(iSyn,jTP) = UData.texthandle;
            
        end
    end
    % toc
    
    colorScheme = get(h_img3.I1.gh.currentHandles.scoringColorScheme,'Value');
    if colorScheme == 1
        updatecolorscheme('+/-',handles);
    elseif colorScheme == 0
        updatecolorscheme('default',handles);
    else
    end
    
    updateinfo(handles);
    
    
end
end

function printnotes()
global jbm;
[noteSynapseIDs,noteTimePoints] = find(~cellfun(@isempty,jbm.scoringData.synapseNotes));
numNotes = length(noteSynapseIDs);
copyString = '';
for iNote = 1:numNotes
    ID = noteSynapseIDs(iNote);
    TP = noteTimePoints(iNote);
    note = jbm.scoringData.synapseNotes{ID,TP};
    printFormattedNote = ['Synapse ' char(jbm.scoringData.synapseID{ID}) ' on Imaging Day ' num2str(TP) ': '  ...
        char(note)];
    char(printFormattedNote);
    disp(printFormattedNote);
    copyString = [copyString printFormattedNote '\n'];
end
if isempty(copyString)
    copyString = 'No Synapse Notes Taken During Scoring'
end
copyString = sprintf(copyString);

clipboard('copy',copyString);

end

function globalsync(handles)
global h_img3;
global jbm;

selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);


globalsync = get(h_img3.(jbm.instancesOpen{selectedInstance}).gh.currentHandles.togglebutton3,'Value');

for i = 1:length(jbm.instancesOpen)
    
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.togglebutton3,'Value',globalsync);
    
    if globalsync == 1
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.togglebutton3,'ForegroundColor','g')
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncMovement,'Value',0);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZMovement,'Value',0);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZoomOpt,'Value',0);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncANumber,'Value',0);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncGrp,'Value',0);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncDispOpt,'Value',0);
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.togglebutton3,'ForegroundColor','r')
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncMovement,'Value',1);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZMovement,'Value',1);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZoomOpt,'Value',1);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncANumber,'Value',1);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncGrp,'Value',1);
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncDispOpt,'Value',1);
    end
end

end

function updateinfo(handles)
global h_img3;
global jbm;

try
    updateWeightGUI(handles)
end


try
    updateskeletoninfo(handles);
catch
end
%
selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);


for i = 1:length(jbm.instancesOpen)
    
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.jbm_dataset_display,'String',jbm.scoringData.datasetName);
    colorscheme = get(h_img3.(jbm.instancesOpen{selectedInstance}).gh.currentHandles.scoringColorScheme,'Value');
    currentAx = h_img3.(jbm.instancesOpen{i}).gh.currentHandles.imageAxes;
    obj = findobj(currentAx,'Selected','on');
    
    plotOptValue = get(h_img3.(currentStructName).gh.currentHandles.scoringGUIPlotOpt,'Value');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.scoringGUIPlotOpt,'Value',plotOptValue);
    
    if isempty(obj)
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.noteEdit,'Enable','off');
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.noteEdit,'Enable','on');
    end
    
    
    if isfield(jbm,'scoringData')
        if isfield(jbm.scoringData,'synapseMatrix')
            if ~isempty(jbm.scoringData.synapseMatrix)
                set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.data,'Enable','on');
            else
                set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.data,'Enable','off');;
            end
        else
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.data,'Enable','off');
        end
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.data,'Enable','off');
    end
    
    
    
    
    if colorscheme == 1
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.scoringColorScheme,'Value',colorscheme,'String','+/-');
        
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.scoringColorScheme,'Value',colorscheme,'String','Default');
        
    end
end
if colorscheme == 1
    updatecolorscheme('+/-',handles);
elseif colorscheme == 0
    updatecolorscheme('default',handles)
else
end

updateverification(handles);

updateROIcoordinates(handles)
end

function updateverification(handles)
global jbm;
global h_img3;
for i = 1:length(jbm.instancesOpen)
    currentInstance = jbm.instancesOpen{i};
    
    if isempty(jbm.scoringData.synapseVerification)
        set(h_img3.(currentInstance).gh.currentHandles.verification,'BackgroundColor',[.941 .941 .941],'String','VERIFICATION','Enable','off');
    elseif jbm.scoringData.synapseVerification(i) == 0
        set(h_img3.(currentInstance).gh.currentHandles.verification,'BackgroundColor','r','String','UNVERIFIED','Enable','on');
    elseif jbm.scoringData.synapseVerification(i) == 1
        set(h_img3.(currentInstance).gh.currentHandles.verification,'BackgroundColor','g','String',...
            'VERIFIED','Enable','on');
    end
end



end

function updatecolorscheme(tag,handles)
global jbm;
global h_img3;
global synScore;

if isfield(jbm,'scoringData')
    if ~isfield(jbm.scoringData,'synapseMatrix')
        return
    else
        ;
    end
else
    errordlg('No Dataset Loaded');
    return
    
end

%+/-
LOST = [1 0 0];%red
GAINED = [0 1 0];%green
TRANSIENT = [1 1 0];%yellow



binaryPresence = logical(jbm.scoringData.synapseMatrix);
differenceMatrix = diff(binaryPresence,1,2);
additionMatrix = false(size(jbm.scoringData.synapseMatrix));
eliminationMatrix = false(size(jbm.scoringData.synapseMatrix));
additionMatrix(:, 2:end) = differenceMatrix == 1;
eliminationMatrix(:, 1:end-1) = differenceMatrix == -1;
transientMatrix = additionMatrix & eliminationMatrix;

tempKnobs = jbm.knobs; % Necessary: removes 0 from absent knobs (root obj)
tempTextKnobs = jbm.textKnobs;
tempKnobs(tempKnobs == 0) = [];
tempTextKnobs(tempTextKnobs ==0) = [];


knobs = jbm.knobs;
textKnobs = jbm.textKnobs;

switch tag
    case 'default'
        set(knobs(jbm.scoringData.synapseMatrix == 1), 'Color', synScore.SHAFT_COLOR);% do it this sequence so gain/lost has priority.
        set(knobs(jbm.scoringData.synapseMatrix == 2), 'Color', synScore.SPINE_COLOR);
        set(knobs(jbm.scoringData.synapseMatrix == 3), 'Color', synScore.UNSURE_COLOR);
        set(knobs(jbm.scoringData.synapseMatrix == 4), 'Color', synScore.SPO_COLOR);
        set(textKnobs(jbm.scoringData.synapseMatrix == 1), 'Color', synScore.SHAFT_COLOR);% do it this sequence so gain/lost has priority.
        set(textKnobs(jbm.scoringData.synapseMatrix == 2), 'Color', synScore.SPINE_COLOR);
        set(textKnobs(jbm.scoringData.synapseMatrix == 3), 'Color', synScore.UNSURE_COLOR);
        set(textKnobs(jbm.scoringData.synapseMatrix == 4), 'Color', synScore.SPO_COLOR);
    case '+/-'
        set(knobs(jbm.scoringData.synapseMatrix == 1), 'Color', [0 0 1]);% do it this sequence so gain/lost has priority.
        set(knobs(jbm.scoringData.synapseMatrix == 2), 'Color', [0 0 1]);
        set(knobs(jbm.scoringData.synapseMatrix == 3), 'Color', [0 0 1]);
        set(knobs(jbm.scoringData.synapseMatrix == 4), 'Color', [0 0 1]);
        set(textKnobs(jbm.scoringData.synapseMatrix == 1), 'Color', [0 0 1]);% do it this sequence so gain/lost has priority.
        set(textKnobs(jbm.scoringData.synapseMatrix == 2), 'Color',[0 0 1]);
        set(textKnobs(jbm.scoringData.synapseMatrix == 3), 'Color', [0 0 1]);
        set(textKnobs(jbm.scoringData.synapseMatrix == 4), 'Color', [0 0 1]);
        set(knobs(eliminationMatrix), 'Color', LOST);
        set(knobs(additionMatrix), 'Color', GAINED);
        set(knobs(transientMatrix), 'Color', TRANSIENT);
        set(textKnobs(eliminationMatrix), 'Color', LOST);
        set(textKnobs(additionMatrix), 'Color', GAINED);
        set(textKnobs(transientMatrix), 'Color', TRANSIENT);
end

[row,column] = find(~cellfun(@isempty,jbm.scoringData.synapseNotes));

for i = 1:length(row)
    %     originalString = get(jbm.textKnobs(row(i),column(i)),'String');
    
    set(jbm.textKnobs(row(i),column(i)),'FontSize', 14, 'FontAngle','italic');
    
end
end

function createnewdataset(handles)
global jbm;
global h_img3;
global genFluor;
jbm_sameFieldOfView


if isfield(jbm,'scoringData')
%     if exist('genFluor')
%         choice = 'Create new'
%     else
        
    choice = questdlg('Creating a new dataset will delete any unsaved data. Are you sure you wish to proceed?',...
        'Create new','Create new','Go back','Go back');
    %end    
    switch choice
        case 'Create new'
            jbm = rmfield(jbm,'scoringData');
            createnewdataset(handles);
            return
        case 'Go back'
            return
    end
    
else
    jbm.scoringData = [];
    jbm.scoringData.fluorData = [];
    jbm.scoringData.bgFluorData = [];
end
% if exist('genFluor')
%     jbm.scoringData.datasetName = ''
%     tempString = char(jbm.scoringData.datasetName)
% else
jbm.scoringData.datasetName = inputdlg('Please name your dataset!','Dataset Name');
tempString = char(jbm.scoringData.datasetName);
%end

jbm.scoringData.datasetName = [tempString '.syn'];

jbm.scoringData.newSynapseNumber = 1;
jbm.scoringData.synapseVerification = [];
jbm.knobs = [];
jbm.textKnobs = [];
for i = 1:length(jbm.instancesOpen)
    currentInstance = jbm.instancesOpen{i};
    updateinfo(h_img3.(currentInstance).gh.currentHandles);
end

for instance = 1:length(jbm.instancesOpen)
    set(h_img3.(jbm.instancesOpen{instance}).gh.currentHandles.newsynapse_push,'Enable','on')
    h_img3.(jbm.instancesOpen{instance}).lastAnalysis.tracingData = [];
    h_img3.(jbm.instancesOpen{instance}).lastAnalysis = rmfield(h_img3.(jbm.instancesOpen{instance}).lastAnalysis,'tracingData');
end

for i = 1:length(jbm.instancesOpen)
    
    
    
    currentInstance = jbm.instancesOpen{i};
    updateinfo(h_img3.(currentInstance).gh.currentHandles);
    
    h = findobj(h_img3.(currentInstance).gh.currentHandles.imageAxes, 'tag', 'scoringROI3');
    delete(h);
    h = findobj(h_img3.(currentInstance).gh.currentHandles.imageAxes, 'tag', 'scoringROI3text');
    delete(h);
    
    handles2 = h_img3.(currentInstance).gh.currentHandles;
    h = get(handles2.imageAxes,'Children');
    g = findobj(h,'Type','Image');
    h(h==g(1)) = [];
    delete(h);
    
end
try
updateskeletoninfo(handles);
end
for i = 1:length(jbm.instancesOpen)
    cI = jbm.instancesOpen{i};
    fN = get(h_img3.(cI).gh.currentHandles.currentFileName,'String');
    jbm.scoringData.filenames{i} = fN;
    set(h_img3.(cI).gh.currentHandles.verification,'Value',0)
end

end

function waitfor_nohotkeys(cfigure)
waitfor(cfigure,'CurrentCharacter');
pressed = double(get(cfigure,'CurrentCharacter'));
acceptable_keypresses = [double('1') double('2') double('0') double('3') double('4') double('5') double('6')];
if isempty(pressed)
    waitfor_nohotkeys(cfigure)
elseif ~isempty(find(acceptable_keypresses == pressed))
    ;
else
    waitfor_nohotkeys(cfigure);
end
end

function newsynapse(handles)
global jbm;
global h_img3;
global synScore;

% [y1,Fs1] = audioread('Io1.wav');
% [y2,Fs2] = audioread('Io2.wav');
% [y3,Fs3] = audioread('Io3.wav');
% [y4,Fs4] = audioread('Io4.wav');
%
% player1 = audioplayer(y1(1:10000,:),Fs1);
% player2 = audioplayer(y2(1:10000,:),Fs2);
% player3 = audioplayer(y3(1:10000,:),Fs3);
% player4 = audioplayer(y4(1:10000,:),Fs4);

robot = java.awt.Robot;
UNUSED_HOTKEY = '9';

for instance = 1:length(jbm.instancesOpen)
    set(h_img3.(jbm.instancesOpen{instance}).gh.currentHandles.newsynapse_push,'Enable','off');
end

ABSENT = 0;
SHAFT = 1;
SPINE = 2;
UNSURE = 3;
SPO = 4;

NO_NOTE = '';

if ~isfield(jbm,'scoringData')
    createnewdataset(handles);
else
end

selectedInstance = h_getCurrendInd3(handles);

for iInstance = selectedInstance:length(jbm.instancesOpen)
    currentInstance = jbm.instancesOpen{iInstance};
    currentAxes = h_img3.(currentInstance).gh.currentHandles.imageAxes;
    currentFigure = h_img3.(currentInstance).gh.currentHandles.h_imstack3;
    figure(currentFigure);
    axes(currentAxes);
    h_updateInfo3(handles);
    
    numInstances = length(jbm.instancesOpen);
    
    
    
    set(currentFigure,'Color',[0 0.33 0.33]);
    set(currentFigure,'CurrentCharacter',UNUSED_HOTKEY);
    
    waitfor_nohotkeys(currentFigure);
    pressed = get(currentFigure,'CurrentCharacter');
    
    switch pressed
        case '0'
            scoredSynapse.data(1,iInstance) = ABSENT;
            scoredSynapse.knobs(1,iInstance) = ABSENT;
            scoredSynapse.coordinates(1:2,iInstance) = [ABSENT ABSENT];
            scoredSynapse.roiSize(1,iInstance) = ABSENT;
            scoredSynapse.textKnobs(1,iInstance) = ABSENT;
            scoredSynapse.notes{1,iInstance}  = NO_NOTE;
            currentFigurePoint = get(currentFigure,'CurrentPoint');
            
        case '1'
            %             player1.play
            axes(currentAxes);
            
            roiCoordinates = ginput(1);
            
            
            synID = num2str(jbm.scoringData.newSynapseNumber);
            synHandle = drawscoringroi(currentAxes,roiCoordinates(1),roiCoordinates(2),synID,synScore.SHAFT_COLOR);
            scoredSynapse.notes{1,iInstance}  = NO_NOTE;
            scoredSynapse.data(1,iInstance) = SHAFT;
            scoredSynapse.knobs(1,iInstance) = synHandle;
            UData = get(synHandle,'UserData');
            scoredSynapse.textKnobs(1,iInstance) = UData.texthandle;
            scoredSynapse.coordinates(1:2,iInstance) = roiCoordinates;
            currentFigurePoint = get(currentFigure,'CurrentPoint');
            
            
        case '2'
            %             player2.play
            axes(currentAxes);
            
            roiCoordinates = ginput(1);
            synID = num2str(jbm.scoringData.newSynapseNumber);
            synHandle = drawscoringroi(currentAxes,roiCoordinates(1),roiCoordinates(2),synID,synScore.SPINE_COLOR);
            scoredSynapse.data(1,iInstance) = SPINE;
            scoredSynapse.knobs(1,iInstance) = synHandle;
            UData = get(synHandle,'UserData');
            scoredSynapse.coordinates(1:2,iInstance) = roiCoordinates;
            scoredSynapse.textKnobs(1,iInstance) = UData.texthandle;
            scoredSynapse.notes{1,iInstance}  = NO_NOTE;
            currentFigurePoint = get(currentFigure,'CurrentPoint');
            
            
        case '3'
            %             player3.play
            axes(currentAxes);
            
            roiCoordinates = ginput(1);
            synID = num2str(jbm.scoringData.newSynapseNumber);
            synHandle = drawscoringroi(currentAxes,roiCoordinates(1),roiCoordinates(2),synID,synScore.UNSURE_COLOR);
            scoredSynapse.data(1,iInstance) = UNSURE;
            scoredSynapse.knobs(1,iInstance) = synHandle;
            UData = get(synHandle,'UserData');
            scoredSynapse.textKnobs(1,iInstance) = UData.texthandle;
            scoredSynapse.coordinates(1:2,iInstance) = roiCoordinates;
            scoredSynapse.notes{1,iInstance}  = NO_NOTE;
            currentFigurePoint = get(currentFigure,'CurrentPoint');
            
        case '4'
            %             player4.play
            axes(currentAxes);
            
            roiCoordinates = ginput(1);
            synID = num2str(jbm.scoringData.newSynapseNumber);
            synHandle = drawscoringroi(currentAxes,roiCoordinates(1),roiCoordinates(2),synID,synScore.SPO_COLOR);
            scoredSynapse.data(1,iInstance) = SPO;
            scoredSynapse.knobs(1,iInstance) = synHandle;
            UData = get(synHandle,'UserData');
            scoredSynapse.textKnobs(1,iInstance) = UData.texthandle;
            scoredSynapse.coordinates(1:2,iInstance) = roiCoordinates;
            scoredSynapse.notes{1,iInstance}  = NO_NOTE;
            currentFigurePoint = get(currentFigure,'CurrentPoint');
            
    end
    
    
    zHi = get(h_img3.(currentInstance).gh.currentHandles.zStackStrHigh,'String');
    zLo = get(h_img3.(currentInstance).gh.currentHandles.zStackStrLow,'String');
    zHi = str2num(zHi);
    zLo = str2num(zLo);
    
    if zHi ~= zLo
        scoredSynapse.synapseZ(1,iInstance) = mean([zHi zLo]);
    elseif zHi == zLo
        
        scoredSynapse.synapseZ(1,iInstance) = zHi;
    end
    set(currentFigure,'Color',[.941 .941 .941]);
    
    % JBM move to mouse to next screen
    if iInstance ~= numInstances
        screenSize = get(0,'screensize');
        currentFigurePosition = get(currentFigure,'Position');
        screenSize = screenSize(3:4);
        currentFigurePositionMTLB(iInstance,:) = currentFigurePosition(1:2);
        currentFigurePosition(2) = screenSize(2) - currentFigurePosition(2);
        currentFigurePositionJVA(iInstance,:) = currentFigurePosition(1:2);
        
        nextFigure = h_img3.(jbm.instancesOpen{iInstance+1}).gh.currentHandles.h_imstack3;
        nextFigurePosition = get(nextFigure,'Position');
        nextFigurePositionMTLB(iInstance,:) = nextFigurePosition(1:2);
        nextFigurePosition(2) = screenSize(2) - nextFigurePosition(2);
        nextFigurePositionJVA(iInstance,:) = nextFigurePosition(1:2);
        
        vertPlot = nextFigurePositionJVA(iInstance,1) + currentFigurePoint(1);
        horzPlot = nextFigurePositionJVA(iInstance,2) - currentFigurePoint(2);
        
        robot.mouseMove(vertPlot,horzPlot);
        
        
        
        
        try
            rCo(iInstance,1:2) = roiCoordinates;
        catch
            ;
        end
        
        
        
    elseif iInstance == numInstances
        screenSize = get(0,'screensize');
        currentFigurePosition = get(currentFigure,'Position');
        screenSize = screenSize(3:4);
        currentFigurePositionMTLB(iInstance,:) = currentFigurePosition(1:2);
        currentFigurePosition(2) = screenSize(2) - currentFigurePosition(2);
        currentFigurePositionJVA(iInstance,:) = currentFigurePosition(1:2);
        
        nextFigure = h_img3.(jbm.instancesOpen{1}).gh.currentHandles.h_imstack3;
        nextFigurePosition = get(nextFigure,'Position');
        nextFigurePositionMTLB(iInstance,:) = nextFigurePosition(1:2);
        nextFigurePosition(2) = screenSize(2) - nextFigurePosition(2);
        nextFigurePositionJVA(iInstance,:) = nextFigurePosition(1:2);
        
        vertPlot = nextFigurePositionJVA(iInstance,1) + currentFigurePoint(1);
        horzPlot = nextFigurePositionJVA(iInstance,2) - currentFigurePoint(2);
        
        robot.mouseMove(vertPlot,horzPlot);
        try
            
            rCo(iInstance,1:2) = roiCoordinates;
        catch
        end
        
    end
    
end

lastInstanceSelectionType = get(h_img3.(jbm.instancesOpen{end}).gh.currentHandles.h_imstack3,'Selectiontype');
isRightClick = strcmp(lastInstanceSelectionType,'alt');

if logical(isRightClick) && (selectedInstance == 1) && (sum(double(logical(scoredSynapse.data))) == ...
        numInstances)
    
    for i = selectedInstance:length(jbm.instancesOpen)
        centersynapse(h_img3.(jbm.instancesOpen{i}).gh.currentHandles,1,0,rCo(i,1),rCo(i,2));
    end
end

updatedataset(scoredSynapse,handles)
jbm.scoringData.newSynapseNumber = jbm.scoringData.newSynapseNumber + 1;
updateinfo(handles);

for instance = 1:length(jbm.instancesOpen)
    set(h_img3.(jbm.instancesOpen{instance}).gh.currentHandles.newsynapse_push,'Enable','on')
end

global activeplotter
if activeplotter
    activePlotter
end
end

function roiHandle = drawscoringroi(ax,xCoordinate,yCoordinate,synapseNumber,roiColor,varargin)
% global h_img3; %Haining.
% global jbm;

ROIsize = 10;

if ax~=gca % only run axes as needed.
    axes(ax);%HN note: axes is a very slow function...
else
end
obj = get(ax,'Children');
set(obj,'Selected','off');
% theta = (0:1/40:1)*2*pi;
% xc = xCoordinate;
% yc = yCoordinate;
% xr = ROIsize;
% yr = ROIsize;
% UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
% UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
hold on;
% mark_size = 9;
roiHandle = plot(xCoordinate,yCoordinate,'.','MarkerSize',ROIsize, 'Tag', 'scoringROI3',...
    'Color',roiColor, 'EraseMode','normal', 'ButtonDownFcn', 'jbm_dragROI3');
hold off;

UserData.texthandle = text(xCoordinate,yCoordinate,[' ', num2str(synapseNumber)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
    'Tag', 'scoringROI3text', 'Color',roiColor,'FontWeight','Bold', 'EraseMode', 'normal', 'ButtonDownFcn', 'jbm_dragText3');




% roiHandle = plot(UserData.roi.xi,UserData.roi.yi,'k-');
% % roiHandle = plot(ax, UserData.roi.xi,UserData.roi.yi,'k-');%HN note: this
% % is faster but this won't work since text can only write to gca.
%
% set(roiHandle,'ButtonDownFcn', 'jbm_dragROI3', 'Tag', 'scoringROI3', 'EraseMode','xor','linewidth',2);
%
% set(roiHandle,'Color',roiColor);
%
% UserData.texthandle = text(xCoordinate,yCoordinate,synapseNumber,'Tag','scoringROI3text','FontSize',13,'FontWeight','bold','HorizontalAlignment',...
%    'Center','VerticalAlignment','Middle', 'Color',roiColor, 'EraseMode','xor', 'ButtonDownFcn', 'jbm_dragText3');

UserData.synapseID = synapseNumber;
UserData.roiHandle = roiHandle;
UserData.timeLastClick = clock;
UserData.xCo = xCoordinate;
UserData.yCo = yCoordinate;
UserData.roiSize = ROIsize;
UserData.roiExist = 1;

set(UserData.texthandle,'UserData',UserData);
set(roiHandle,'UserData',UserData);
end

function updatedataset(scoredSynapse,handles)
global jbm;
global h_img3;
if isfield(jbm.scoringData,'synapseMatrix')
    synapseMatrixDimensions = size(jbm.scoringData.synapseMatrix);
    numSynapses = synapseMatrixDimensions(1);
    numTimePoints = synapseMatrixDimensions(2);
    jbm.scoringData.synapseMatrix(numSynapses+1,:) = scoredSynapse.data;
    jbm.knobs(numSynapses+1,:) = scoredSynapse.knobs;
    jbm.scoringData.roiCoordinates(1:2,:,numSynapses+1) = scoredSynapse.coordinates;
    jbm.scoringData.synapseID{numSynapses+1} = num2str(jbm.scoringData.newSynapseNumber);
    jbm.textKnobs(numSynapses+1,:) = scoredSynapse.textKnobs;
    jbm.scoringData.synapseZ(numSynapses+1,:) = scoredSynapse.synapseZ;
    jbm.scoringData.synapseNotes(numSynapses+1,:) = scoredSynapse.notes;
else
    jbm.scoringData.synapseMatrix(1,:) = scoredSynapse.data;
    jbm.knobs(1,:) = scoredSynapse.knobs;
    jbm.scoringData.synapseID{1} = num2str(jbm.scoringData.newSynapseNumber);
    jbm.scoringData.roiCoordinates(1:2,:,1) = scoredSynapse.coordinates;
    jbm.textKnobs(1,:) = scoredSynapse.textKnobs;
    jbm.scoringData.synapseVerification = zeros(1,length(scoredSynapse.data));
    jbm.scoringData.synapseZ(1,:) = scoredSynapse.synapseZ;
    jbm.scoringData.synapseNotes(1,:) = scoredSynapse.notes;
    
    for i = 1:length(jbm.instancesOpen)
        currentInstance = jbm.instancesOpen{i};
    end
    updateinfo(handles);
end


colorscheme = get(h_img3.I1.gh.currentHandles.scoringColorScheme,'Value');
if colorscheme == 1
    updatecolorscheme('+/-',handles);
elseif colorscheme == 0
    updatecolorscheme('default',handles);
else
end


end

function updateROIcoordinates(handles)

global jbm;
global h_img3;

dataDim = size(jbm.knobs);
numSyn = dataDim(1);
numDays = dataDim(2);


for ii = 1:numDays
    for jj = 1:numSyn
        if jbm.knobs(jj,ii) ~= 0
            synapse = jbm.knobs(jj,ii);
            UData = get(synapse);
            xCo = UData.XData;
            yCo = UData.YData;
            if vertcat(xCo,yCo) ~= jbm.scoringData.roiCoordinates(:,ii,jj)
                newCoordinates = vertcat(xCo,yCo);
                jbm.scoringData.roiCoordinates(:,ii,jj) = newCoordinates;
            else
            end
        else
        end
        
    end
end





end

function activePlotter()


global h_img3;
global jbm;
% returndata();
global activeplotter;
% % returndata();
%
gate = get(h_img3.I1.gh.currentHandles.scoringGUIPlotOpt,'Value');
if gate == 7
    data = jbm.scoringData;
    data.presenceMatrix = data.synapseMatrix>0;
    Aout = h_routinesForInVivoAnalysis(1:4,data,0);
    
    
    %
    f1 = figure(1);
    clf;
    a1 = axes;
    set(f1,'Position',[[-1069 670 1065 267]]);
    dates = 0:4:4*(length(Aout.synapseNum)-1);
    plot(dates, Aout.synapseNum, '-o');
    ylim([0, ceil(max(Aout.synapseNum)/10)*10]);
    ylabel('synapse number', 'fontsize', 12);
    xlabel('imaging day', 'fontsize', 12);
    
    f2 = figure(2);
    clf;
    a2 = axes;
    set(f2,'Position', [-1069 293 1065 267]);
    dates = 0:4:4*(length(Aout.survivalFcn)-1);
    plot(dates, Aout.survivalFcn, '-o');
    ylim([0, 1.1]);
    ylabel('Survival Fraction', 'fontsize', 12);
    xlabel('imaging day', 'fontsize', 12);
    
    f3 = figure(3);
    clf;
    a3 = axes;
    set(f3,'Position',[-1072 -84 1065 267]);
    dates = 0:4:4*(length(Aout.elimination)-1);
    plot(dates, Aout.elimination, '-o');
    ylim([0, max(Aout.elimination)+1]);
    ylabel('Elimination Number', 'fontsize', 12);
    xlabel('imaging day', 'fontsize', 12);
    
    f4 = figure(4);
    clf;
    a4 = axes;
    set(f4,'Position',[-1070 -484 1065 267])
    dates = 0:4:4*(length(Aout.addition)-1);
    plot(dates, Aout.addition, '-o');
    ylim([0, max(Aout.addition)+1]);
    ylabel('Addition Number', 'fontsize', 12);
    xlabel('imaging day', 'fontsize', 12);
    
    ll = length(jbm.instancesOpen);
    figure(h_img3.(jbm.instancesOpen{ll}).gh.currentHandles.h_imstack3);
else
end




end

function updateskeletoninfo(handles)
global h_img3;
global jbm;
for i = 1:length(jbm.instancesOpen)
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.makeTracingMarks,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.tracingDendrite,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.loadTracingData,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.lengthStringSkeleton,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.skeletonLengthField,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.showTracingMark,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.showMarkNumber,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.showSkeleton,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.showingImgOpt,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.appendSkeleton,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeleton,'Enable','on');
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeletonField,'Enable','on');
    
    if isfield(h_img3.(jbm.instancesOpen{i}).lastAnalysis,'tracingData')
        tD = h_img3.(jbm.instancesOpen{i}).lastAnalysis.tracingData;
        lastTrace = max(tD.skeletonInMicron(:,4));
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.skeletonLengthField,'String',[num2str(lastTrace) ' um']);
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.skeletonLengthField,'String','n/a');
        
    end
    
    
    if isfield(jbm.scoringData,'skeleton')
        if isfield(jbm.scoringData.skeleton,'tracingData')
            tracingDataExists = cellfun('isempty',jbm.scoringData.skeleton.tracingData);
            
            if tracingDataExists(i) == 0
                td = jbm.scoringData.skeleton.tracingData{i}.skeletonInMicron(:,4);
                savedTrace = max(td);
                set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeletonField,'String',[num2str(savedTrace) ' um']);
            else
                set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeletonField,'String','n/a');
            end
        else
            set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeletonField,'String','n/a');
        end
    else
        set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.savedLengthSkeletonField,'String','n/a');
    end
    
end






end

function appendskeleton(handles)
global jbm;
global h_img3;
if isfield(jbm.scoringData,'skeleton')
    if isfield(jbm.scoringData.skeleton,'tracingData')
        tracingDataExists = cellfun('isempty', jbm.scoringData.skeleton.tracingData);
        if tracingDataExists(h_getCurrendInd3(handles)) == 0
            choice = questdlg('Appending a skeleton will delete any previous skeletons. Are you sure you wish to proceed?',...
                'Append','Append','Go back','Go back');
            
            switch choice
                case 'Append'
                    jbm.scoringData.skeleton.tracingData{h_getCurrendInd3(handles)} = h_img3.(jbm.instancesOpen{h_getCurrendInd3(handles)}).lastAnalysis.tracingData;
                    updateskeletoninfo(handles);
                case 'Go back'
                    return
            end
            
        else
            jbm.scoringData.skeleton.tracingData{h_getCurrendInd3(handles)} = h_img3.(jbm.instancesOpen{h_getCurrendInd3(handles)}).lastAnalysis.tracingData;
        end
    else
        jbm.scoringData.skeleton.tracingData = cell(length(jbm.instancesOpen),1);
        jbm.scoringData.skeleton.tracingData{h_getCurrendInd3(handles)} = h_img3.(jbm.instancesOpen{h_getCurrendInd3(handles)}).lastAnalysis.tracingData;
        
    end
else
    jbm.scoringData.skeleton.tracingData = cell(length(jbm.instancesOpen),1);
    jbm.scoringData.skeleton.tracingData{h_getCurrendInd3(handles)} = h_img3.(jbm.instancesOpen{h_getCurrendInd3(handles)}).lastAnalysis.tracingData;
    
end




end

function loadskeletondata(handles)

global jbm;
global h_img3;
mark_size = 9;
cstr = {'blue', 'blue', 'green', 'magenta', 'cyan', 'yellow'};
Aout = jbm.scoringData.skeleton.tracingData{h_getCurrendInd3(handles)};
if isfield(Aout,'tracingMarks') && ~isempty(Aout.tracingMarks)
    for i = 1:length(Aout.tracingMarks)
        UData = Aout.tracingMarks(i);
        point1 = UData.pos;
        hold on;
        h = plot(point1(1),point1(2),'.','MarkerSize',mark_size, 'Tag', 'h_tracingMark3',...
            'Color',cstr{mod(UData.flag-1,6)+1},'ButtonDownFcn', 'h_dragTracingMark3', 'EraseMode','normal');
        hold off;
        
        x = point1(1);% + h_img.header.acq.pixelsPerLine/64;
        y = point1(2);% + h_img.header.acq.pixelsPerLine/64;
        h2 = text(x,y,[' ', num2str(UData.flag), '.', num2str(UData.number)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
            'Tag', 'h_tracingMarkText3', 'Color',cstr{mod(UData.flag-1,6)+1}, 'EraseMode','normal', 'ButtonDownFcn', 'h_dragTracingMarkText3');
        
        UData.markHandle = h;
        UData.textHandle = h2;
        UData.timeLastClick = clock;
        
        set(h,'UserData',UData);
        set(UData.textHandle,'UserData',UData);
    end
end

cstr = {'cyan', 'blue', 'green', 'magenta', 'cyan', 'yellow'};
axes(handles.imageAxes);
hold on;
flag = Aout.skeletonInPixel(:,5);
flag2 = flag;%flag2 is the one that will change within the loop, flag does not change.
while ~isempty(flag2)
    currentFlag = min(flag2);
    ind = find(flag==currentFlag);
    plot(Aout.skeletonInPixel(ind,1),Aout.skeletonInPixel(ind,2),'-', 'Color', cstr{mod(currentFlag-1,6)+1},...
        'tag', 'h_dendriteSkeleton3', 'UserData', currentFlag);
    flag2(flag2==currentFlag) = [];
end
hold off;
%     currentStruct.lastAnalysis.tracingData = Aout;

h_setDendriteTracingVis3(handles);

end

function centersynapse(handles,zoomFactor,syncFlag,x,y,button)

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[x_lim,y_lim,z_lim] = h_getLimits3(handles);
currentXLim = get(handles.imageAxes, 'XLim');
currentYLim = get(handles.imageAxes, 'YLim');

zoomBoxSizeX = diff(currentXLim)/zoomFactor;
zoomBoxSizeY = diff(currentYLim)/zoomFactor;

axes(handles.imageAxes);



p1 = [x - zoomBoxSizeX/2, y - zoomBoxSizeY/2];% this is to use old codes from h_zoomIn3.
offset = [zoomBoxSizeX, zoomBoxSizeX];

% old code here.
set(handles.imageAxes,'XLim',[p1(1),p1(1)+offset(1)],'YLim',[p1(2),p1(2)+offset(2)]);
[xlim,ylim,zlim] = h_getLimits3(handles);
if isfield(currentStruct.state,'lineScanDisplay') && currentStruct.state.lineScanDisplay.value
    ylim = [0,size(currentStruct.greenimg,1)]+0.5;
end

if diff(xlim)>offset(1)
    set(handles.moveHorizontal,'Enable','on');
    xstep = min([0.05*offset(1)/(diff(xlim)-offset(1)),0.1],1);
    xvalue = (p1(1)-xlim(1))/(diff(xlim)-offset(1));
    xstep(2) = max(xstep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
    set(handles.moveHorizontal,'Value',xvalue,'SliderStep',xstep);
end

if diff(ylim)>offset(2)
    set(handles.moveVertical,'Enable','on');
    ystep = min([0.05*offset(2)/(diff(ylim)-offset(2)),0.1],1);
    ystep(2) = max(ystep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
    yvalue = 1 - (p1(2)-ylim(1))/(diff(ylim)-offset(2));
    set(handles.moveVertical,'Value',yvalue,'SliderStep',ystep);
end

try % there can be error if the figure has been deleted. Temporary fix
    if isfield(currentStruct.gh, 'otherHandles') && isfield(currentStruct.gh.otherHandles,'separateMaxPrj')...
            && ~isempty(currentStruct.gh.otherHandles.separateMaxPrj)
        h = findobj(currentStruct.gh.otherHandles.separateMaxPrj.figureHandle, 'tag', 'zoomInBox3InSeparateMaxPrj');
        delete(h);
        hold(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,'on');
        xi = [p1(1),p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1)];
        yi = [p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2),p1(2)];
        h = plot(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,...
            xi,yi,'-','Tag','zoomInBox3InSeparateMaxPrj', 'Color','black', 'EraseMode','xor');
    end
catch
end
% old code above.


% to sync
if syncFlag && get(handles.syncZoomOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncZoomOpt, 'value')% only sync if the sync button is checked on the other instance.
                try h_zoomInByClick3(handles1, zoomFactor, 0); end % sometimes there can be an error if an instance has no image.
            end
        end
    end
end

end

function generalnote(handles)
global jbm;
global h_img3;

if ~isfield(jbm,'genNoteCounter')
    jbm.genNoteCounter = 1;
else
    jbm.genNoteCounter = double(length(jbm.scoringData.generalNotes)) + 1;
end

note = inputdlg('General Note:');
jbm.scoringData.generalNotes{jbm.genNoteCounter} = note{1};
jbm.genNoteCounter = jbm.genNoteCounter + 1;







end
