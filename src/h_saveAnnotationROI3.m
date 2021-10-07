function h_saveAnnotationROI3(handles)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

roiobj = sort(findobj(handles.imageAxes,'Tag', 'annotationROI3'));
bgRoiobj = sort(findobj(handles.imageAxes,'Tag', 'BGROI3'));
fiducialObj = findobj(handles.imageAxes, 'Tag', 'fiducialPoint3');


annotationROIUserdata = get(roiobj,'UserData');
if length(roiobj)>1
    annotationROIUserdata = cell2mat(annotationROIUserdata);
end
BGROIUserdata = get(bgRoiobj,'UserData');
fiducialUserData = get(fiducialObj, 'UserData');


fname = get(handles.currentFileName,'String');
[filepath, filename, fExt] = fileparts(fname);

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%
if ~exist(fullfile(filepath,'Analysis'),'dir')
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = currentStruct.state.analysisNumber.value;

fname = fullfile(filepath,'Analysis',[filename,'_annotationRoiV3_A',num2str(analysisNumber),'.mat']);
save(fname, 'annotationROIUserdata', 'BGROIUserdata', 'fiducialUserData');

h_updateInfo3(handles);