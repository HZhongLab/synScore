function h_spineAssignment3(handles2, flag)

global h_img3;  

[currentInd2, handles2, currentStruct2, currentStructName2] = h_getCurrendInd3(handles2);% "2" is "Current"

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
else
    %         [pname, fname, fExt] = fileparts(currentFileName2);
    
    analysisNumber1 = currentStruct1.state.analysisNumber.value;
    analysisNumber2 = currentStruct2.state.analysisNumber.value;
    
    ROI1Handle = findobj(handles1.imageAxes,'tag', 'annotationROI3', 'Selected', 'on');
    ROI1Handle_All = findobj(handles1.imageAxes,'tag', 'annotationROI3');
    ROI2Handle = findobj(handles2.imageAxes,'tag', 'annotationROI3', 'Selected', 'on');
    ROI2Handle_All = findobj(handles2.imageAxes,'tag', 'annotationROI3');
    ROI1UData = get(ROI1Handle,'UserData');
    ROI2UData = get(ROI2Handle,'UserData');
    
    if isempty(ROI1Handle) || isempty(ROI2Handle)
        display('please select ROIs in both ''Previous'' and ''Current'' images')
        return;
    end
    
    % find out the maximum spine number.
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
    
    if strcmp(flag,'~=') %if it is to disassociate the two spines
        if ROI1UData.synapseAnalysis.synapseNumber == ROI2UData.synapseAnalysis.synapseNumber % only if two linked spines are selected
            ROI2UData.synapseAnalysis.synapseNumber = -1;
            ROI2UData.synapseAnalysis.synapseStatus = '';
            set(ROI2UData.texthandle,'String', num2str(ROI2UData.number), 'UserData', ROI2UData);
            set(ROI2Handle, 'UserData', ROI2UData);
        end
    else %to associate two spines.
        if ROI1UData.synapseAnalysis.isLast>0
            disp(['Warning: the current file #1 synapse was assigned "last" synapse!  ROI# = ', num2str(ROI1UData.number),...
                '  synapse# = ', num2str(ROI1UData.synapseAnalysis.synapseNumber)]);
            ROI1UData.synapseAnalysis.isLast = 0;
        end
        if strcmp(ROI2UData.synapseAnalysis.synapseStatus,'new')
            disp(['Warning: the current file #2 synapse was assigned "new" synapse!  ROI# = ', num2str(ROI2UData.number),...
                '  synapase# = ', num2str(ROI2UData.synapseAnalysis.synapseNumber)]);
        end
        if ROI1UData.synapseAnalysis.synapseNumber > 0
            synapseNumber = ROI1UData.synapseAnalysis.synapseNumber;
            ROI2UData.synapseAnalysis.synapseNumber = synapseNumber;
            ROI2UData.synapseAnalysis.synapseStatus = flag;
            
            %                 %make sure that no other spines can have the same spine number
            %                 maxSynapseNumber = max([ROI1UData.synapseAnalysis.maxSynapseNumber, ROI2UData.synapseAnalysis.maxSynapseNumber]);
        else
            %                 % first find the maximum spine number that has been
            %                 % assigned
            %                 maxSynapseNumber = max([ROI1UData.synapseAnalysis.maxSynapseNumber, ROI2UData.synapseAnalysis.maxSynapseNumber]);
            synapseNumber = maxSynapseNumber + 1;
            ROI1UData.synapseAnalysis.synapseNumber = synapseNumber;
            ROI2UData.synapseAnalysis.synapseNumber = synapseNumber;
            ROI1UData.synapseAnalysis.synapseStatus = 'new';
            ROI2UData.synapseAnalysis.synapseStatus = flag;
            
            maxSynapseNumber = synapseNumber;
        end
        
        set(ROI1UData.texthandle,'String', ['S', num2str(synapseNumber)], 'UserData', ROI1UData);
        set(ROI2UData.texthandle,'String', ['S', num2str(synapseNumber)], 'UserData', ROI2UData);
        set(ROI1Handle, 'UserData', ROI1UData);
        set(ROI2Handle, 'UserData', ROI2UData);
        
        for i = 1:length(ROI1Handle_All)
            UData = get(ROI1Handle_All(i), 'UserData');
            UData.synapseAnalysis.maxSynapseNumber = maxSynapseNumber;
            UData.synapseAnalysis.nextFileName = get(handles2.currentFileName, 'String');
            UData.synapseAnalysis.nextAnalysisNumber = analysisNumber2;
            if ROI1Handle_All(i) ~= ROI1Handle && UData.synapseAnalysis.synapseNumber == synapseNumber;
                % this should has never happen!
                warning('Different ''Previous'' image ROIs has the same number. This should not have happen. Talk to Haining!')
                %                     UData.synapseAnalysis.synapseNumber = -1;
                %                     UData.synapseAnalysis.synapseStatus = '';
                % above lines: don't change because the spine statuts may be set earlier.
                %                     set(UData.texthandle,'String', num2str(UData.number));
            end
            set(ROI1Handle_All(i),'UserData',UData);
            set(UData.texthandle,'UserData',UData);
        end
        for i = 1:length(ROI2Handle_All)
            UData = get(ROI2Handle_All(i), 'UserData');
            UData.synapseAnalysis.maxSynapseNumber = maxSynapseNumber;
            UData.synapseAnalysis.previousFileName = get(handles1.currentFileName, 'String');
            UData.synapseAnalysis.previousAnalysisNumber = analysisNumber1;
            if ROI2Handle_All(i) ~= ROI2Handle && UData.synapseAnalysis.synapseNumber == synapseNumber;
                UData.synapseAnalysis.synapseNumber = -1;
                UData.synapseAnalysis.synapseStatus = '';
                set(UData.texthandle,'String', num2str(UData.number));
            end
            set(ROI2Handle_All(i),'UserData',UData);
            set(UData.texthandle,'UserData',UData);
        end
    end
end
h_annotationROIQuality3(handles1);
h_annotationROIQuality3(handles2);

isDeletion = 0;
h_selectCurrentAnnotationROI3(handles1, ROI1Handle, isDeletion);
h_selectCurrentAnnotationROI3(handles2, ROI2Handle, isDeletion);
