function varargout = h_CASpineDetectionGUI3(varargin)
% H_CASPINEDETECTIONGUI3 M-file for h_CASpineDetectionGUI3.fig
%      H_CASPINEDETECTIONGUI3, by itself, creates a new H_CASPINEDETECTIONGUI3 or raises the existing
%      singleton*.
%
%      H = H_CASPINEDETECTIONGUI3 returns the handle to a new H_CASPINEDETECTIONGUI3 or the handle to
%      the existing singleton*.
%
%      H_CASPINEDETECTIONGUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_CASPINEDETECTIONGUI3.M with the given input arguments.
%
%      H_CASPINEDETECTIONGUI3('Property','Value',...) creates a new H_CASPINEDETECTIONGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_CASpineDetectionGUI3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_CASpineDetectionGUI3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_CASpineDetectionGUI3

% Last Modified by GUIDE v2.5 27-Jul-2015 10:53:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_CASpineDetectionGUI3_OpeningFcn, ...
                   'gui_OutputFcn',  @h_CASpineDetectionGUI3_OutputFcn, ...
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


% --- Executes just before h_CASpineDetectionGUI3 is made visible.
function h_CASpineDetectionGUI3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_CASpineDetectionGUI3 (see VARARGIN)

% Choose default command line output for h_CASpineDetectionGUI3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_CASpineDetectionGUI3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_CASpineDetectionGUI3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in analyzeThreshOutline.
function analyzeThreshOutline_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeThreshOutline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_analyzeThreshOutline3(handles);


% --- Executes on selection change in threshForSynapseDetection.
function threshForSynapseDetection_Callback(hObject, eventdata, handles)
% hObject    handle to threshForSynapseDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns threshForSynapseDetection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from threshForSynapseDetection

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).state.threshForSynapseDetection.value = get(hObject,'Value');
% h_setParaAccordingToState3(handles);

% --- Executes during object creation, after setting all properties.
function threshForSynapseDetection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshForSynapseDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcGelAnalysisROI.
function calcGelAnalysisROI_Callback(hObject, eventdata, handles)
% hObject    handle to calcGelAnalysisROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img2;
h_img3.(currentStructName).lastAnalysis.gelAnalysis = h_executeCalcGelAnalysisRoi2;
h_updateInfo2;
assignin('base','gelAnalysis',h_img3.(currentStructName).lastAnalysis.gelAnalysis);
h_img3.(currentStructName).lastAnalysis.gelAnalysis


% --- Executes on button press in rotateImg.
function rotateImg_Callback(hObject, eventdata, handles)
% hObject    handle to rotateImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img2

try
    if length(h_img3.(currentStructName).image.data.size)<4 && h_img3.(currentStructName).image.data.size(3)==1
        degreeToBeRotated = str2num(get(h_img3.(currentStructName).gh.currentHandles.degreeToBeRotated, 'str'));
        rotatedRed = imrotate(h_img3.(currentStructName).image.data.red, degreeToBeRotated, 'bicubic');
        rotatedGreen = imrotate(h_img3.(currentStructName).image.data.green, degreeToBeRotated, 'bicubic');
        rotatedBlue = imrotate(h_img3.(currentStructName).image.data.blue, degreeToBeRotated, 'bicubic');
        
        h_img3.(currentStructName).image.old = h_img3.(currentStructName).image.data;%save the data for undo.
        
        h_img3.(currentStructName).image.data.size(1:2) = size(rotatedGreen);
        h_img3.(currentStructName).image.data.red = rotatedRed;
        h_img3.(currentStructName).image.data.green = rotatedGreen;
        h_img3.(currentStructName).image.data.blue = rotatedBlue;
        
%         [xlim,ylim,zlim] = h_getLimits2;
%         set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
        h_replot2;
    end
catch
    error('error in rotating image!');
end



function degreeToBeRotated_Callback(hObject, eventdata, handles)
% hObject    handle to degreeToBeRotated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of degreeToBeRotated as text
%        str2double(get(hObject,'String')) returns contents of degreeToBeRotated as a double


% --- Executes during object creation, after setting all properties.
function degreeToBeRotated_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degreeToBeRotated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in duplicateROI.
function duplicateROI_Callback(hObject, eventdata, handles)
% hObject    handle to duplicateROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img2;

roiObj = findobj(handles.imageAxes,'Tag','ROI2');
selectedRoiObj = findobj(handles.imageAxes,'Tag','ROI2', 'Selected', 'on');
UserData = get(selectedRoiObj,'UserData');
UserData.roi.xi = UserData.roi.xi + 10;
UserData.roi.yi = UserData.roi.yi + 10;

hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'h_dragRoiV2', 'Tag', 'ROI2', 'Color','red', 'EraseMode','xor');
hold off;
i = length(findobj(h_findobj(gcf,'Tag','ROI2')));
x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
UserData.texthandle = text(x,y,num2str(i),'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiTextV2');
UserData.number = i;
UserData.ROIhandle = h;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);
set(UserData.texthandle,'UserData',UserData);


% --- Executes on button press in undoRotation.
function undoRotation_Callback(hObject, eventdata, handles)
% hObject    handle to undoRotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).image.data = h_img3.(currentStructName).image.old;
h_replot2;


% --- Executes on selection change in bleedthroughForSynapseDetection.
function bleedthroughForSynapseDetection_Callback(hObject, eventdata, handles)
% hObject    handle to bleedthroughForSynapseDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bleedthroughForSynapseDetection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bleedthroughForSynapseDetection

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).state.bleedthroughForSynapseDetection.value = get(hObject, 'Value');
% h_replot2;


% --- Executes during object creation, after setting all properties.
function bleedthroughForSynapseDetection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bleedthroughForSynapseDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in useDisplayImgOpt.
function useDisplayImgOpt_Callback(hObject, eventdata, handles)
% hObject    handle to useDisplayImgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useDisplayImgOpt

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).state.useDisplayImgOpt.value = get(hObject, 'Value');


% --- Executes on button press in showThreshOutlines.
function showThreshOutlines_Callback(hObject, eventdata, handles)
% hObject    handle to showThreshOutlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showThreshOutlines
global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_img3.(currentStructName).state.showThreshOutlines.value = get(hObject,'value');
h_setVisible3(handles);



function manualThresh_Callback(hObject, eventdata, handles)
% hObject    handle to manualThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manualThresh as text
%        str2double(get(hObject,'String')) returns contents of manualThresh as a double

global h_img3;
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_img3.(currentStructName).state.manualThresh.string = get(hObject, 'string');



% --- Executes during object creation, after setting all properties.
function manualThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
