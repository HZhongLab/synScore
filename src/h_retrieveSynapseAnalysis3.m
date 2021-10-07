function Aout = h_retrieveSynapseAnalysis3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

fname = get(handles.currentFileName,'String');
[filepath, filename, fExt] = fileparts(fname);
analysisNumber = currentStruct.state.analysisNumber.value;

startingAnalysisFileName  = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
Aout.analysisFileName{1} = startingAnalysisFileName;

if exist(startingAnalysisFileName,'file')
    load(startingAnalysisFileName, 'annotationROIUserdata');
    while ~isempty(annotationROIUserdata(1).synapseAnalysis.previousFileName)%get all files before the starting file
        [filepath, filename, fExt] = fileparts(annotationROIUserdata(1).synapseAnalysis.previousFileName);
        analysisNumber = annotationROIUserdata(1).synapseAnalysis.previousAnalysisNumber;
        currentFileName = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
        Aout.analysisFileName = vertcat({currentFileName}, Aout.analysisFileName);
        if exist(currentFileName,'file')
            load(currentFileName, 'annotationROIUserdata');
        else
            error(['file not exist: ', currentFileName])
        end
    end
    
    load(startingAnalysisFileName, 'annotationROIUserdata');
    while ~isempty(annotationROIUserdata(1).synapseAnalysis.nextFileName)%get all files after the starting file
        [filepath, filename, fExt] = fileparts(annotationROIUserdata(1).synapseAnalysis.nextFileName);
        analysisNumber = annotationROIUserdata(1).synapseAnalysis.nextAnalysisNumber;
        currentFileName = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
        Aout.analysisFileName = vertcat(Aout.analysisFileName, {currentFileName});
        if exist(currentFileName,'file')
            load(currentFileName, 'annotationROIUserdata');
        else
            error(['file not exist: ', currentFileName])
        end
    end  
else
    error(['file not exist: ', startingAnalysisFileName])
end

% k = 1;
Aout.synapseNumber = [];
Aout.presenceMatrix = zeros(0);
Aout.synapseMovedMatrix = zeros(0);
Aout.isNewMatrix = zeros(0);
Aout.isLastMatrix = zeros(0);
Aout.isSpineMatrix = zeros(0);
Aout.lowSynapseConfidence = zeros(0);
Aout.synapseNotes = {};

for i = 1:length(Aout.analysisFileName)
    currentFileName = Aout.analysisFileName{i};
    load(currentFileName, 'annotationROIUserdata');
    synapseAnalysis = [annotationROIUserdata.synapseAnalysis];
    for j = 1:length(synapseAnalysis)
        I = find(ismember(Aout.synapseNumber, synapseAnalysis(j).synapseNumber));
        if isempty(I)
            Aout.synapseNumber(end+1) = synapseAnalysis(j).synapseNumber;
            I = length(Aout.synapseNumber+1);
        end
        
        Aout.presenceMatrix(I, i) = 1;
        if strcmp(synapseAnalysis(j).synapseStatus,'new')
            Aout.isNewMatrix(I, i) = 1;
        else
            Aout.isNewMatrix(I, i) = 0;
        end
        if strcmp(synapseAnalysis(j).synapseStatus,'moved')
            Aout.synapseMovedMatrix(I, i) = 1;
        else
            Aout.synapseMovedMatrix(I, i) = 0;
        end
        if synapseAnalysis(j).isLast==1
            Aout.isLastMatrix(I, i) = 1;
        else
            Aout.isLastMatrix(I, i) = 0;
        end
        if synapseAnalysis(j).isSpine == 1
            Aout.isSpineMatrix(I, i) = 1;
        else
            Aout.isSpineMatrix(I, i) = 0;
        end
        if strcmp(synapseAnalysis(j).synapseConfidence,'low')
            Aout.lowSynapseConfidence(I, i) = 1;
        else
            Aout.lowSynapseConfidence(I, i) = 0;
        end
        if strcmp(synapseAnalysis(j).note, 'special notes')
            Aout.synapseNotes{I, i} = '';
        else
            Aout.synapseNotes{I, i} = synapseAnalysis(j).note;
        end
    end
end
    
    
    

