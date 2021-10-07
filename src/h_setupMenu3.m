function h_setupMenu3(handles, flag)

global h_img3;
global jbm;

if ~exist('flag', 'var') || isempty(flag)
    flag = 'upper';
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if strcmpi(flag, 'upper')
    area_width = 330/801;
    area_height = 3/11;
    area_x = (801-330)/801;
    area_y = 3/11;
    value = get(handles.upperMenuOpt,'Value');
    if value ~= get(handles.lowerMenuOpt,'Value');% upper and lower Menu cannot have the same value.
        currentStruct.state.upperMenuOpt.value = value;
        if isfield(currentStruct.gh,'upperMenuObj') && ~isempty(currentStruct.gh.upperMenuObj)
            delete(currentStruct.gh.upperMenuObj);
            currentStruct.gh.upperMenuObj = [];
            
        end
    else
        return;
    end
elseif strcmpi(flag, 'lower')
    area_width = 330/801;
    area_height = 3/11;
    area_x = (801-330)/801;
    area_y = 0;
    value = get(handles.lowerMenuOpt,'Value');
    if value ~= get(handles.upperMenuOpt,'Value');% upper and lower Menu cannot have the same value.
        currentStruct.state.lowerMenuOpt.value = value;
        if isfield(currentStruct.gh,'lowerMenuObj')&& ~isempty(currentStruct.gh.lowerMenuObj)
            delete(currentStruct.gh.lowerMenuObj);
            currentStruct.gh.lowerMenuObj = [];
            
        end
    else
        return;
    end
else
    return;
end

h = [];
switch value
    case 1
        h = h_roiControlGUI3;
    case 2
    case 3
        h = h_groupControlGUI3;
    case 4
    case 5
    case 6
    case 7
    case 8
    case 11
        h = h_PALMAnalysisGUI3;
    case 12
        h = h_proteinGelAnalysisGUI3;
    case 13
        h = h_spineAnalysisGUI3;
    case 14
        h = h_spineAnalysis2GUI3;
    case 15
        h = h_CASpineDetectionGUI3;
    case 16
        h = jbm_synapseScoringGUI3;
    case 17
        h = jbm_dendriteSkeletonGUI3;
        
    case 18
        h = jbm_weightExtractGUI3;
end

set(h,'Visible','off');



obj = get(h,'Children');
set(obj,'Units','normalized','Visible','off');
C = h_copyobj(obj,handles.h_imstack3);
for i = 1:length(C)
    pos = get(C(i),'Position');
    pos(1) = area_x + area_width*pos(1);
    pos(2) = area_y + area_height*pos(2);
    pos(3) = area_width*pos(3);
    pos(4) = area_height*pos(4);
    set(C(i),'Position',pos);
end
set(C,'Visible','on');
if strcmpi(flag, 'upper')
    currentStruct.gh.upperMenuObj = C;
elseif strcmpi(flag, 'lower')
    currentStruct.gh.lowerMenuObj = C;
end

delete(h);

currentStruct.gh.currentHandles = guihandles(handles.h_imstack3);
h_img3.(currentStructName) = currentStruct;
h_setParaAccordingToState3(currentStruct.gh.currentHandles);
h_updateInfo3(handles);
if isfield(jbm,'scoringData')
jbm_synapsescoringengine('updateinfo',handles);
else
end
if value==13
    h_fileTypeQuality3(handles);
    h_selectCurrentAnnotationROI3(handles);
end

h_imstack3ResizingFcn(handles);