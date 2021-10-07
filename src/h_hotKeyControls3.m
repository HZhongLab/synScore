function h_hotKeyControls3(handles, keyData)
global h_img3;
global jbm;

key = keyData.Key;
modifier = keyData.Modifier;
X_Y_STEPSIZE = 3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

%% Navigate s dimensions
switch(key)
    case {'rightarrow', 'leftarrow', 'uparrow', 'downarrow'}
        shiftFOV(key,X_Y_STEPSIZE,handles);
        % Vim bindings
    case 's'
        key = 'downarrow';
        shiftFOV(key,X_Y_STEPSIZE,handles);
    case 'w'
        key = 'uparrow';
        shiftFOV(key,X_Y_STEPSIZE,handles);
    case 'a'
        key = 'leftarrow';
        shiftFOV(key,X_Y_STEPSIZE,handles);
    case 'd'
        key = 'rightarrow';
        shiftFOV(key,X_Y_STEPSIZE,handles);
        
    case 'space'
        jbm_synapsescoringengine('new synapse',handles);
        
        
        % 3. Fluorescence calculation (weight) utilities
    case 'r'
        jbm_synapsescoringengine('setZAll',handles);
    case 'f'
        jbm_synapsescoringengine('focus',handles);
        
    case 'k'
        highlightLastWindow(handles);
    case 'j'
        highlightNextWindow(handles);
    case 'e'
        defaultHighlighting(handles);
    otherwise
end

%% Everything else
if length(modifier)==1 && strcmpi(modifier{1}, 'control')
    
    switch(key)
        % 1. Display utilities
        case 'c'
            centralCrop(handles);
        case 'p'
            cycleDisplayedDatasetBack(handles);
        case 'o'
            cycleDisplayedDatasetForward(handles);
            
            % 2. Binary scoring utilities
        case 'v' %
            verifyCurrentWindow(handles)
        case 't'
            enterTraceMode(handles)
  
            % 4. Synchronization toggling
        case 'i'
            syncAllWindowsExceptZ(handles);
        case 'u'
            syncAllWindows(handles);
            
            
    end
end
end

%% Function definitions
function h_adjZStackSlider3(steps, handles)
global jbm
global h_img3
% tic
stepLow = steps(1);
stepHigh = steps(2);
stepPos = steps(3);
[xlim,ylim,zlim] = h_getLimits3(handles);

if stepLow~=0
    val = get(handles.zStackSlider1, 'value');
    stepSize = get(handles.zStackSlider1,'SliderStep');
    newValue = val + stepLow*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zStackSlider1, 'value', newValue);
    zstackLow = round(newValue*(diff(zlim))+1);
    set(handles.zStackStrLow,'String',num2str(zstackLow));
    h_zStackQuality3(handles);
    h_replot3(handles);
    %   toc
end

if stepHigh~=0
    val = get(handles.zStackSlider2, 'value');
    stepSize = get(handles.zStackSlider2,'SliderStep');
    newValue = val + stepHigh*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zStackSlider2, 'value', newValue);
    zstackHigh = round(newValue*(diff(zlim))+1);
    set(handles.zStackStrHigh,'String',num2str(zstackHigh));
    h_zStackQuality3(handles);
    h_replot3(handles);
    %   toc
end

if stepPos~=0
    val = get(handles.zPosSlider, 'value');
    stepSize = get(handles.zPosSlider,'SliderStep');
    newValue = val + stepPos*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zPosSlider, 'value', newValue);
    %     toc
    h_resetZPos3(handles);
    %     toc
end
end

function h_adjRedSlider(steps, handles)
global jbm
global h_img3

stepLow = steps(1);
stepHigh = steps(2);

if stepLow~=0
    val = get(handles.redLimitSlider1, 'value');
    stepSize = get(handles.redLimitSlider1,'SliderStep');
    newValue = val + stepLow*stepSize(1)*2;
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.redLimitSlider1, 'value', newValue);
    maxIntensity = h_getMaxIntensity3(handles);
    valueStr = round(newValue*maxIntensity);
    
    set(handles.redLimitStrLow,'String',num2str(valueStr));
    h_cLimitQuality3(handles);
    h_replot3(handles, 'fast');
end

if stepHigh~=0
    val = get(handles.redLimitSlider2, 'value');
    stepSize = get(handles.redLimitSlider2,'SliderStep');
    newValue = val + stepHigh*stepSize(1)*2;
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.redLimitSlider2, 'value', newValue);
    maxIntensity = h_getMaxIntensity3(handles);
    valueStr = round(newValue*maxIntensity);
    
    set(handles.redLimitStrHigh,'String',num2str(valueStr));
    h_cLimitQuality3(handles);
    h_replot3(handles, 'fast');
end
end

function h_adjGreenSlider(steps, handles)
global jbm
global h_img3

stepLow = steps(1);
stepHigh = steps(2);

if stepLow~=0
    val = get(handles.greenLimitSlider1, 'value');
    stepSize = get(handles.greenLimitSlider1,'SliderStep');
    newValue = val + stepLow*stepSize(1)*2;
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.greenLimitSlider1, 'value', newValue);
    maxIntensity = h_getMaxIntensity3(handles);
    valueStr = round(newValue*maxIntensity);
    
    set(handles.greenLimitStrLow,'String',num2str(valueStr));
    h_cLimitQuality3(handles);
    h_replot3(handles, 'fast');
end

if stepHigh~=0
    val = get(handles.greenLimitSlider2, 'value');
    stepSize = get(handles.greenLimitSlider2,'SliderStep');
    newValue = val + stepHigh*stepSize(1)*2;
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.greenLimitSlider2, 'value', newValue);
    maxIntensity = h_getMaxIntensity3(handles);
    valueStr = round(newValue*maxIntensity);
    
    set(handles.greenLimitStrHigh,'String',num2str(valueStr));
    h_cLimitQuality3(handles);
    h_replot3(handles, 'fast');
end
end

function cycleDisplayedDatasetForward(handles)
global h_img3;
global cycleCounter;


instances = fields(h_img3);
numInstances = length(instances);

if isempty(cycleCounter) || cycleCounter > 4
    cycleCounter = 1
elseif cycleCounter == 1
    for i = 1:numInstances
        set(h_img3.(instances{i}).gh.currentHandles.hideScoringDataset, 'Value', 1);
        set(h_img3.(instances{i}).gh.currentHandles.hideRefDataset,'Value',1);
        h_img3.(instances{i}).state.hideRefDataset.value = 1;
        h_img3.(instances{i}).state.hideScoringDataset.value = 1;
        h_setDendriteTracingVis3(h_img3.(instances{i}).gh.currentHandles);
        
        
    end
    cycleCounter = cycleCounter + 1;
elseif cycleCounter == 2
    for i = 1:numInstances
        set(h_img3.(instances{i}).gh.currentHandles.hideScoringDataset, 'Value', 0);
        set(h_img3.(instances{i}).gh.currentHandles.hideRefDataset,'Value',1);
        h_img3.(instances{i}).state.hideRefDataset.value = 1;
        h_img3.(instances{i}).state.hideScoringDataset.value = 0;
        h_setDendriteTracingVis3(h_img3.(instances{i}).gh.currentHandles);
        
    end
    cycleCounter = cycleCounter + 1;
elseif cycleCounter == 3
    for i = 1:numInstances
        set(h_img3.(instances{i}).gh.currentHandles.hideScoringDataset, 'Value', 1);
        set(h_img3.(instances{i}).gh.currentHandles.hideRefDataset,'Value', 0);
        h_img3.(instances{i}).state.hideRefDataset.value = 0;
        h_img3.(instances{i}).state.hideScoringDataset.value = 1;
        h_setDendriteTracingVis3(h_img3.(instances{i}).gh.currentHandles);
        
    end
    cycleCounter = cycleCounter + 1;
elseif cycleCounter == 4
    for i = 1:numInstances
        set(h_img3.(instances{i}).gh.currentHandles.hideScoringDataset, 'Value', 0);
        set(h_img3.(instances{i}).gh.currentHandles.hideRefDataset,'Value', 0);
        h_img3.(instances{i}).state.hideRefDataset.value = 0;
        h_img3.(instances{i}).state.hideScoringDataset.value = 0;
        h_setDendriteTracingVis3(h_img3.(instances{i}).gh.currentHandles);
        
    end
    cycleCounter = 1;
end
end

function cycleDisplayedDatasetBack(handles)
global jbm
global h_img3
% Cycle through current and loaded reference .syn files
% Order: Both, Neither, Current, Ref, Both, Neither, Current,
% Ref, ...
global cycleCounter
try
    if cycleCounter == 1
        cycleCounter = 3;
    elseif cycleCounter == 2
        cycleCounter = 4
    else
        cycleCounter = cycleCounter - 2;
    end
    cycleDisplayedDatasetForward(handles);
end
end

function verifyCurrentWindow(handles)
global jbm
global h_img3
selectedInstance = h_getCurrendInd3(handles);
set(h_img3.(jbm.instancesOpen{selectedInstance}).gh.currentHandles.verification,'Value',1);
jbm.scoringData.synapseVerification(double(selectedInstance)) = 1;
jbm_synapsescoringengine('update verification',handles);
end

function centralCrop(handles)
% Zoom into middle of all open windows
global jbm
global h_img3
instances = fields(h_img3);

for i=1:length(instances)
    handles2 = h_img3.(instances{i}).gh.currentHandles;
    figure(h_img3.(instances{i}).gh.currentHandles.h_imstack3);
    j_ezgz3(handles2)
end
end

function syncAllWindows(handles)
% Toggle global sync of movement, grp, z, zoom, disp, A#
% (latter is deprecated)

global jbm
global h_img3
selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);


globalsync = get(h_img3.(jbm.instancesOpen{selectedInstance}).gh.currentHandles.togglebutton3,'Value');
globalsync = double(~logical(globalsync));


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

function syncAllWindowsExceptZ(handles)
global jbm
global h_img3
% Toggle global sync of all but z
selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);
for i = 1:length(jbm.instancesOpen)
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.togglebutton3,'ForegroundColor','r')
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncMovement,'Value',1);
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZMovement,'Value',0);
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncZoomOpt,'Value',1);
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncANumber,'Value',1);
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncGrp,'Value',1);
    set(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.syncDispOpt,'Value',1);
end
end

function defaultHighlighting(handles)
global jbm
global h_img3
% Change window alignment to show all images
if ~isfield(jbm,'instancesOpen')
    disp('ERROR: CREATE DATASET');
else
    for i = 1:length(jbm.instancesOpen)
        figure(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.h_imstack3);
    end
end

end

function enterTraceMode(handles)
global jbm
global h_img3
% Make a tracing mark
jbm_makeTracingMark3(handles);
jbm_synapsescoringengine('update skeleton info',handles);
end

function highlightLastWindow(handles)
global jbm
global h_img3
% Highlight previous window
numInstances = length(jbm.instancesOpen);
selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);
if selectedInstance >1
    figure(h_img3.(jbm.instancesOpen{selectedInstance -1}).gh.currentHandles.h_imstack3)
else
    figure(h_img3.(jbm.instancesOpen{numInstances}).gh.currentHandles.h_imstack3);
end
end

function highlightNextWindow(handles)
% Highlight next window
global jbm
global h_img3
numInstances = length(jbm.instancesOpen);
selectedInstance = h_getCurrendInd3(handles);
[currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);
if selectedInstance < numInstances
    figure(h_img3.(jbm.instancesOpen{selectedInstance + 1}).gh.currentHandles.h_imstack3)
else
    figure(h_img3.(jbm.instancesOpen{1}).gh.currentHandles.h_imstack3)
    
end
end

function autoSyncLUT(channel,handles)
global jbm
global h_img3
%Auto-scale LUT of selected channel.
isRed = strcmp(channel,'red');
isGreen = strcmp(channel,'green');
if isRed
    currentImg = currentStruct.image.display.red;
elseif isGreen
    currentImg = currentStruct.image.display.green;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

xlim = get(handles.imageAxes, 'xlim');
ylim = get(handles.imageAxes, 'ylim');
currentDisplayImg = currentImg(round(ylim(1):ylim(2)),round(xlim(1):xlim(2)));
imgValues = sort(currentDisplayImg(:));
imgValues(isnan(imgValues)) = [];


currentCLimit(1) = str2num(get(handles.redLimitStrLow,'String'));
ind = mean([find(imgValues>currentCLimit(1), 1, 'first'), find(imgValues<currentCLimit(1), 1, 'last')]);
%do it this way because sometime the value is not present.
currentPct(1) = ind/length(imgValues);

currentCLimit(2) = str2num(get(handles.redLimitStrHigh,'String'));
ind = mean([find(imgValues>currentCLimit(2), 1, 'first'), find(imgValues<currentCLimit(2), 1, 'last')]);
%do it this way because sometime the value is not present.
currentPct(2) = ind/length(imgValues);

structNames = fieldnames(h_img3);
for i = 1:length(structNames)
    if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
        handles1 = h_img3.(structNames{i}).gh.currentHandles;
        if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
            if isRed
                img1 = h_img3.(structNames{i}).image.display.red;
            elseif isGreen
                img1 = h_img3.(structNames{i}).image.display.green;
            end
            
            
            xlim1 = get(handles1.imageAxes, 'xlim');
            ylim1 = get(handles1.imageAxes, 'ylim');
            displayImg1 = img1(round(ylim1(1):ylim1(2)),round(xlim1(1):xlim1(2)));
            cLim = h_climit(displayImg1, currentPct(1), currentPct(2));
            set(handles1.redLimitStrLow, 'String', cLim(1));
            set(handles1.redLimitStrHigh, 'String', cLim(2));
            h_cLimitQuality3(handles1);
            h_replot3(handles1, 'fast');
        end
    end
end
end

function shiftFOV(key,stepsize,handles)
switch(key)
    case 'rightarrow'
        xStep = stepsize;
        yStep = 0;
    case 'leftarrow'
        xStep = -stepsize;
        yStep = 0;
    case 'uparrow'
        xStep = 0;
        yStep = stepsize;
    case 'downarrow'
        xStep = 0;
        yStep = -stepsize;
    otherwise
end

roiobj = findobj(handles.imageAxes,'Tag','ROI3', 'Selected', 'on');
if isempty(roiobj)
    roiobj = findobj(handles.imageAxes,'Tag','annotationROI3', 'Selected', 'on');
end

if ~isempty(roiobj)
    UserData = get(roiobj(1), 'UserData');
    UserData.roi.xi = UserData.roi.xi + xStep;
    UserData.roi.yi = UserData.roi.yi - yStep;
    set(roiobj,'XData',UserData.roi.xi,'YData',UserData.roi.yi,'UserData',UserData);
    x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
    y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
    set(UserData.texthandle, 'Position', [x,y],'UserData',UserData);
else
    yValue = get(handles.moveVertical,'Value');
    yStepSize = get(handles.moveVertical,'SliderStep');
    newYValue = yValue + yStep*yStepSize(1);
    if newYValue<0
        newYValue = 0;
    elseif newYValue>1
        newYValue = 1;
    end
    set(handles.moveVertical,'Value',newYValue);
    
    xValue = get(handles.moveHorizontal,'Value');
    xStepSize = get(handles.moveHorizontal,'SliderStep');
    newXValue = xValue + xStep*xStepSize(1);
    if newXValue<0
        newXValue = 0;
    elseif newXValue>1
        newXValue = 1;
    end
    set(handles.moveHorizontal,'Value',newXValue);
    h_resetZoomBox3(handles);
end
end
