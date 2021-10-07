function varargout = h_spineAnalysisGUI3(varargin)
% H_SPINEANALYSISGUI3 M-file for h_spineAnalysisGUI3.fig
%      H_SPINEANALYSISGUI3, by itself, creates a new H_SPINEANALYSISGUI3 or raises the existing
%      singleton*.
%
%      H = H_SPINEANALYSISGUI3 returns the handle to a new H_SPINEANALYSISGUI3 or the handle to
%      the existing singleton*.
%
%      H_SPINEANALYSISGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_SPINEANALYSISGUI3.M with the given input arguments.
%
%      H_SPINEANALYSISGUI3('Property','Value',...) creates a new H_SPINEANALYSISGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_roiControlGUI2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_spineAnalysisGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_spineAnalysisGUI3

% Last Modified by GUIDE v2.5 19-Oct-2015 19:07:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_spineAnalysisGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @h_spineAnalysisGUI3_OutputFcn, ...
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


% --- Executes just before h_spineAnalysisGUI3 is made visible.
function h_spineAnalysisGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_spineAnalysisGUI3 (see VARARGIN)

% Choose default command line output for hf_spineAnalysisGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_spineAnalysisGUI3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_spineAnalysisGUI3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in setFiducial.
function setFiducial_Callback(hObject, eventdata, handles)
% hObject    handle to setFiducial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeFiducialPoint3(handles);

% --- Executes on button press in makeAnnotationROI.
function makeAnnotationROI_Callback(hObject, eventdata, handles)
% hObject    handle to makeAnnotationROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeAnnotationROI3(handles);

% --- Executes on button press in assignMovedSpine.
function assignMovedSpine_Callback(hObject, eventdata, handles)
% hObject    handle to assignMovedSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_spineAssignment3(handles,'moved');


% --- Executes on button press in saveAnnotationROI.
function saveAnnotationROI_Callback(hObject, eventdata, handles)
% hObject    handle to saveAnnotationROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_saveAnnotationROI3(handles);




% --- Executes on button press in doubleClickOpt.
function doubleClickOpt_Callback(hObject, eventdata, handles)
% hObject    handle to doubleClickOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.doubleClickOpt.value = currentValue;

if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

% h_replot3(handles, 'fast');


% --- Executes on button press in useROISettings.
function useROISettings_Callback(hObject, eventdata, handles)
% hObject    handle to useROISettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadSelectedROISettings3(handles);


% --- Executes on button press in newSynapse.
function newSynapse_Callback(hObject, eventdata, handles)
% hObject    handle to newSynapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of newSynapse

currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

h_setROIProperties3(handles, 'new');


% --- Executes on button press in loadAnnotationRoiData.
function loadAnnotationRoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnnotationRoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_loadAnnotatedRoiData3(handles, 'v3');


% --- Executes on button press in unAssignSpine.
function unAssignSpine_Callback(hObject, eventdata, handles)
% hObject    handle to unAssignSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_spineAssignment3(handles,'~=');

% --- Executes during object creation, after setting all properties.
function specialNotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specialNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in specialNotes.
function specialNotes_Callback(hObject, eventdata, handles)
% hObject    handle to specialNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns specialNotes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from specialNotes


% --- Executes on button press in retrieveData.
function retrieveData_Callback(hObject, eventdata, handles)
% hObject    handle to retrieveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

synapseAnalysisData = h_retrieveSynapseAnalysis3(handles);
assignin('base','synapseAnalysisData',synapseAnalysisData);

% --- Executes on button press in assignSameSpines.
function assignSameSpines_Callback(hObject, eventdata, handles)
% hObject    handle to assignSameSpines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of assignSameSpines

h_spineAssignment3(handles,'same');


% --- Executes during object creation, after setting all properties.
function ROISizeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in ROISizeOpt.
function ROISizeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function fileTypeForSynAnalysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileTypeForSynAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in fileTypeForSynAnalysis.
function fileTypeForSynAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to fileTypeForSynAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fileTypeForSynAnalysis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileTypeForSynAnalysis

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.fileTypeForSynAnalysis.value = currentValue;

h_fileTypeQuality3(handles);
% h_img3.(currentStructName).state.fileTypeForSynAnalysis.BackgroundColor = get(hObject,'BackgroundColor');


% --- Executes on button press in finalizeSpineAssignment.
function finalizeSpineAssignment_Callback(hObject, eventdata, handles)
% hObject    handle to finalizeSpineAssignment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_finalizeSpineAssigment3(handles);







% --- Executes on button press in setSynapseLast.
function setSynapseLast_Callback(hObject, eventdata, handles)
% hObject    handle to setSynapseLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

h_setROIProperties3(handles, 'last');

% --- Executes on button press in setSynapseUncertain.
function setSynapseUncertain_Callback(hObject, eventdata, handles)
% hObject    handle to setSynapseUncertain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

h_setROIProperties3(handles, 'uncertain');


% --- Executes on button press in setSynapseSpine.
function setSynapseSpine_Callback(hObject, eventdata, handles)
% hObject    handle to setSynapseSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentValue = get(hObject,'Value');
if currentValue
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end

h_setROIProperties3(handles, 'spine');


% --- Executes on button press in takeNoteForROI.
function takeNoteForROI_Callback(hObject, eventdata, handles)
% hObject    handle to takeNoteForROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_takeNoteForROI3(handles);


% --- Executes on button press in setAllSynapseSame.
function setAllSynapseSame_Callback(hObject, eventdata, handles)
% hObject    handle to setAllSynapseSame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in distToFiducial.
function distToFiducial_Callback(hObject, eventdata, handles)
% hObject    handle to distToFiducial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_calcROIDistToFiducial3(handles);




% --- Executes on button press in loadV2AnnotationRoiData.
function loadV2AnnotationRoiData_Callback(hObject, eventdata, handles)
% hObject    handle to loadV2AnnotationRoiData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadAnnotatedRoiData3(handles, 'v2');


% --- Executes during object creation, after setting all properties.
function doubleClickOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doubleClickOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if get(hObject, 'value')
    set(hObject,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(hObject,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end


% --- Executes on button press in showColorCode.
function showColorCode_Callback(hObject, eventdata, handles)
% hObject    handle to showColorCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('new:            green\n');
fprintf('last:           red\n');
fprintf('new and last:   yellow\n');
fprintf('same:           blue\n');
fprintf('moved but same: cyan\n');
fprintf('moved and last: magenta\n');
fprintf('error:          red\n');


% --- Executes on button press in showHotKeys.
function showHotKeys_Callback(hObject, eventdata, handles)
% hObject    handle to showHotKeys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('rightarrow:        move seleted ROI or FOV right\n');
fprintf('leftarrow:         move seleted ROI or FOV left\n');
fprintf('uparrow:           move seleted ROI or FOV up\n');
fprintf('downarrow:         move seleted ROI or FOV down\n');
fprintf('\n');
fprintf('s:                 increase value of upper z slider\n');
fprintf('a:                 decrease value of upper z slider\n');
fprintf('x:                 increase value of lower z slider\n');
fprintf('z:                 decrease value of lower z slider\n');
fprintf('w:                 shift z range up\n');
fprintf('q:                 shift z range down\n');
fprintf('\n');
fprintf('f:                 increase value of upper red slider\n');
fprintf('d:                 decrease value of upper red slider\n');
fprintf('v:                 increase value of lower red slider\n');
fprintf('d:                 decrease value of lower red slider\n');
fprintf('\n');
fprintf('h:                 increase value of upper green slider\n');
fprintf('g:                 decrease value of upper green slider\n');
fprintf('n:                 increase value of lower green slider\n');
fprintf('b:                 decrease value of lower green slider\n');
fprintf('\n');
fprintf('e:                 set selected synases ''same'' (''Current'' window has to be active!)\n');
fprintf('r:                 set selected synapse ''spine''\n');
