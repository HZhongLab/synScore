function h_saveDefault3(handles)

global h_img3

[currentInd, handles, currentStruct] = h_getCurrendInd3(handles);

Default.greenLimitStrLow.String = get(handles.greenLimitStrLow,'String');
Default.greenLimitStrHigh.String = get(handles.greenLimitStrHigh,'String');
Default.redLimitStrLow.String = get(handles.redLimitStrLow,'String');
Default.redLimitStrHigh.String = get(handles.redLimitStrHigh,'String');
Default.blueLimitStrLow.String = get(handles.blueLimitStrLow,'String');
Default.blueLimitStrHigh.String = get(handles.blueLimitStrHigh,'String');
Default.imageMode.Value = get(handles.imageMode,'Value');
Default.viewingAxisControl.Value = get(handles.viewingAxisControl,'Value');
Default.colorMapOpt.Value = get(handles.colorMapOpt,'Value');
Default.ratioBetweenAxes.String = get(handles.ratioBetweenAxes,'String');
Default.maxProjectionOpt.Value = get(handles.maxProjectionOpt,'Value');
Default.smoothImage.Value = get(handles.smoothImage,'Value');
Default.gamma.String = get(handles.gamma,'String');
Default.state = currentStruct.state;

% p = [path,';'];
% I = strfind(p,';');
% I = horzcat(0,I);
% I2 = strfind(p,'h_imstack2;');
% pname = p(max(I(I<I2))+1:min(I(I>I2))-1);

FID = fopen('h_imstack3.m');
filename = fopen(FID);
fclose(FID);
pname = fileparts(filename);

% if exist('C:\MATLAB6p5\work\haining\h_imstack2')==7
%     pname = 'C:\MATLAB6p5\work\haining\h_imstack2';
% elseif exist('C:\MATLAB6p5p2\work\haining\h_imstack2')==7
%     pname = 'C:\MATLAB6p5p2\work\haining\h_imstack2';
% else
% %     D = h_dir('C:\MATLAB6p5\work\h_imstack2.m','/s');
% %     pname = fileparts(D(1).name);
% end

currentPath = pwd;
cd (pname);
save h_imstack3Default.mat Default;
cd (currentPath);
