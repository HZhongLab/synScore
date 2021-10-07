function h_finalizeSpineAssigment3(handles)

global h_img3;  

[currentInd2, handles2, currentStruct2, currentStructName2] = h_getCurrendInd3(handles);% "2" is "Current"

structNames = fieldnames(h_img3);
for i = 1:length(structNames)
    if ~strcmpi(structNames{i}, currentStructName2) && ~strcmpi(structNames{i}, 'common')%only set other instances
        fileTypeValue(i) = h_img3.(structNames{i}).state.fileTypeForSynAnalysis.value;
    else
        fileTypeValue(i) = nan;
    end
end
I = find(fileTypeValue==3);
if ~isempty(I) && length(I)==1
    [currentInd1, handles1, currentStruct1, currentStructName1] = h_getCurrendInd3(h_img3.(structNames{I}).gh.currentHandles);
else
    disp('Error! Possibly no ''Previous'' file opened.');
    return;
end

currentFileName2 = get(handles2.currentFileName, 'String');% "1" is previous, "2" is current.
currentFileName1 = get(handles1.currentFileName, 'String');

if strcmpi(currentFileName2, currentFileName1)
    display('Error! Previous and Current files are the same!');
    return;
end

analysisNumber1 = currentStruct1.state.analysisNumber.value;
analysisNumber2 = currentStruct2.state.analysisNumber.value;

ROI1Handle_All = findobj(handles1.imageAxes,'tag', 'annotationROI3');
ROI2Handle_All = findobj(handles2.imageAxes,'tag', 'annotationROI3');

if isempty(ROI1Handle_All) || isempty(ROI1Handle_All)
    display('please select ROIs in the appropriate h_imstack3 windowns')
    return;
end

UData1 = get(ROI1Handle_All, 'UserData');
UData2 = get(ROI2Handle_All, 'UserData');

if iscell(UData1)
    UData1 = cell2mat(UData1);
end
if iscell(UData2)
    UData2 = cell2mat(UData2);
end

synapseAnalysis1 = [UData1.synapseAnalysis];
synapseAnalysis2 = [UData2.synapseAnalysis];

maxSynapseNumber1 = max([synapseAnalysis1.maxSynapseNumber]);
maxSynapseNumber2 = max([synapseAnalysis2.maxSynapseNumber]);
maxSynapseNumber = max([maxSynapseNumber1, maxSynapseNumber2]);

ROINumber1 = [UData1.number];
ROINumber2 = [UData2.number];

[ROINumber1,I1] = sort(ROINumber1);
[ROINumber2,I2] = sort(ROINumber2);

ROI1Handle_All = ROI1Handle_All(I1);
ROI2Handle_All = ROI2Handle_All(I2);
AllROIHandles = vertcat(ROI1Handle_All,ROI2Handle_All);

UData1 = UData1(I1);
UData2 = UData2(I2);

synapseAnalysis2 = [UData2.synapseAnalysis];
synapseNumber2 = [synapseAnalysis2.synapseNumber];%this is the spine number of file#2 ROIs.

for i = 1:length(ROI1Handle_All)
    UData = get(ROI1Handle_All(i), 'UserData');
    if UData.synapseAnalysis.synapseNumber < 0 %if it has not been assigned, assigned it as a new spine.
        maxSynapseNumber = maxSynapseNumber + 1;
        UData.synapseAnalysis.synapseNumber = maxSynapseNumber;
        UData.synapseAnalysis.synapseStatus = 'new';
        set(UData.texthandle,'String', ['S',num2str(UData.synapseAnalysis.synapseNumber)]);
    end
    
    % if there is a real synapse number, see whether it is the last one.
    if ~ismember(UData.synapseAnalysis.synapseNumber, synapseNumber2)
        UData.synapseAnalysis.isLast = 1;
    end
    
    UData.synapseAnalysis.nextFileName = currentFileName2;
    UData.synapseAnalysis.nextAnalysisNumber = analysisNumber2;
    set(ROI1Handle_All(i),'UserData',UData);
    set(UData.texthandle,'UserData',UData);
end

for i = 1:length(ROI2Handle_All)
    UData = get(ROI2Handle_All(i), 'UserData');
    if UData.synapseAnalysis.synapseNumber < 0 %if it has not been assigned, assigned it as a new spine.
        maxSynapseNumber = maxSynapseNumber + 1;
        UData.synapseAnalysis.synapseNumber = maxSynapseNumber;
        UData.synapseAnalysis.synapseStatus = 'new';
        set(UData.texthandle,'String', ['S',num2str(UData.synapseAnalysis.synapseNumber)]);
    end
    UData.synapseAnalysis.previousFileName = currentFileName1;
    UData.synapseAnalysis.previousAnalysisNumber = analysisNumber1;
    set(ROI2Handle_All(i),'UserData',UData);
    set(UData.texthandle,'UserData',UData);
end

for i = 1:length(AllROIHandles)%one more round to reset the maxSynapseNumber
    UData = get(AllROIHandles(i), 'UserData');
    UData.synapseAnalysis.maxSynapseNumber = maxSynapseNumber;
    set(AllROIHandles(i),'UserData',UData);
    set(UData.texthandle,'UserData',UData);
end

h_saveAnnotationROI3(handles1);
h_saveAnnotationROI3(handles2);
pause(0.3)%Haining_2015-11-01 to make sure that the files becomes available (there has been error later).

h_annotationROIQuality3(handles1);
h_annotationROIQuality3(handles2);

ROI1Handle = findobj(handles1.imageAxes,'tag', 'annotationROI3', 'Selected', 'on');
ROI2Handle = findobj(handles2.imageAxes,'tag', 'annotationROI3', 'Selected', 'on');
isDeletion = 0;
h_selectCurrentAnnotationROI3(handles1, ROI1Handle, isDeletion);
h_selectCurrentAnnotationROI3(handles2, ROI2Handle, isDeletion);


% now update maxSynapseNumber for all linked files. Part of the codes are
% copied from h_retreiveSpineAnalysis2, and may not be optimized for this
% purpose.
[filepath, filename] = fileparts(currentFileName1);
startingAnalysisFileName  = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber1),'.mat']);
if exist(startingAnalysisFileName,'file')
    load(startingAnalysisFileName, 'annotationROIUserdata');
    while ~isempty(annotationROIUserdata(1).synapseAnalysis.previousFileName)%get all files before the starting file
        [filepath, filename, fExt] = fileparts(annotationROIUserdata(1).synapseAnalysis.previousFileName);
        analysisNumber = annotationROIUserdata(1).synapseAnalysis.previousAnalysisNumber;
        currentFileName = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
        if exist(currentFileName,'file')
            load(currentFileName, 'annotationROIUserdata');
            for i = 1:length(annotationROIUserdata)
                annotationROIUserdata(i).synapseAnalysis.maxSynapseNumber = maxSynapseNumber;
            end
            save(currentFileName, 'annotationROIUserdata');
        else
            error(['file not exist: ', currentFileName])
        end
    end
else
    error(['file not exist: ', startingAnalysisFileName])
end

[filepath, filename] = fileparts(currentFileName2);
startingAnalysisFileName  = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber2),'.mat']);
if exist(startingAnalysisFileName,'file')
    load(startingAnalysisFileName, 'annotationROIUserdata');
    while ~isempty(annotationROIUserdata(1).synapseAnalysis.nextFileName)%get all files after the starting file
        [filepath, filename, fExt] = fileparts(annotationROIUserdata(1).synapseAnalysis.nextFileName);
        analysisNumber = annotationROIUserdata(1).synapseAnalysis.nextAnalysisNumber;
        currentFileName = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
        if exist(currentFileName,'file')
            load(currentFileName, 'annotationROIUserdata');
            for i = 1:length(annotationROIUserdata)
                annotationROIUserdata(i).synapseAnalysis.maxSynapseNumber = maxSynapseNumber;
            end
            save(currentFileName, 'annotationROIUserdata');
        else
            error(['file not exist: ', currentFileName])
        end
    end  
else
    error(['file not exist: ', startingAnalysisFileName])
end
