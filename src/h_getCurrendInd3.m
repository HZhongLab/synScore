function [currentInd, currentHandles, currentStruct, currentStructName] = h_getCurrendInd3(handles)

global h_img3;

if ~exist('handles', 'var') || isempty(handles)
    handles = guihandles(gcf);
end

UData = get(handles.h_imstack3,'UserData');
currentInd = UData.instanceInd;

if ~strcmp(get(handles.h_imstack3,'Name'), ['h_imstack3.',num2str(currentInd)])
    error('index and window name do not match!');
end

currentStructName = ['I', num2str(currentInd)];
currentHandles = h_img3.(currentStructName).gh.currentHandles;
currentStruct = h_img3.(currentStructName);


