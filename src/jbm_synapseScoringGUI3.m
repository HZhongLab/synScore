function varargout = jbm_synapseScoringGUI3(varargin)
% JBM_SYNAPSESCORINGGUI3 M-file for jbm_synapseScoringGUI3.fig
%      JBM_SYNAPSESCORINGGUI3, by itself, creates a new JBM_SYNAPSESCORINGGUI3 or raises the existing
%      singleton*.
%
%      H = JBM_SYNAPSESCORINGGUI3 returns the handle to a new JBM_SYNAPSESCORINGGUI3 or the handle to
%      the existing singleton*.
%
%      JBM_SYNAPSESCORINGGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JBM_SYNAPSESCORINGGUI3.M with the given input arguments.
%
%      JBM_SYNAPSESCORINGGUI3('Property','Value',...) creates a new JBM_SYNAPSESCORINGGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_roiControlGUI2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jbm_synapseScoringGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jbm_synapseScoringGUI3

% Last Modified by GUIDE v2.5 11-Oct-2016 15:45:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jbm_synapseScoringGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @jbm_synapseScoringGUI3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before jbm_synapseScoringGUI3 is made visible.
function jbm_synapseScoringGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jbm_synapseScoringGUI3 (see VARARGIN)

% Choose default command line output for hf_spineAnalysisGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes jbm_synapseScoringGUI3 wait for user response (see UIRESUME)
% uiwait(handles.template);


% --- Outputs from this function are returned to the command line.
function varargout = jbm_synapseScoringGUI3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function template_CreateFcn(hObject, eventdata, handles)
% hObject    handle to template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in new_dataset_push.
function new_dataset_push_Callback(hObject, eventdata, handles)
% hObject    handle to new_dataset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('create new dataset',handles);

% --- Executes on button press in load_dataset_push.
function load_dataset_push_Callback(hObject, eventdata, handles)
% hObject    handle to load_dataset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('load',handles);

% --- Executes on button press in save_dataset_push.
function save_dataset_push_Callback(hObject, eventdata, handles)
% hObject    handle to save_dataset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('save',handles);

% --- Executes on button press in groupload.
function groupload_Callback(hObject, eventdata, handles)
% hObject    handle to groupload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('group load',handles);


% --- Executes on button press in groupzoom_push.
function groupzoom_push_Callback(hObject, eventdata, handles)
% hObject    handle to groupzoom_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('group zoom alignment',handles);


% --- Executes on button press in jbm_hideall_radio.
function jbm_hideall_radio_Callback(hObject, eventdata, handles)
% hObject    handle to jbm_hideall_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of jbm_hideall_radio


% --- Executes on button press in newsynapse_push.
function newsynapse_push_Callback(hObject, eventdata, handles)
% hObject    handle to newsynapse_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('new synapse',handles);


% --- Executes on button press in jbm_closeall.
function jbm_closeall_Callback(hObject, eventdata, handles)
% hObject    handle to jbm_closeall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('close all instances',handles);



function scoringROIsize_Callback(hObject, eventdata, handles)
% hObject    handle to scoringROIsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scoringROIsize as text
%        str2double(get(hObject,'String')) returns contents of scoringROIsize as a double
jbm_synapsescoringengine('update info',handles);

% --- Executes during object creation, after setting all properties.
function scoringROIsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoringROIsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scoringClusterNumber_Callback(hObject, eventdata, handles)
% hObject    handle to scoringClusterNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scoringClusterNumber as text
%        str2double(get(hObject,'String')) returns contents of scoringClusterNumber as a double


% --- Executes during object creation, after setting all properties.
function scoringClusterNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoringClusterNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in verification.
function verification_Callback(hObject, eventdata, handles)
% hObject    handle to verification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedInstance = h_getCurrendInd3(handles);
global jbm;
jbm.scoringData.synapseVerification(double(selectedInstance)) = get(hObject,'Value');
jbm_synapsescoringengine('update verification',handles);


% --- Executes on button press in printNotes.
function printNotes_Callback(hObject, eventdata, handles)
% hObject    handle to printNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('print notes',handles);
% Hint: get(hObject,'Value') returns toggle state of printNotes



function groupZoomFactor_Callback(hObject, eventdata, handles)
% hObject    handle to groupZoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of groupZoomFactor as text
%        str2double(get(hObject,'String')) returns contents of groupZoomFactor as a double

jbm_synapsescoringengine('update info',handles);
% --- Executes during object creation, after setting all properties.
function groupZoomFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupZoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scoringColorScheme.
function scoringColorScheme_Callback(hObject, eventdata, handles)
% hObject    handle to scoringColorScheme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scoringColorScheme
jbm_synapsescoringengine('update info',handles);




% --- Executes on button press in loadDispSettingAcrossGroup.
function loadDispSettingAcrossGroup_Callback(hObject, eventdata, handles)
% hObject    handle to loadDispSettingAcrossGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;

[filename, pathname] = uigetfile('*.dsp', 'Load Grp display setting');

if filename ~= 0 %not "Cancel"
    load(fullfile(pathname, filename), '-mat');
    settingFileNames = {dispPara.filename};
    
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~isempty(strfind(structNames{i}, 'I'))
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            [pathName, fileName, fExt] = fileparts(get(handles1.currentFileName, 'string'));
            currentFileName = [fileName, fExt];
            ind = find(ismember(settingFileNames, currentFileName), 1);
            if ~isempty(ind)
                currentDispPara = dispPara(ind);
                names = fieldnames(currentDispPara);
                for k = 1:length(names)
                    try
                        ptynames = fieldnames(eval(['currentDispPara.',names{k}]));
                        handlename = ['handles1.',names{k}];
                        for j = 1:length(ptynames)
                            varname = ['currentDispPara.',names{k},'.',ptynames{j}];
                            set(eval(handlename),ptynames{j},eval(varname));
                        end
                    end
                end
                h_cLimitQuality3(handles1);
                h_zStackQuality3(handles1);
                h_replot3(handles1);
                
                % load boundary marker
                h = findobj(handles1.imageAxes, 'tag', 'boundaryMark3');
                delete(h);
                hold on
                for k = 1:length(currentDispPara.boundaryMark)
                    if ~isempty(currentDispPara.boundaryMark{k})
                        UserData = currentDispPara.boundaryMark{k};
                        UserData.roiHandle = plot(UserData.xCo,UserData.yCo,'^','MarkerSize',UserData.roiSize, 'Tag', 'boundaryMark3',...
                            'Color','w', 'MarkerFaceColor', 'w', 'EraseMode','normal', 'ButtonDownFcn', 'h_dragBoundaryMark3');
                        UserData.timeLastClick = clock;
               
                        set(UserData.roiHandle, 'UserData', UserData);
                    end
                end
                hold off
            end
        end
    end
end

% --- Executes on button press in saveDispSettingAcrossGrp.
function saveDispSettingAcrossGrp_Callback(hObject, eventdata, handles)
% hObject    handle to saveDispSettingAcrossGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;

structNames = fieldnames(h_img3);
for i = 1:length(structNames)
    if ~isempty(strfind(structNames{i}, 'I'))
        handles1 = h_img3.(structNames{i}).gh.currentHandles;
        [pathName, fileName, fExt] = fileparts(get(handles1.currentFileName, 'string'));
        dispPara(i).filename = [fileName, fExt];
        dispPara(i).redLimitStrHigh.string = get(handles1.redLimitStrHigh, 'String');
        dispPara(i).redLimitStrLow.string = get(handles1.redLimitStrLow, 'String');
        dispPara(i).greenLimitStrHigh.string = get(handles1.greenLimitStrHigh, 'String');
        dispPara(i).greenLimitStrLow.string = get(handles1.greenLimitStrLow, 'String');
        dispPara(i).zStackStrHigh.string = get(handles1.zStackStrHigh, 'String');
        dispPara(i).zStackStrLow.string = get(handles1.zStackStrLow, 'String');
        dispPara(i).imageAxes.xlim = get(handles1.imageAxes, 'xlim');
        dispPara(i).imageAxes.ylim = get(handles1.imageAxes,'ylim');
        dispPara(i).moveHorizontal.value = get(handles1.moveHorizontal,'value');
        dispPara(i).moveHorizontal.SliderStep = get(handles1.moveHorizontal,'SliderStep');
        dispPara(i).moveVertical.value = get(handles1.moveVertical,'value');
        dispPara(i).moveVertical.SliderStep = get(handles1.moveVertical,'SliderStep');
        dispPara(i).moveHorizontal.Enable = get(handles1.moveHorizontal,'Enable');
        dispPara(i).moveVertical.Enable = get(handles1.moveVertical,'Enable');
        h = findobj(handles1.imageAxes, 'tag', 'boundaryMark3');
        UData = get(h, 'UserData');
        if ~iscell(UData)
            UData = {UData};
        end
        dispPara(i).boundaryMark = UData;
    end
end

[filename, pathname] = uiputfile('*.dsp', 'Save Grp display setting');
if filename ~= 0 %not "Cancel"
    save(fullfile(pathname, filename), 'dispPara');
end
 








function synapseNoteField_Callback(hObject, eventdata, handles)
% hObject    handle to synapseNoteField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of synapseNoteField as text
%        str2double(get(hObject,'String')) returns contents of synapseNoteField as a double


% --- Executes during object creation, after setting all properties.
function synapseNoteField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to synapseNoteField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in synapseNoteConfirm.
function synapseNoteConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to synapseNoteConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in noteEdit.
function noteEdit_Callback(hObject, eventdata, handles)
% hObject    handle to noteEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noteEdit
jbm_synapsescoringengine('edit note',handles);


% --- Executes on button press in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('return data',handles);



% --- Executes on button press in hotkeyControls.
function hotkeyControls_Callback(hObject, eventdata, handles)
% hObject    handle to hotkeyControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('update info',handles)
% Hint: get(hObject,'Value') returns toggle state of hotkeyControls


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jbm;
global h_img3;

if ~isfield(jbm,'instancesOpen')
    disp('ERROR: CREATE DATASET');
else
for i = 1:length(jbm.instancesOpen)
    figure(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.h_imstack3);
end
end


% --- Executes on button press in Info.
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img3;

[selectedInstance,handles,currentStruct,currentStructName] = h_getCurrendInd3(handles);

Aout = h_quickinfo(currentStruct.info);
[Aout.filepath, Aout.filename, Aout.fExt] = fileparts(get(handles.currentFileName, 'string'));
Aout


% --- Executes on button press in markBoundary.
function markBoundary_Callback(hObject, eventdata, handles)
% hObject    handle to markBoundary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

obj = get(handles.imageAxes, 'Children');%unselectAll.
set(obj, 'Selected', 'off');%unselectAll.

axes(handles.imageAxes);
button = 0;
while button~=1
    [xCoordinate, yCoordinate, button] = ginput(1);
end
hold on;
ROIsize = 10;
roiHandle = plot(xCoordinate,yCoordinate,'^','MarkerSize',ROIsize, 'Tag', 'boundaryMark3',...
    'Color','w', 'MarkerFaceColor', 'w', 'EraseMode','normal', 'ButtonDownFcn', 'h_dragBoundaryMark3');
hold off;

UserData.roiHandle = roiHandle;
UserData.timeLastClick = clock;
UserData.xCo = xCoordinate;
UserData.yCo = yCoordinate;
UserData.roiSize = ROIsize;

set(roiHandle, 'UserData', UserData);





% --- Executes on button press in loadRefDataSet.
function loadRefDataSet_Callback(hObject, eventdata, handles)
% hObject    handle to loadRefDataSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadRefScoringData3(handles);

% --- Executes on button press in hideScoringDataset.
function hideScoringDataset_Callback(hObject, eventdata, handles)
% hObject    handle to hideScoringDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hideScoringDataset

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.hideScoringDataset.value = currentValue;

h_setDendriteTracingVis3(handles);




% --- Executes on button press in hideRefDataset.
function hideRefDataset_Callback(hObject, eventdata, handles)
% hObject    handle to hideRefDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hideRefDataset

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.hideRefDataset.value = currentValue;

h_setDendriteTracingVis3(handles);


% --- Executes on selection change in scoringGUIPlotOpt.
function scoringGUIPlotOpt_Callback(hObject, eventdata, handles)
% hObject    handle to scoringGUIPlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scoringGUIPlotOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scoringGUIPlotOpt

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.scoringGUIPlotOpt.value = currentValue;
jbm_synapsescoringengine('updateinfo',handles);


% --- Executes during object creation, after setting all properties.
function scoringGUIPlotOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoringGUIPlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotScoringAnalysis.
function plotScoringAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to plotScoringAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  
global jbm;
global activeplotter;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

switch h_img3.(currentStructName).state.scoringGUIPlotOpt.value
    case 1 % nothing
       activeplotter = 0;
        return;
       
    case 2 % survival function
       activeplotter = 0;
        opt = 2;
    case 3 % synapse number
       activeplotter = 0;
        opt = 1;
    case 4 % elimination
       activeplotter = 0;
        opt = 4;
    case 5 % addition
       activeplotter = 0;
    
        opt = 3;
    case 6
           activeplotter = 0;
   
        opt = 1:4;
    case 7
        activeplotter = 1
        jbm_synapsescoringengine('active plotter',handles);
        return;
end

data = jbm.scoringData;
data.presenceMatrix = data.synapseMatrix>0;%try to use existing routines
% note: other numbers may be used for other things...
Aout = h_routinesForInVivoAnalysis(opt, data, 1);
        


% --- Executes on button press in conventions.
function conventions_Callback(hObject, eventdata, handles)
% hObject    handle to conventions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('print conventions',handles)


% --- Executes on button press in generalNotes.
function generalNotes_Callback(hObject, eventdata, handles)
% hObject    handle to generalNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('general note',handles);


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
