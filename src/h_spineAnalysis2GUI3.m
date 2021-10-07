function varargout = h_spineAnalysis2GUI3(varargin)
% H_SPINEANALYSIS2GUI3 M-file for h_spineAnalysis2GUI3.fig
%      H_SPINEANALYSIS2GUI3, by itself, creates a new H_SPINEANALYSIS2GUI3 or raises the existing
%      singleton*.
%
%      H = H_SPINEANALYSIS2GUI3 returns the handle to a new H_SPINEANALYSIS2GUI3 or the handle to
%      the existing singleton*.
%
%      H_SPINEANALYSIS2GUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_SPINEANALYSIS2GUI3.M with the given input arguments.
%
%      H_SPINEANALYSIS2GUI3('Property','Value',...) creates a new H_SPINEANALYSIS2GUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_spineAnalysis2GUI3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_spineAnalysis2GUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_spineAnalysis2GUI3

% Last Modified by GUIDE v2.5 14-Jul-2015 23:30:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_spineAnalysis2GUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @h_spineAnalysis2GUI3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before h_spineAnalysis2GUI3 is made visible.
function h_spineAnalysis2GUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_spineAnalysis2GUI3 (see VARARGIN)

% Choose default command line output for h_spineAnalysis2GUI3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_spineAnalysis2GUI3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_spineAnalysis2GUI3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tracingDendrite.
function tracingDendrite_Callback(hObject, eventdata, handles)
% hObject    handle to tracingDendrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).lastAnalysis.tracingData = h_tracingByMarks3(handles);

assignin('base','tracingData',h_img3.(currentStructName).lastAnalysis.tracingData);
h_img3.(currentStructName).lastAnalysis.tracingData



% --- Executes on button press in generateLineProfile.
function generateLineProfile_Callback(hObject, eventdata, handles)
% hObject    handle to generateLineProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).lastAnalysis.lineProfile = h_generateLineProfile3(handles);

assignin('base','lineProfile',h_img3.(currentStructName).lastAnalysis.lineProfile);
h_img3.(currentStructName).lastAnalysis.lineProfile


% --- Executes on button press in loadCellAutomataData.
function loadCellAutomataData_Callback(hObject, eventdata, handles)
% hObject    handle to loadCellAutomataData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in showMarkNumber.
function showMarkNumber_Callback(hObject, eventdata, handles)
% hObject    handle to showMarkNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showMarkNumber

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.showMarkNumber.value = get(hObject,'value');
h_setDendriteTracingVis3(handles);


% --- Executes on button press in showTracingMark.
function showTracingMark_Callback(hObject, eventdata, handles)
% hObject    handle to showTracingMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showTracingMark

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.showTracingMark.value = get(hObject,'value');
h_setDendriteTracingVis3(handles);


% --- Executes on button press in showSkeleton.
function showSkeleton_Callback(hObject, eventdata, handles)
% hObject    handle to showSkeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSkeleton

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.showSkeleton.value = get(hObject,'value');
h_setDendriteTracingVis3(handles);

% --- Executes on button press in makeTracingMarks.
function makeTracingMarks_Callback(hObject, eventdata, handles)
% hObject    handle to makeTracingMarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeTracingMark3(handles);


% --- Executes on selection change in markFlag.
function markFlag_Callback(hObject, eventdata, handles)
% hObject    handle to markFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns markFlag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from markFlag


global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.markFlag.value = get(hObject,'value');


% --- Executes during object creation, after setting all properties.
function markFlag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadTracingData.
function loadTracingData_Callback(hObject, eventdata, handles)
% hObject    handle to loadTracingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).lastAnalysis.tracingData = h_loadDendriteTracingData3(handles, 'v3');

assignin('base','tracingData',h_img3.(currentStructName).lastAnalysis.tracingData);
h_img3.(currentStructName).lastAnalysis.tracingData


% --- Executes on selection change in profileWidth.
function profileWidth_Callback(hObject, eventdata, handles)
% hObject    handle to profileWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns profileWidth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from profileWidth

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.profileWidth.value = get(hObject,'value');


% --- Executes during object creation, after setting all properties.
function profileWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to profileWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showProfileOutLine.
function showProfileOutLine_Callback(hObject, eventdata, handles)
% hObject    handle to showProfileOutLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showProfileOutLine

global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.showProfileOutLine.value = get(hObject,'value');
h_setDendriteTracingVis3(handles);


% --- Executes on button press in showingImgOpt.
function showingImgOpt_Callback(hObject, eventdata, handles)
% hObject    handle to showingImgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showingImgOpt
global h_img3;  
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.showingImgOpt.value = get(hObject,'value');
h_setDendriteTracingVis3(handles);


% --- Executes on button press in loadV2TracingData.
function loadV2TracingData_Callback(hObject, eventdata, handles)
% hObject    handle to loadV2TracingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadDendriteTracingData3(handles, 'v2');%do not use the previous tracing data, only load tracing marks.
