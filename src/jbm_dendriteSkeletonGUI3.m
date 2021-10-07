function varargout = jbm_dendriteSkeletonGUI3(varargin)
% JBM_DENDRITESKELETONGUI3 M-file for jbm_dendriteSkeletonGUI3.fig
%      JBM_DENDRITESKELETONGUI3, by itself, creates a new JBM_DENDRITESKELETONGUI3 or raises the existing
%      singleton*.
%
%      H = JBM_DENDRITESKELETONGUI3 returns the handle to a new JBM_DENDRITESKELETONGUI3 or the handle to
%      the existing singleton*.
%
%      JBM_DENDRITESKELETONGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JBM_DENDRITESKELETONGUI3.M with the given input arguments.
%
%      JBM_DENDRITESKELETONGUI3('Property','Value',...) creates a new JBM_DENDRITESKELETONGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before jbm_dendriteSkeletonGUI3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jbm_dendriteSkeletonGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jbm_dendriteSkeletonGUI3

% Last Modified by GUIDE v2.5 06-Jun-2016 15:53:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jbm_dendriteSkeletonGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @jbm_dendriteSkeletonGUI3_OutputFcn, ...
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


% --- Executes just before jbm_dendriteSkeletonGUI3 is made visible.
function jbm_dendriteSkeletonGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jbm_dendriteSkeletonGUI3 (see VARARGIN)

% Choose default command line output for jbm_dendriteSkeletonGUI3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes jbm_dendriteSkeletonGUI3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = jbm_dendriteSkeletonGUI3_OutputFcn(hObject, eventdata, handles) 
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
jbm_synapsescoringengine('update skeleton info',handles);



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
jbm_synapsescoringengine('update skeleton info',handles);

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
jbm_synapsescoringengine('update skeleton info',handles);

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
jbm_synapsescoringengine('update skeleton info',handles);

% --- Executes on button press in makeTracingMarks.
function makeTracingMarks_Callback(hObject, eventdata, handles)
% hObject    handle to makeTracingMarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jbm_makeTracingMark3(handles);
jbm_synapsescoringengine('update skeleton info',handles);


% --- Executes on button press in loadTracingData.
function loadTracingData_Callback(hObject, eventdata, handles)
% hObject    handle to loadTracingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  
global jbm;
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).lastAnalysis.tracingData = jbm.scoringData.skeleton.tracingData{currentInd};
jbm_synapsescoringengine('update skeleton info',handles);
jbm_synapsescoringengine('load skeleton data',handles);



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
jbm_synapsescoringengine('update skeletoninfo',handles);



% --- Executes on button press in appendSkeleton.
function appendSkeleton_Callback(hObject, eventdata, handles)
% hObject    handle to appendSkeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jbm_synapsescoringengine('append skeleton',handles);
jbm_synapsescoringengine('update skeleton info',handles);
