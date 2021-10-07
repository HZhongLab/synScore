function varargout = h_roiControlGUI3(varargin)
% H_ROICONTROLGUI3 M-file for h_roiControlGUI3.fig
%      H_ROICONTROLGUI3, by itself, creates a new H_ROICONTROLGUI3 or raises the existing
%      singleton*.
%
%      H = H_ROICONTROLGUI3 returns the handle to a new H_ROICONTROLGUI3 or the handle to
%      the existing singleton*.
%
%      H_ROICONTROLGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_ROICONTROLGUI3.M with the given input arguments.
%
%      H_ROICONTROLGUI3('Property','Value',...) creates a new H_ROICONTROLGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_roiControlGUI2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_roiControlGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_roiControlGUI3

% Last Modified by GUIDE v2.5 16-Jul-2015 22:16:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_roiControlGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @h_roiControlGUI3_OutputFcn, ...
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


% --- Executes just before h_roiControlGUI3 is made visible.
function h_roiControlGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_roiControlGUI3 (see VARARGIN)

% Choose default command line output for h_roiControlGUI3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_roiControlGUI3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_roiControlGUI3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bgRoi.
function bgRoi_Callback(hObject, eventdata, handles)
% hObject    handle to bgRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeBGRoi3(handles);

% --- Executes on button press in newRoi.
function newRoi_Callback(hObject, eventdata, handles)
% hObject    handle to newRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_makeRoi3(handles);

% --- Executes on button press in deleteRoi.
function deleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guihandles(hObject);
currentObj = findobj(handles.imageAxes,'Selected','on');
roiobj = findobj(gcf,'Tag','ROI3');

if strcmpi(get(currentObj, 'tag'), 'ROI3') || strcmpi(get(currentObj, 'tag'), 'BGROI3')
    UserData = get(currentObj, 'UserData');
    delete(currentObj);
    delete(UserData.texthandle);
    h = sort(findobj(gcf,'Tag','ROI3'));
    if length(h) < length(roiobj)% if this is not true, it is BGROI.
        for i = 1:length(h)
            UserData = get(h(i),'UserData');
            UserData.number = i;
            set(UserData.texthandle,'String',num2str(i),'UserData',UserData);
            set(h(i),'UserData',UserData);
        end
    end
    return;
elseif strcmpi(get(currentObj, 'tag'), 'annotationROI3')
    isDeletion = 1;
    h_selectCurrentAnnotationROI3(handles, currentObj, isDeletion);
    return;
end

% --- Executes on button press in calcROI.
function calcROI_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img3;
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
[h_img3.(currentStructName).lastAnalysis.calcROI, h_img3.(currentStructName).lastAnalysis.calcAnnotationROI]...
    = h_executecalcRoi3(handles);
h_roiQuality3(handles);
calcROI = h_img3.(currentStructName).lastAnalysis.calcROI
calcAnnotationROI = h_img3.(currentStructName).lastAnalysis.calcAnnotationROI

assignin('base','calcROI',calcROI);
assignin('base','calcAnnotationROI',calcAnnotationROI);


% --- Executes on button press in deleteAll.
function deleteAll_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h = get(h_img3.(currentStructName).gh.currentHandles.imageAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);


% --- Executes on button press in pasteROI.
function pasteROI_Callback(hObject, eventdata, handles)
% hObject    handle to pasteROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_pasteROI3(handles);


% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI
global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end
h_img3.(currentStructName).state.lockROI.value = currentValue;
h_img3.(currentStructName).state.lockROI.BackgroundColor = get(hObject,'BackgroundColor');
h_setParaAccordingToState3(handles);
h_updateInfo3(handles);

% --- Executes on button press in loadAnalyzedRoiData.
function loadAnalyzedRoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedRoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_loadAnalyzedRoiData3(handles, 'v3');


% --- Executes on button press in autoPosition.
function autoPosition_Callback(hObject, eventdata, handles)
% hObject    handle to autoPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% h_twoStepAutoPosition3(handles);
h_autoPosition3(handles);

% --- Executes during object creation, after setting all properties.
function roiShapeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in roiShapeOpt.
function roiShapeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to roiShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns roiShapeOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roiShapeOpt
global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.roiShapeOpt.value = get(hObject,'Value');
h_setParaAccordingToState3(handles);
h_updateInfo3(handles);


% --- Executes on button press in groupCalcRoi.
function groupCalcRoi_Callback(hObject, eventdata, handles)
% hObject    handle to groupCalcRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_executeGroupCalcRoi3(handles);


% --- Executes on button press in pauseGroupCalc.
function pauseGroupCalc_Callback(hObject, eventdata, handles)
% hObject    handle to pauseGroupCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseGroupCalc


% --- Executes on button press in undoAutoPosition.
function undoAutoPosition_Callback(hObject, eventdata, handles)
% hObject    handle to undoAutoPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_pasteROI3(handles);

% --- Executes during object creation, after setting all properties.
function analysisNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in analysisNumber.
function analysisNumber_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysisNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNumber

h_resetAnalysisNumber3(handles, 1, get(hObject, 'value'));


% --- Executes on button press in channelForZ.
function channelForZ_Callback(hObject, eventdata, handles)
% hObject    handle to channelForZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channelForZ

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.channelForZ.value = get(hObject,'Value');
h_setParaAccordingToState3(handles);
% h_updateInfo3(handles);


% --- Executes on button press in loadV1AnalyzedROI.
function loadV1AnalyzedROI_Callback(hObject, eventdata, handles)
% hObject    handle to loadV1AnalyzedROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_loadAnalyzedRoiData3(handles, 'v1');



% --- Executes on button press in copyROI.
function copyROI_Callback(hObject, eventdata, handles)
% hObject    handle to copyROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_copyROI3(handles);


% --- Executes on selection change in ROISizeOpt.
function ROISizeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ROISizeOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROISizeOpt

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.ROISizeOpt.value = get(hObject,'Value');
h_setParaAccordingToState3(handles);
% h_updateInfo3(handles);


% --- Executes during object creation, after setting all properties.
function ROISizeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in loadV2AnalyzedROI.
function loadV2AnalyzedROI_Callback(hObject, eventdata, handles)
% hObject    handle to loadV2AnalyzedROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadAnalyzedRoiData3(handles, 'v2');


% --- Executes on button press in loadAnnotatedROIOpt.
function loadAnnotatedROIOpt_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnnotatedROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadAnnotatedROIOpt

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.loadAnnotatedROIOpt.value = get(hObject,'Value');
% h_setParaAccordingToState3(handles);
