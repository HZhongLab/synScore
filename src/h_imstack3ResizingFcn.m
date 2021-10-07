function h_imstack3ResizingFcn(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

str = get(handles.hideControls, 'String');
pos = get(handles.h_imstack3, 'position');

if strcmp(str, '<<') %large state
    defaultWidth = 801;
elseif strcmp(str, '>>') %small state
    defaultWidth = 475;
end

defaultHeight = 551;

ratio = defaultWidth/defaultHeight;
pos = get(handles.h_imstack3, 'position');
pos(4) = pos(3)/ratio;
set(handles.h_imstack3, 'position', pos);

handleFields = fieldnames(handles);
fontSize = 8/defaultWidth*pos(3);
exceptionListStr = exceptionList;
for i = 1:length(handleFields)
    if ~any(ismember(lower(handleFields{i}), lower(exceptionListStr)))%Haining a quick fix try not to change ROI labeling, but some icons has ROI in it too...
        try, set(handles.(handleFields{i}), 'fontsize', fontSize);end%some properties do not have "fontsize" property.
    end
end

function listStr = exceptionList

listStr = { 'refROIText3';
            'scoringROI3text';
            'h_tracingMarkText3'
          };