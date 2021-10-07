function h_resetAnalysisNumber3(handles, syncFlag, currentValue)

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).state.analysisNumber.value = currentValue;
h_setParaAccordingToState3(handles);
h_updateInfo3(handles);

% to sync
if syncFlag && get(handles.syncANumber, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncANumber, 'value')% only sync if the sync button is checked on the other instance.
                h_resetAnalysisNumber3(handles1, 0, currentValue)
            end
        end
    end
end

