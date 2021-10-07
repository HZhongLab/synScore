function h_loadAnnotatedRoiData3(handles, flag)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);
analysisNumber = currentStruct.state.analysisNumber.value;

objs = [findobj(handles.imageAxes,'Tag','annotationROI3');findobj(handles.imageAxes,'Tag','BGROI3');...
    findobj(handles.imageAxes,'Tag','fiducialPoint3')];
for i = 1:length(objs)
    UserData = get(objs(i),'UserData');
    delete(objs(i));
    if isfield(UserData, 'texthandle')
        delete(UserData.texthandle);
    end
end

switch flag
    case 'v3'
        roiFilename = fullfile(pname,'Analysis',[fname,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
        if exist(roiFilename, 'file')
            load(roiFilename);
        else
            disp(['File not exist (please check A#): ', roiFilename]);
            return;
        end
    case 'v2'
        roiFilename = fullfile(pname,'Analysis',[fname,'_annotationRoi',num2str(analysisNumber),'.mat']);
        if exist(roiFilename, 'file')
            load(roiFilename);
        else
            disp(['File not exist (please check A#): ', roiFilename]);
            return;
        end
        % rename v2 fields.
        if exist('annotationROIUserdata', 'var') && ~isempty('annotationROIUserdata')
            v2AnnotationROIUserdata = annotationROIUserdata;
            clear annotationROIUserdata;
            for i = 1:length(v2AnnotationROIUserdata)
                clear UserData;
                UserData.roi = v2AnnotationROIUserdata(i).roi;
                UserData.texthandle = v2AnnotationROIUserdata(i).texthandle;
                UserData.number = v2AnnotationROIUserdata(i).number;
                UserData.ROIhandle = v2AnnotationROIUserdata(i).ROIhandle;
                UserData.timeLastClick = v2AnnotationROIUserdata(i).timeLastClick;
                UserData.synapseAnalysis.synapseNumber = v2AnnotationROIUserdata(i).spineAnalysis.spineNumber;
                UserData.synapseAnalysis.maxSynapseNumber = v2AnnotationROIUserdata(i).spineAnalysis.maxSpineNumber;
                UserData.synapseAnalysis.synapseStatus = v2AnnotationROIUserdata(i).spineAnalysis.spineStatus;
                UserData.synapseAnalysis.isLast = v2AnnotationROIUserdata(i).spineAnalysis.isLast;
                UserData.synapseAnalysis.isSpine = v2AnnotationROIUserdata(i).spineAnalysis.isSpine;
                UserData.synapseAnalysis.synapseConfidence = v2AnnotationROIUserdata(i).spineAnalysis.spineConfidence;
                UserData.synapseAnalysis.previousFileName = v2AnnotationROIUserdata(i).spineAnalysis.previousFileName;
                UserData.synapseAnalysis.previousAnalysisNumber = v2AnnotationROIUserdata(i).spineAnalysis.previousAnalysisNumber;
                UserData.synapseAnalysis.nextFileName = v2AnnotationROIUserdata(i).spineAnalysis.nextFileName;
                UserData.synapseAnalysis.nextAnalysisNumber = v2AnnotationROIUserdata(i).spineAnalysis.nextAnalysisNumber;
                UserData.synapseAnalysis.note = v2AnnotationROIUserdata(i).spineAnalysis.note;
                UserData.currentSettings = v2AnnotationROIUserdata(i).currentSettings;
                annotationROIUserdata(i) = UserData;
            end
        end
    otherwise
        return;
end



axes(handles.imageAxes);

if exist('annotationROIUserdata', 'var') && ~isempty('annotationROIUserdata')
    for i = 1:length(annotationROIUserdata)
        hold on;
        UserData = annotationROIUserdata(i);
        h = plot(UserData.roi.xi,UserData.roi.yi,'m:', 'linewidth', 1);
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'annotationROI3', 'Color','black', 'EraseMode','xor');
        hold off;
        
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        
        if UserData.synapseAnalysis.synapseNumber > 0
            textStr = ['S',num2str(UserData.synapseAnalysis.synapseNumber)];
        else
            textStr = num2str(UserData.number);
        end

        UserData.texthandle = text(x,y,textStr,'HorizontalAlignment', 'Center','VerticalAlignment','Middle', ...
            'Color','black', 'EraseMode','xor','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    end
end

if exist('fiducialUserData', 'var') && isfield(fiducialUserData,'x')
    UserData = fiducialUserData;    
    hold on;
    h = plot(UserData.x,UserData.y,'b*','EraseMode', 'XOR', 'MarkerSize', 14, 'Tag', 'fiducialPoint3');
    UserData.ROIhandle = h;
    UserData.timeLastClick = clock;
    set(h,'UserData',UserData);
end

if exist('BGROIUserdata', 'var') && isfield(BGROIUserdata,'roi')
    UserData = BGROIUserdata;

    hold on;
    h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
    set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'BGROI3');
    hold off;

    x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
    y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
    UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
        'Center','VerticalAlignment','Middle', 'Color','black', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText3', 'FontSize', 14, 'FontWeight', 'Bold');
    UserData.number = 'BG';
    UserData.ROIhandle = h;
    UserData.timeLastClick = clock;
    set(h,'UserData',UserData);
    set(UserData.texthandle,'UserData',UserData);
end

h_annotationROIQuality3(handles);
            
    