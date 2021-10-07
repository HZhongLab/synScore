function h_openDiffFileInGrp3(handles, flag, syncFlag)

% flag can be 'next', 'previous', 'first', 'last'

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
if isfield(currentStruct,'activeGroup') && ~isempty(currentStruct.activeGroup.groupFiles)
    currentFilename = get(handles.currentFileName,'String');
    [pname,fname,fExt] = fileparts(currentFilename);
    
    groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
    previousIndex = find(ismember(groupFileNames, [fname, fExt]));
    if isempty(previousIndex)
        index = 0;
    else
        index = previousIndex;
    end
    switch flag
        case('first')
            index = 1;
        case('last')
            index = length(groupFileNames);
        case('previous')
            index = index - 1;
        case('next')
            index = index + 1;
        otherwise
    end
    if index<1
        index = 1;
    elseif index>length(groupFileNames)
        index = length(groupFileNames);
    end
    if isempty(previousIndex) || index~=previousIndex
        fname = fullfile(currentStruct.activeGroup.groupPath,currentStruct.activeGroup.groupFiles(index).relativePath,...
            currentStruct.activeGroup.groupFiles(index).fname);
        if exist(fname, 'file')
            fileInfo = h_dir(fname);
            h_openFile3(handles, fileInfo.name);
        else
            h_openFile3(handles, currentStruct.activeGroup.groupFiles(index).name);
        end
    end
end

% to sync
if syncFlag && get(handles.syncGrp, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncGrp, 'value')% only sync if the sync button is checked on the other instance.
                handles1 = h_img3.(structNames{i}).gh.currentHandles;
                h_openDiffFileInGrp3(handles1, flag, 0)
            end
        end
    end
end