function varargout = jbm_synanalysis(varargin)
% JBM_SYNANALYSIS MATLAB code for jbm_synanalysis.fig
%      JBM_SYNANALYSIS, by itself, creates a new JBM_SYNANALYSIS or raises the existing
%      singleton*.
%
%      H = JBM_SYNANALYSIS returns the handle to a new JBM_SYNANALYSIS or the handle to
%      the existing singleton*.
%
%      JBM_SYNANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JBM_SYNANALYSIS.M with the given input arguments.
%
%      JBM_SYNANALYSIS('Property','Value',...) creates a new JBM_SYNANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before jbm_synanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jbm_synanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jbm_synanalysis

% Last Modified by GUIDE v2.5 03-Nov-2016 15:00:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jbm_synanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @jbm_synanalysis_OutputFcn, ...
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


% --- Executes just before jbm_synanalysis is made visible.
function jbm_synanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jbm_synanalysis (see VARARGIN)

% Choose default command line output for jbm_synanalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global synana;
synana = [];
synana.gh.currentHandles = guihandles(hObject);
set(synana.gh.currentHandles.dendritesByAnimalTable,'data',[])
set(synana.gh.currentHandles.dendritesByConditionTable,'data',[])
set(synana.gh.currentHandles.animalsByConditionTable,'data',[])


% UIWAIT makes jbm_synanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = jbm_synanalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in newConditionPush.
function newConditionPush_Callback(hObject, eventdata, handles)
% hObject    handle to newConditionPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('new condition',handles);

% --- Executes on button press in deleteConditionPush.
function deleteConditionPush_Callback(hObject, eventdata, handles)
% hObject    handle to deleteConditionPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('delete condition',handles);

% --- Executes on button press in addDendritesPush.
function addDendritesPush_Callback(hObject, eventdata, handles)
% hObject    handle to addDendritesPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('add dendrites to condition',handles);

% --- Executes on button press in deleteDendritesPush.
function deleteDendritesPush_Callback(hObject, eventdata, handles)
% hObject    handle to deleteDendritesPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('delete dendrites from condition',handles);

% --- Executes on button press in newAnimalPush.
function newAnimalPush_Callback(hObject, eventdata, handles)
% hObject    handle to newAnimalPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('new animal',handles);

% --- Executes on button press in deleteAnimalPush.
function deleteAnimalPush_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAnimalPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('delete animal',handles);

% --- Executes on button press in returnDataPush.
function returnDataPush_Callback(hObject, eventdata, handles)
% hObject    handle to returnDataPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('return data',handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
clear -global synana


% --- Executes when selected cell(s) is changed in dendritesByConditionTable.
function dendritesByConditionTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to dendritesByConditionTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global synana;
synana.clickIndx.dendritesByConditionTable = eventdata.Indices;


% --- Executes when selected cell(s) is changed in dendritesByAnimalTable.
function dendritesByAnimalTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to dendritesByAnimalTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global synana;
synana.clickIndx.dendritesByAnimalTable = eventdata.Indices;


% --- Executes when selected cell(s) is changed in animalsByConditionTable.
function animalsByConditionTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to animalsByConditionTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global synana;
synana.clickIndx.animalsByConditionTable = eventdata.Indices;


% --- Executes on button press in savePush.
function savePush_Callback(hObject, eventdata, handles)
% hObject    handle to savePush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('save',handles);

% --- Executes on button press in loadPush.
function loadPush_Callback(hObject, eventdata, handles)
% hObject    handle to loadPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synanalysisEngine('load',handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotByAnimalOpt.
function plotByAnimalOpt_Callback(hObject, eventdata, handles)
% hObject    handle to plotByAnimalOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotByAnimalOpt


% --- Executes on button press in plotPush.
function plotPush_Callback(hObject, eventdata, handles)
% hObject    handle to plotPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in plotOpt.
function plotOpt_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to plotOpt (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global synana;
synana.clickIndx.plotOpt = eventdata.Indices;
jbm_synanalysisEngine('update info',handles);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
global synana;
contents = cellstr(get(hObject,'String'));
synana.totSpineShaft = contents{get(hObject,'Value')}
jbm_synanalysisEngine('return data',handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
