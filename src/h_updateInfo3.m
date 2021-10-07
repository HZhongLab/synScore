function h_updateInfo3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);



pos = get(handles.h_imstack3, 'position');% adjust font size accordingly
defaultHeight = 551;
sizRatio = pos(4)/defaultHeight;
global jbm



try
    if isfield(handles, 'analyzedInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_V3roi_A*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_V3roi_A');
                num = roiFilesName(pos+8:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.analyzedInfo,'String',[numStr, 'analyzed!'],'ForegroundColor','red');
            set(handles.loadAnalyzedRoiData,'Enable','on');

        else
            set(handles.analyzedInfo,'String','Not-Analyzed','ForegroundColor','black');
            set(handles.loadAnalyzedRoiData,'Enable','off');
        end
    end
end
   
try
    if isfield(handles, 'v1AnalyzedInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_zroi*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_zroi');
                num = roiFilesName(pos+5:end);%find out analysis number (string).
                if isempty(num)
                    num = '1';
                end
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.v1AnalyzedInfo,'String',['v1: ', numStr, 'analyzed!'],'ForegroundColor','red');
            set(handles.loadV1AnalyzedROI,'Enable','on');
        else
            set(handles.v1AnalyzedInfo,'String','V1 Not-Analyzed.','ForegroundColor','black');
            set(handles.loadV1AnalyzedROI,'Enable','off');
        end
    end
end

try
    if isfield(handles, 'v2AnalyzedInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_roi*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_roi');
                num = roiFilesName(pos+4:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.v2AnalyzedInfo,'String',['v2: ', numStr, 'analyzed!'],'ForegroundColor','red');
            set(handles.loadV2AnalyzedROI,'Enable','on');
        else
            set(handles.v2AnalyzedInfo,'String','V2 Not-Analyzed.','ForegroundColor','black');
            set(handles.loadV2AnalyzedROI,'Enable','off');
        end
    end
end
   
try
    if isfield(handles, 'paAnalysisInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_pa', num2str(analysisNumber),'.mat']);
        if exist(roiFilename,'file')
            set(handles.paAnalysisInfo,'String','Pre-Analyzed!','ForegroundColor','red');
            set(handles.loadAnalyzedPARoiData,'Enable','on');
        else
            set(handles.paAnalysisInfo,'String','Not-Analyzed.','ForegroundColor','black');
            set(handles.loadAnalyzedPARoiData,'Enable','off');
        end
    end
end

try
    if isfield(handles, 'annotationROIInfo')
        analysisNumber = currentStruct.state.analysisNumber.value;
        roiFilename = fullfile(pname,'Analysis',[fname,'_annotationRoiV3_A*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_annotationRoiV3_A');
                num = roiFilesName(pos+18:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.annotationROIInfo,'String',[numStr, 'available!'],'ForegroundColor','red');
            set(handles.loadAnnotationRoiData,'Enable','on');
        else
            set(handles.annotationROIInfo,'String','Not-Annotated','ForegroundColor','black');
            set(handles.loadAnnotationRoiData,'Enable','off');
        end
    end
end 

try
    if isfield(handles, 'v2AnnotationROIInfo')
        analysisNumber = currentStruct.state.analysisNumber.value;
        roiFilename = fullfile(pname,'Analysis',[fname,'_annotationRoi*.mat']);
        roiFiles = h_dir(roiFilename);
        
        I = false(length(roiFiles), 1);
        for i = 1:length(roiFiles) % remove those are v3.
            if ~isempty(strfind(roiFiles(i).name,'_annotationRoiV3_A'))
                I(i) = true;
            end
        end
        roiFiles(I) = [];
        
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_annotationRoi');
                num = roiFilesName(pos+14:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.v2AnnotationROIInfo,'String',['v2: ', numStr, 'available!'],'ForegroundColor','red');
            set(handles.loadV2AnnotationRoiData,'Enable','on');
        else
            set(handles.v2AnnotationROIInfo,'String','Not-Annotated','ForegroundColor','black');
            set(handles.loadV2AnnotationRoiData,'Enable','off');
        end
    end
end 
   
try
    if isfield(handles,'imgGroupInfo')
        groupFilename = [pname,'Analysis\',fname,'_grp.mat'];
        if exist(groupFilename,'file')
            load(groupFilename);
        end
        if exist('groupName','var') && ~isempty(groupName)
            [currentStruct.imgGroupInfo.groupPath,currentStruct.imgGroupInfo.groupName] = h_analyzeFilename(groupName);
            set(handles.imgGroupInfo,'String',['Image grouped in ',currentStruct.imgGroupInfo.groupName]);
            if isfield(handles, 'loadCurrentImgGroup')
                set(handles.loadCurrentImgGroup,'Enable','on');
            end
        else
            set(handles.imgGroupInfo,'String','Image un-grouped');
            if isfield(handles, 'loadCurrentImgGroup')
                set(handles.loadCurrentImgGroup,'Enable','off');
            end
            currentStruct.imgGroupInfo = [];
        end
    end
end

try
    if isfield(currentStruct,'activeGroup') && ~isempty(currentStruct.activeGroup.groupName)
        currentFilename = get(handles.currentFileName,'String');
        [pname,fname,fExt] = fileparts(currentFilename);
        if ~isempty(currentStruct.activeGroup.groupFiles)
            groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
            index = find(ismember(groupFileNames, [fname, fExt]));
        else
            index = [];
        end
        
        if isempty(index)
            imgStatusStr = 'n.i.';
        else
            imgStatusStr = num2str(index);
        end
        set(handles.currentGroupInfo,'String',['Group: ',currentStruct.activeGroup.groupName,...
                '  (',imgStatusStr,' out of ' num2str(length(currentStruct.activeGroup.groupFiles)),')'],...
                'FontSize',9*sizRatio);
        set(handles.openFirstInGroup,'Enable','on');
        set(handles.openPreviousInGroup,'Enable','on');
        set(handles.openNextInGroup,'Enable','on');
        set(handles.openLastInGroup,'Enable','on');
        set(handles.openAllInGrp, 'Enable', 'on');
    else
        set(handles.currentGroupInfo,'String','Group: None','FontSize',9*sizRatio);
        set(handles.openFirstInGroup,'Enable','off');
        set(handles.openPreviousInGroup,'Enable','off');
        set(handles.openNextInGroup,'Enable','off');
        set(handles.openLastInGroup,'Enable','off');
        set(handles.openAllInGrp, 'Enable', 'off');
    end
end

try
    if isfield(handles, 'tracingDataInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_V3tracing_A*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_V3tracing_A');
                num = roiFilesName(pos+12:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.tracingDataInfo,'String',[numStr, 'tracing data available!'],'ForegroundColor','red');
            set(handles.loadTracingData,'Enable','on');
        else
            set(handles.tracingDataInfo,'String','No tracing data available.','ForegroundColor','black');
            set(handles.loadTracingData,'Enable','off');
        end
    end
end

try
    if isfield(handles, 'v2TracingDataInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_tracing*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_tracing');
                num = roiFilesName(pos+8:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.v2TracingDataInfo,'String',['v2: ', numStr, 'tracing data available!'],'ForegroundColor','red');
            set(handles.loadV2TracingData,'Enable','on');
        else
            set(handles.v2TracingDataInfo,'String','v2: No tracing data available.','ForegroundColor','black');
            set(handles.loadV2TracingData,'Enable','off');
        end
    end
end

% try
%     h_updateSpineAnalysisFileInfo3(handles);
% end