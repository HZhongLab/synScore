function varargout = jbm_weightExtractGUI3(varargin)
% JBM_WEIGHTEXTRACTGUI3 M-file for jbm_weightExtractGUI3.fig
%      JBM_WEIGHTEXTRACTGUI3, by itself, creates a new JBM_WEIGHTEXTRACTGUI3 or raises the existing
%      singleton*.
%
%      H = JBM_WEIGHTEXTRACTGUI3 returns the handle to a new JBM_WEIGHTEXTRACTGUI3 or the handle to
%      the existing singleton*.
%
%      JBM_WEIGHTEXTRACTGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JBM_WEIGHTEXTRACTGUI3.M with the given input arguments.
%
%      JBM_WEIGHTEXTRACTGUI3('Property','Value',...) creates a new JBM_WEIGHTEXTRACTGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_roiControlGUI2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jbm_weightExtractGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jbm_weightExtractGUI3

% Last Modified by GUIDE v2.5 01-Apr-2019 22:14:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jbm_weightExtractGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @jbm_weightExtractGUI3_OutputFcn, ...
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


% --- Executes just before jbm_weightExtractGUI3 is made visible.
function jbm_weightExtractGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jbm_weightExtractGUI3 (see VARARGIN)

% Choose default command line output for hf_spineAnalysisGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes jbm_weightExtractGUI3 wait for user response (see UIRESUME)
% uiwait(handles.template);

% --- Outputs from this function are returned to the command line.
function varargout = jbm_weightExtractGUI3_OutputFcn(hObject, eventdata, handles)
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
% handles    empty - handles not created until after all CreateFcns called\


% --- Executes on button press in progressmode.
function progressmode_Callback(hObject, eventdata, handles)
% hObject    handle to progressmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of progressmode
tog = get(hObject,'Value');
global progressViewJBM;
progressViewJBM = tog;
global jbm;
global h_img3;
if tog == 1
    for day = 1:size(jbm.knobs,2)
        set(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.progressmode,'Value',tog);
        for syn = 1:size(jbm.knobs,1)
            try
                if jbm.scoringData.fluorData{syn,day}.fin == 1
                    set(jbm.scoringData.fluorData{syn,day}.knob,'visible','off');
                else
                end
            catch
            end
        end
    end
    
else
    
    for day = 1:size(jbm.knobs,2)
        set(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.progressmode,'Value',tog);
        
        roiobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','fluorROI3');
        scoobj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3,'Tag','scoringROI3');
        scoringROITextObj = findobj(h_img3.(jbm.instancesOpen{day}).gh.currentHandles.h_imstack3, 'Tag', 'scoringROI3text');
        set(roiobj,'visible','on');
        set(scoobj,'visible','on');
        set(scoringROITextObj,'visible','on');
    end
    
end

% --- Executes on button press in set_z_push.
function set_z_push_Callback(hObject, eventdata, handles)
% hObject    handle to set_z_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('setZ',handles);

% --- Executes on button press in set_z_all_push.
function set_z_all_push_Callback(hObject, eventdata, handles)
% hObject    handle to set_z_all_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('setZAll',handles);

% --- Executes on button press in gen_roi_push.
function gen_roi_push_Callback(hObject, eventdata, handles)
% hObject    handle to gen_roi_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('generateFluorROIs',handles);

% --- Executes on button press in focus_push.
function focus_push_Callback(hObject, eventdata, handles)
% hObject    handle to focus_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('focus',handles);

% --- Executes on button press in bg_push.
function bg_push_Callback(hObject, eventdata, handles)
% hObject    handle to bg_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('makebgroi',handles);


% --- Executes on button press in decrement_push.
function decrement_push_Callback(hObject, eventdata, handles)
% hObject    handle to decrement_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('dec_fluorsize',handles);

% --- Executes on button press in increment_push.
function increment_push_Callback(hObject, eventdata, handles)
% hObject    handle to increment_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jbm_synapsescoringengine('inc_fluorsize',handles);



function roi_diameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to roi_diameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_diameter_edit as text
%        str2double(get(hObject,'String')) returns contents of roi_diameter_edit as a double


% --- Executes during object creation, after setting all properties.
function roi_diameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_diameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_search_depth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_search_depth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_search_depth_edit as text
%        str2double(get(hObject,'String')) returns contents of z_search_depth_edit as a double


% --- Executes during object creation, after setting all properties.
function z_search_depth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_search_depth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in unfinalize_push.
function unfinalize_push_Callback(hObject, eventdata, handles)
% hObject    handle to unfinalize_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jbm;
for i = 1:size(jbm.knobs,2)
    jbm.scoringData.fluorData{jbm.currentSynIdx,i}.fin = 0;
end
h_replot3(handles);
jbm_synapsescoringengine('updateinfo',handles);



% --- Executes on button press in calc_push.
function calc_push_Callback(hObject, eventdata, handles)
% hObject    handle to calc_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('final_fluor_calc',handles);


% --- Executes on button press in great_synapse.
function great_synapse_Callback(hObject, eventdata, handles)
% hObject    handle to great_synapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jbm_synapsescoringengine('great_synapse',handles);
h_replot3(handles);

% --- Executes on button press in notgreatpush.
function notgreatpush_Callback(hObject, eventdata, handles)
% hObject    handle to notgreatpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jbm;
for i = 1:size(jbm.knobs,2)
    if (isfield(jbm.scoringData.fluorData{jbm.currentSynIdx,i},'high_quality'))
        jbm.scoringData.fluorData{jbm.currentSynIdx,i}.high_quality = 0;
        
    else
    end
end
h_replot3(handles);
jbm_synapsescoringengine('updateinfo',handles);
