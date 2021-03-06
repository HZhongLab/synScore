function h_loadDefault3(handles)

global h_img3;

[currentInd, handles, currentStruct] = h_getCurrendInd3(handles);

try
%     if exist('C:\MATLAB6p5\work\haining\h_imstack2\h_imstack2Default.mat')==2
        load('h_imstack3Default.mat');
%     elseif exist('C:\MATLAB6p5p2\work\haining\h_imstack2\h_imstack2Default.mat')==2
%         load('C:\MATLAB6p5p2\work\haining\h_imstack2\h_imstack2Default.mat');
%     end
    
    ss_setPara(handles.h_imstack3,Default);
    currentStruct.state = Default.state;
    h_img3.(['I', num2str(currentInd)]) = currentStruct;
    h_setParaAccordingToState3(handles);
catch
    currentStruct.state.lockROI.value = 0; %get(handles.lockROI, 'Value');
    currentStruct.state.roiShapeOpt.value = 1; %get(handles.roiShapeOpt,'Value');
    currentStruct.state.analysisNumber.value = 1; %get(handles.analysisNumber,'Value');
    currentStruct.state.channelForZ.value = 1; %get(handles.channelForZ,'Value');
    h_img3.(['I', num2str(currentInd)]) = currentStruct;
end

try
    if isfield(currentStruct.image,'data')
        [xlim,ylim,zlim] = h_getLimits3(handles);
        set(handles.zStackStrLow,'String', num2str(zlim(1)));
        set(handles.zStackStrHigh,'String', num2str(zlim(2)));
        h_zstackQuality3(handles);
        set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
        h_replot3(handles);
        h_roiQuality3(handles);
        h_updateInfo3(handles);
    end
end