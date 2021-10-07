function h_updateSpineAnalysisFileInfo3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if ~isempty(h_img2)
    handles1 = h_img2.gh.currentHandles;
    currentFilename1 = get(handles1.currentFileName,'String');
    [pname1, fname1, fExt1] = fileparts(currentFilename1);
else
    fname1 = 'n/a';
end

if ~isempty(h_img2a)
    handles2 = h_img2a.gh.currentHandles;
    currentFilename2 = get(handles2.currentFileName,'String');
    [pname2, fname2, fExt2] = fileparts(currentFilename2);
else
    fname2 = 'n/a';
end

fnameStr = {fname1;fname2};

if exist('handles1', 'var') && isfield(handles1,'file1Opt')
    set(handles1.file1Opt,'str', fnameStr);
    set(handles1.file2Opt,'str', fnameStr);
end

if exist('handles2', 'var') && isfield(handles2,'file1Opt')
    set(handles2.file1Opt,'str', fnameStr);
    set(handles2.file2Opt,'str', fnameStr);
end