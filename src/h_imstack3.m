function varargout = h_imstack3(varargin)
% H_IMSTACK3 M-file for h_imstack3.fig
%      H_IMSTACK3, by itself, creates a new H_IMSTACK3 or raises the existing
%      singleton*.
%
%      H = H_IMSTACK3 returns the handle to a new H_IMSTACK3 or the handle to
%      the existing singleton*.
%
%      H_IMSTACK3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_IMSTACK3.M with the given input arguments.
%
%      H_IMSTACK3('Property','Value',...) creates a new H_IMSTACK3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_imstack2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_imstack3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_imstack3

% Last Modified by GUIDE v2.5 20-Jun-2017 14:30:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_imstack3_OpeningFcn, ...
                   'gui_OutputFcn',  @h_imstack3_OutputFcn, ...
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


% --- Executes just before h_imstack3 is made visible.
function h_imstack3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_imstack3 (see VARARGIN)

% Choose default command line output for h_imstack3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_imstack3 wait for user response (see UIRESUME)
% uiwait(handles.h_imstack3);
global h_img3;
delete(findobj('Type','figure','Children',[]));
[existingInd, nextInd] = h_imstackExistingInd3;

currentStruct = struct('instanceInd', nextInd, 'info',struct,'image',struct,'state',struct,'gh',struct,'lastAnalysis',struct,'internal',struct, 'group', struct);
currentStruct.gh.currentHandles = guihandles(hObject);

windowName = ['h_imstack3.', num2str(nextInd)];
UData.instanceInd = nextInd;

set(handles.h_imstack3, 'UserData', UData, 'Name', windowName);
h_img3.(['I', num2str(nextInd)]) = currentStruct;

h_loadDefault3(h_img3.(['I', num2str(nextInd)]).gh.currentHandles);

h_setupMenu3(handles, 'upper');
h_setupMenu3(handles, 'lower');
axes(handles.imageAxes);
im = ones(128,128,3);
image(im,'ButtonDownFcn','h_doubleClickMakeRoi3');
set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi3' );

% h_loadDefault3(h_img3.(['I', num2str(nextInd)]).gh.currentHandles);



% --- Outputs from this function are returned to the command line.
function varargout = h_imstack3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function imageMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in imageMode.
function imageMode_Callback(hObject, eventdata, handles)
% hObject    handle to imageMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns imageMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageMode
global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_replot3(handles, 'fast');

imageModeValue = get(hObject, 'Value');

% to sync
if get(handles.syncDispOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                set(handles1.imageMode, 'value', imageModeValue)
                h_replot3(handles1, 'fast');
            end
        end
    end
end



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function greenLimitSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function greenLimitSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.greenLimitStrLow,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');



% --- Executes during object creation, after setting all properties.
function greenLimitSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function greenLimitSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.greenLimitStrHigh,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function greenLimitStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function greenLimitStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of greenLimitStrLow as text
%        str2double(get(hObject,'String')) returns contents of greenLimitStrLow as a double

h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function greenLimitStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function greenLimitStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to greenLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of greenLimitStrHigh as text
%        str2double(get(hObject,'String')) returns contents of greenLimitStrHigh as a double

h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes on button press in maxProjectionOpt.
function maxProjectionOpt_Callback(hObject, eventdata, handles)
% hObject    handle to maxProjectionOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maxProjectionOpt

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
maxProjectionOptValue = get(hObject, 'Value');
if maxProjectionOptValue==3 || maxProjectionOptValue==6 % auto set z stack range
    zLimHigh = str2double(get(handles.zStackStrHigh,'String'));
    zLimLow = str2double(get(handles.zStackStrLow,'String'));
    if zLimHigh==zLimLow
        zLimHigh = zLimLow + 4;%only change zLimHigh because when switching back to single section, zLimHigh will be set to zLimLow, 
        set(handles.zStackStrHigh, 'String', num2str(zLimHigh));
    end
end
h_zStackQuality3(handles);
h_replot3(handles);

% to sync
maxProjectionOptValue = get(hObject, 'Value');
if get(handles.syncDispOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                set(handles1.maxProjectionOpt, 'value', maxProjectionOptValue)
                if maxProjectionOptValue==3 || maxProjectionOptValue==6 % auto set z stack range
                    zLimHigh = str2double(get(handles1.zStackStrHigh,'String'));
                    zLimLow = str2double(get(handles1.zStackStrLow,'String'));
                    if zLimHigh==zLimLow
                        zLimHigh = zLimLow + 4;%only change zLimHigh because when switching back to single section, zLimHigh will be set to zLimLow,
                        set(handles1.zStackStrHigh, 'String', num2str(zLimHigh));
                    end
                end
                h_zStackQuality3(handles1);
                h_replot3(handles1);
            end
        end
    end
end



% --- Executes during object creation, after setting all properties.
function redLimitSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function redLimitSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.redLimitStrLow,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function redLimitSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function redLimitSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.redLimitStrHigh,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');

% --- Executes during object creation, after setting all properties.
function redLimitStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function redLimitStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of redLimitStrLow as text
%        str2double(get(hObject,'String')) returns contents of redLimitStrLow as a double

h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function redLimitStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function redLimitStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to redLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of redLimitStrHigh as text
%        str2double(get(hObject,'String')) returns contents of redLimitStrHigh as a double

h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function zStackStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zStackStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to zStackStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zStackStrLow as text
%        str2double(get(hObject,'String')) returns contents of zStackStrLow as a double

h_zStackQuality3(handles);
h_replot3(handles);


% --- Executes during object creation, after setting all properties.
function zStackStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zStackStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to zStackStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zStackStrHigh as text
%        str2double(get(hObject,'String')) returns contents of zStackStrHigh as a double
h_zStackQuality3(handles);
h_replot3(handles);


% --- Executes during object creation, after setting all properties.
function zStackSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function zStackSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to zStackSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[xlim,ylim,zlim] = h_getLimits3(handles);
zstacklow = round(value*(diff(zlim))+1);
set(handles.zStackStrLow,'String',num2str(zstacklow));
h_zStackQuality3(handles);
h_replot3(handles);



% --- Executes during object creation, after setting all properties.
function zStackSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zStackSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function zStackSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to zStackSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[xlim,ylim,zlim] = h_getLimits3(handles);
zstackhigh = round(value*(diff(zlim))+1);
set(handles.zStackStrHigh,'String',num2str(zstackhigh));
h_zStackQuality3(handles);
h_replot3(handles);


% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_openImage3(handles);

% --- Executes on button press in JumpNext.
function JumpNext_Callback(hObject, eventdata, handles)
% hObject    handle to JumpNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2num(get(handles.jumpStep,'String'));
fname = get(handles.currentFileName,'String');
if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile3(handles, fname);


% --- Executes on button press in OpenLast.
function OpenLast_Callback(hObject, eventdata, handles)
% hObject    handle to OpenLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = -1;
fname = get(handles.currentFileName,'String');
if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile3(handles, fname);

% --- Executes on button press in OpenNext.
function OpenNext_Callback(hObject, eventdata, handles)
% hObject    handle to OpenNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = 1;
fname = get(handles.currentFileName,'String');
if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile3(handles, fname);


% --- Executes on button press in JumpLast.
function JumpLast_Callback(hObject, eventdata, handles)
% hObject    handle to JumpLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = -str2num(get(handles.jumpStep,'String'));
fname = get(handles.currentFileName,'String');
if isempty(strfind(fname,'max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-9:end-7));
    basename = fname(1:end-10);
    str1 = '000';
    str2 = num2str(number+value);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'max.tif'];
end
h_openFile3(handles, fname);

function jumpStep_Callback(hObject, eventdata, handles)
% hObject    handle to jumpStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumpStep as text
%        str2double(get(hObject,'String')) returns contents of jumpStep as a double


% --- Executes on button press in autoGreen.
function autoGreen_Callback(hObject, eventdata, handles)
% hObject    handle to autoGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
gamma = str2num(get(handles.gamma,'String'));
upper_pct = 0.94 + 0.01 * log10(currentStruct.image.data.size(1)*currentStruct.image.data.size(2));
if upper_pct>0.995
    upper_pct = 0.995;
end
climitg = h_climit(currentStruct.image.display.green,0.05^gamma^gamma,upper_pct^gamma^gamma);
set(handles.greenLimitStrLow,'String', num2str(climitg(1)));
set(handles.greenLimitStrHigh,'String', num2str(climitg(2)));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes on button press in autoRed.
function autoRed_Callback(hObject, eventdata, handles)
% hObject    handle to autoRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
gamma = str2num(get(handles.gamma,'String'));
upper_pct = 0.94 + 0.01 * log10(currentStruct.image.data.size(1)*currentStruct.image.data.size(2));
if upper_pct>0.995
    upper_pct = 0.995;
end
climitr = h_climit(currentStruct.image.display.red,0.05^gamma^gamma,upper_pct^gamma^gamma);
set(handles.redLimitStrLow,'String', num2str(climitr(1)));
set(handles.redLimitStrHigh,'String', num2str(climitr(2)));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes on button press in fullZStack.
function fullZStack_Callback(hObject, eventdata, handles)
% hObject    handle to fullZStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[xlim,ylim,zlim] = h_getLimits3(handles);
set(handles.zStackStrLow,'String', num2str(1));
set(handles.zStackStrHigh,'String', num2str(zlim(2)));
h_zStackQuality3(handles);
h_replot3(handles);


% --- Executes on button press in smoothImage.
function smoothImage_Callback(hObject, eventdata, handles)
% hObject    handle to smoothImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothImage

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_replot3(handles);

% to sync
smoothImageValue = get(hObject, 'Value');
if get(handles.syncDispOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                set(handles1.smoothImage, 'value', smoothImageValue)
                h_replot3(handles1);
            end
        end
    end
end

h_replot3(handles);


% --- Executes on button press in zoomIn.
function zoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_zoomIn3(handles);


% --- Executes on button press in zoomOut.
function zoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jbm
global h_img3
            selectedInstance = h_getCurrendInd3(handles);
            [currentInd, handlez, currentStruct, currentStructName] = h_getCurrendInd3(handles);
            
            
            globalsync = get(h_img3.(jbm.instancesOpen{selectedInstance}).gh.currentHandles.togglebutton3,'Value');
                                
                if globalsync == 0
                     for i = 1:length(jbm.instancesOpen)
                    h_zoomOut3(h_img3.(jbm.instancesOpen{i}).gh.currentHandles);
                     end
                    else
                    h_zoomOut3(handles);
                end
            
            
            
            


% --- Executes during object creation, after setting all properties.
function moveHorizontal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moveHorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function moveHorizontal_Callback(hObject, eventdata, handles)
% hObject    handle to moveHorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h_resetZoomBox3(handles);


% --- Executes during object creation, after setting all properties.
function moveVertical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to moveVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function moveVertical_Callback(hObject, eventdata, handles)
% hObject    handle to moveVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h_resetZoomBox3(handles);



% --- Executes during object creation, after setting all properties.
function viewingAxisControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewingAxisControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in viewingAxisControl.
function viewingAxisControl_Callback(hObject, eventdata, handles)
% hObject    handle to viewingAxisControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns viewingAxisControl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from viewingAxisControl

h_autoSetAxesRatio3(handles);
[xlim,ylim,zlim] = h_getLimits3(handles);
set(handles.zStackStrLow,'String', num2str(zlim(1)));
set(handles.zStackStrHigh,'String', num2str(zlim(2)));
h_zStackQuality3(handles);
set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
h_replot3(handles);
h_roiQuality3(handles);
h_roiQuality3(handles);



% --- Executes during object creation, after setting all properties.
function ratioBetweenAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratioBetweenAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ratioBetweenAxes.
function ratioBetweenAxes_Callback(hObject, eventdata, handles)
% hObject    handle to ratioBetweenAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ratioBetweenAxes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ratioBetweenAxes

[xlim,ylim,zlim] = h_getLimits3(handles);
set(handles.imageAxes,'XLim',xlim,'YLim',ylim);



% --- Executes on button press in openPreviousInGroup.
function openPreviousInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openPreviousInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_openDiffFileInGrp3(handles, 'previous');

    



% --- Executes on button press in openNextInGroup.
function openNextInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openNextInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_openDiffFileInGrp3(handles, 'next');





% --- Executes on button press in openFirstInGroup.
function openFirstInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openFirstInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_openDiffFileInGrp3(handles, 'first');




% --- Executes on button press in openLastInGroup.
function openLastInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openLastInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_openDiffFileInGrp3(handles, 'last');





% --------------------------------------------------------------------
function saveDefault_Callback(hObject, eventdata, handles)
% hObject    handle to saveDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_saveDefault3(handles);

% --------------------------------------------------------------------
function loadDefault_Callback(hObject, eventdata, handles)
% hObject    handle to loadDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_loadDefault3(handles);


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double

h_replot3(handles, 'fast');


% --- Executes on button press in openGroup2.
function openGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to openGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = dir('*.grp');
if isempty(d) && exist(fullfile(pwd, 'Analysis'), 'dir')
    cd Analysis;
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
    cd ..;
else
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
end

if fname~=0
    h_openGroup3(handles, fullfile(pname, fname));
end



% --- Executes on button press in addToCurrentGroup2.
function addToCurrentGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to addToCurrentGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
if isempty(strfind(currentFilename,'currentFileName'))
    h_addToCurrentGroup3(handles, currentFilename);
    h_updateInfo3(handles);
end


% --- Executes on button press in newGroup2.
function newGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to newGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_newGroup3(handles);


% --- Executes on button press in removeFromCurrentGroup2.
function removeFromCurrentGroup2_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromCurrentGroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
h_removeFromCurrentGroup3(handles,currentFilename);
h_updateInfo3(handles);


% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI

global h_img3
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
h_roiQuality3(handles);

% --- Executes on button press in bgROI2.
function bgROI2_Callback(hObject, eventdata, handles)
% hObject    handle to bgROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_makeBGRoi3(handles);


% --------------------------------------------------------------------
function exportAsTiff_Callback(hObject, eventdata, handles)
% hObject    handle to exportAsTiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_exportAsTiff3(handles);


% --- Executes on button press in generalAnalysis.
function generalAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to generalAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = h_generalAnalysisGUI;
h_setupVariableField(h, handles);
h_setParaAccordingToState('generalAnalysis');



% --- Executes on button press in calcROI2.
function calcROI2_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3;
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
[h_img3.(currentStructName).lastAnalysis.calcROI, h_img3.(currentStructName).lastAnalysis.calcAnnotationROI]...
    = h_executecalcRoi3(handles);
h_roiQuality3(handles);
calcROI = h_img3.(currentStructName).lastAnalysis.calcROI;
calcAnnotationROI = h_img3.(currentStructName).lastAnalysis.calcAnnotationROI;
calcROI.avg_intensity.green
num2clip(calcROI.avg_intensity.green);

assignin('base','calcROI',calcROI);
assignin('base','calcAnnotationROI',calcAnnotationROI);





% --- Executes during object creation, after setting all properties.
function blueLimitSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blueLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function blueLimitSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to blueLimitSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% global h_img2;
value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.blueLimitStrLow,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function blueLimitSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blueLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function blueLimitSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to blueLimitSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);
value2 = maxIntensity * value;
set(handles.blueLimitStrHigh,'String',num2str(value2));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function blueLimitStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blueLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function blueLimitStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to blueLimitStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blueLimitStrLow as text
%        str2double(get(hObject,'String')) returns contents of blueLimitStrLow as a double
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function blueLimitStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blueLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function blueLimitStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to blueLimitStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blueLimitStrHigh as text
%        str2double(get(hObject,'String')) returns contents of blueLimitStrHigh as a double
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');


% --- Executes on button press in autoBlue.
function autoBlue_Callback(hObject, eventdata, handles)
% hObject    handle to autoBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
gamma = str2num(get(handles.gamma,'String'));
climitg = h_climit(currentStruct.image.display.blue,0.05^gamma^gamma,0.98^gamma^gamma);
set(handles.blueLimitStrLow,'String', num2str(climitg(1)));
set(handles.blueLimitStrHigh,'String', num2str(climitg(2)));
h_cLimitQuality3(handles);
h_replot3(handles, 'fast');

% --- Executes during object creation, after setting all properties.
function colorMapOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorMapOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in colorMapOpt.
function colorMapOpt_Callback(hObject, eventdata, handles)
% hObject    handle to colorMapOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns colorMapOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorMapOpt

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h_replot3(handles, 'fast');

% to sync
colorMapOptValue = get(hObject, 'Value');
if get(handles.syncDispOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                set(handles1.colorMapOpt, 'value', colorMapOptValue)
                h_replot3(handles1, 'fast');
            end
        end
    end
end

% --- Executes during object creation, after setting all properties.
function upperMenuOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in upperMenuOpt.
function upperMenuOpt_Callback(hObject, eventdata, handles)
% hObject    handle to upperMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns upperMenuOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from upperMenuOpt

global h_img3

selected_value = get(hObject,'Value');
instancesOpen = fields(h_img3);

for i = 1:length(instancesOpen)
   set(h_img3.(instancesOpen{i}).gh.currentHandles.lowerMenuOpt,'Value',selected_value)
   h_setupMenu3(h_img3.(instancesOpen{i}).gh.currentHandles, 'upper');
end


% --- Executes during object creation, after setting all properties.
function lowerMenuOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lowerMenuOpt.
function lowerMenuOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lowerMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lowerMenuOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lowerMenuOpt

global h_img3

selected_value = get(hObject,'Value');
instancesOpen = fields(h_img3);

for i = 1:length(instancesOpen)
   set(h_img3.(instancesOpen{i}).gh.currentHandles.lowerMenuOpt,'Value',selected_value)
   h_setupMenu3(h_img3.(instancesOpen{i}).gh.currentHandles, 'lower');
end





% --------------------------------------------------------------------
function importTiffSeries_Callback(hObject, eventdata, handles)
% hObject    handle to importTiffSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_importTiffSeries3(handles);


% --------------------------------------------------------------------
function saveImageAs_Callback(hObject, eventdata, handles)
% hObject    handle to saveImageAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_saveImageAs3(handles);


% --- Executes during object creation, after setting all properties.
function zoomFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in zoomFactor.
function zoomFactor_Callback(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns zoomFactor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zoomFactor

if get(handles.syncZoomOpt, 'value') % Haining 2015-11-14 to add the alternative zoom function
    switch get(hObject,'Value')
        case 1
        case 2
            h_zoomInByClick3(handles, 1.5, 1);
        case 3
            h_zoomInByClick3(handles, 2, 1);
        case 4
            h_zoomInByClick3(handles, 3, 1);
        case 5
            h_zoomInByClick3(handles, 4, 1);
        case 6 
            zoom = inputdlg('Please enter a Zoom value (numerical): ');
            zoom = zoom{1};
            zoom = str2num(zoom);
            h_zoomInByClick3(handles,zoom,1);
            
        otherwise
    end
else
    switch get(hObject,'Value')
        case 1
        case 2
            h_makeZoomInBox3(handles, 1.5);
        case 3
            h_makeZoomInBox3(handles, 2);
        case 4
            h_makeZoomInBox3(handles, 3);
        case 5
            h_makeZoomInBox3(handles, 4);
        otherwise
    end
end

set(hObject,'Value', 1);


% --- Executes on button press in copyImg.
function copyImg_Callback(hObject, eventdata, handles)
% hObject    handle to copyImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h = figure('position',[100 100 600 600]);
c = copyobj(handles.imageAxes,h);
set(c,'unit','normalized','position',[0 0 1 1]);

% switch get(currentHandles.colorMapOpt,'Value')
%     case 1
%         map = gray(256);
%     case 2
%         map = jet(256);
%     case 3
%         map = hot(256);
%     case 4
%         tempMap = gray(256);
%         map = tempMap(end:-1:1);
% end
% gamma = str2num(get(currentHandles.gamma,'String'));
% if gamma~=1
%     map = imadjust(map,[],[],gamma);
% end
map = get(handles.h_imstack3, 'colormap');
colormap(map);

print('-dbitmap','-noui',h);






% --- Executes on button press in showSeparateMaxProjection.
function showSeparateMaxProjection_Callback(hObject, eventdata, handles)
% hObject    handle to showSeparateMaxProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSeparateMaxProjection

global h_img3;
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if get(hObject, 'value')
%     if isfield(h_img2.gh,'otherHandles') && isfield(h_img2.gh.otherHandles,'separateMaxPrj') &&...
    currentMaxVal = get(handles.maxProjectionOpt,'value');
    if ~currentMaxVal
        set(handles.maxProjectionOpt, 'value', 2);
        h_zStackQuality3(handles);
        h_replot3(handles);
    end
%     c = findobj(handles.imageAxes,'Type','image');
    h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.figureHandle = figure;
    h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.imageAxesHandle = ...
        copyobj(handles.imageAxes, h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.figureHandle);
%     axes('position', [0 0 1 1], 'tag', 'separateMaxPrjAxes');
%     newImgObj = 
%     set(newImgObj, 'tag', 'separateMaxPrj');
    map = colormap(handles.imageAxes);
    set(h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.imageAxesHandle, 'Position', [0 0 1 1],'XTickLabel', '',...
        'YTickLabel', '', 'XTick',[],'YTick',[], 'tag', 'separateMaxPrjAxes');
    colormap(h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.imageAxesHandle,map);
    axis image;
     if ~currentMaxVal
        set(handles.maxProjectionOpt, 'value', currentMaxVal);
        h_zStackQuality3(handles);
        h_replot3(handles);
     end   
else
    delete(h_img3.(currentStructName).gh.otherHandles.separateMaxPrj.figureHandle);
    h_img3.(currentStructName).gh.otherHandles.separateMaxPrj = [];
end


% --- Executes on key press with focus on h_imstack3 or any of its controls.
function h_imstack3_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

h_hotKeyControls3(handles, eventdata);



% --- Executes on button press in deleteAll.
function deleteAll_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
h = get(handles.imageAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);

% --- Executes on selection change in channelForZ.
function channelForZ_Callback(hObject, eventdata, handles)
% hObject    handle to channelForZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channelForZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelForZ
global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.channelForZ.value = currentValue;
h_setParaAccordingToState3(handles);


% --- Executes during object creation, after setting all properties.
function channelForZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelForZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in analysisNumber.
function analysisNumber_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns analysisNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNumber

h_resetAnalysisNumber3(handles, 1, get(hObject, 'value'));



% --- Executes during object creation, after setting all properties.
function analysisNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function smoothImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on key press with focus on h_imstack3 or any of its controls.
% function h_imstack3_WindowKeyPressFcn(hObject, eventdata, handles)
% % hObject    handle to h_imstack3 (see GCBO)
% % eventdata  structure with the following fields (see FIGURE)
% %	Key: name of the key that was pressed, in lower case
% %	Character: character interpretation of the key(s) that was pressed
% %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% % handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in syncMovement.
function syncMovement_Callback(hObject, eventdata, handles)
% hObject    handle to syncMovement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncMovement
global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncMovement.value = currentValue;


% --- Executes on button press in syncZMovement.
function syncZMovement_Callback(hObject, eventdata, handles)
% hObject    handle to syncZMovement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncZMovement
global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncZMovement.value = currentValue;

% --- Executes on button press in syncGrp.
function syncGrp_Callback(hObject, eventdata, handles)
% hObject    handle to syncGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncGrp
global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncGrp.value = currentValue;

% --- Executes on slider movement.
function zPosSlider_Callback(hObject, eventdata, handles)
% hObject    handle to zPosSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

h_resetZPos3(handles);


% --- Executes during object creation, after setting all properties.
function zPosSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zPosSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key release with focus on h_imstack3 or any of its controls.
function h_imstack3_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

% % h_hotKeyControls3(handles, eventdata.Key);
% disp(eventdata.Key);
% disp('1');


% --- Executes during object creation, after setting all properties.
function maxProjectionOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxProjectionOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bleedThroughCorrOpt.
function bleedThroughCorrOpt_Callback(hObject, eventdata, handles)
% hObject    handle to bleedThroughCorrOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bleedThroughCorrOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bleedThroughCorrOpt

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.bleedThroughCorrOpt.value = currentValue;
h_replot3(handles);

% --- Executes during object creation, after setting all properties.
function bleedThroughCorrOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bleedThroughCorrOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hideControls.
function hideControls_Callback(hObject, eventdata, handles)
% hObject    handle to hideControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

str = get(hObject, 'String');
pos = get(handles.h_imstack3, 'position');

if strcmp(str, '<<') %hide controls
    set(hObject, 'String', '>>');
    pos(3) = 475/801*pos(3);
elseif strcmp(str, '>>') %show controls
    set(hObject, 'String', '<<');
    pos(3) = 801/475*pos(3);
end
% h = struct2array(handles);%Matlab 2013b does not have this function.
handlesNames = fieldnames(handles);

for i = 1:length(handlesNames)
    try % unimenu does not have a units property and can cause error
        originalUnits{i} = get(handles.(handlesNames{i}), 'units');
        set(handles.(handlesNames{i}), 'units', 'pixels'); 
    end 
end
set(handles.h_imstack3, 'position', pos);
for i = 1:length(handlesNames)
    try set(handles.(handlesNames{i}), 'units', originalUnits{i}); end % unimenu does not have a units property and can cause error
end




% --- Executes on button press in hideROI.
function hideROI_Callback(hObject, eventdata, handles)
% hObject    handle to hideROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hideROI

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.hideROI.value = currentValue;

h_setDendriteTracingVis3(handles);% the function was originally only for dendrite tracing but now expand to ROIs.



% --- Executes on button press in syncANumber.
function syncANumber_Callback(hObject, eventdata, handles)
% hObject    handle to syncANumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncANumber

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncANumber.value = currentValue;


% --- Executes when h_imstack3 is resized.
function h_imstack3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_imstack3ResizingFcn(handles);
    


% --- Executes on button press in syncZoomOpt.
function syncZoomOpt_Callback(hObject, eventdata, handles)
% hObject    handle to syncZoomOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncZoomOpt

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncZoomOpt.value = currentValue;


% --- Executes on button press in syncDispOpt.
function syncDispOpt_Callback(hObject, eventdata, handles)
% hObject    handle to syncDispOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of syncDispOpt

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
currentValue = get(hObject,'Value');
h_img3.(currentStructName).state.syncDispOpt.value = currentValue;


% --- Executes on button press in batchAddToGroup.
function batchAddToGroup_Callback(hObject, eventdata, handles)
% hObject    handle to batchAddToGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname, pname] = uigetfile({'*.tif'}, 'MultiSelect', 'on');
fname = cellstr(fname);

if pname~=0 %not cancel
    for i = 1:length(fname)
        h_addToCurrentGroup3(handles, fullfile(pname, fname{i}));
    end
    h_updateInfo3(handles);
end



% --- Executes on button press in openAllInGrp.
function openAllInGrp_Callback(hObject, eventdata, handles)
% hObject    handle to openAllInGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if currentStruct.state.syncGrp.value;
    structNames = fieldnames(h_img3);
    ind  = false(length(structNames), 1);%ind is thd index for instances participate in sync-Grp.
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, 'common')
            ind(i) = h_img3.(structNames{i}).state.syncGrp.value;
        end
    end
    
    instanceNames = sort(structNames(ind));
    
    n_toBeOpen = min(length(currentStruct.activeGroup.groupFiles), length(instanceNames));
    
    choice = questdlg(['This will load the first ', num2str(n_toBeOpen), ' files in the group ''', currentStruct.activeGroup.groupName,...
        ''' to current h_imstack3 instances with sync-Grp on. Do you want to proceed?'],...
        'Open All In Grp Dialog','Yes','No','No');
    switch choice
        case 'Yes'
            for i = 1:length(instanceNames)
                h_img3.(instanceNames{i}).activeGroup = currentStruct.activeGroup;
                
                handles1 = h_img3.(instanceNames{i}).gh.currentHandles;
                
                fname = fullfile(currentStruct.activeGroup.groupPath,currentStruct.activeGroup.groupFiles(i).relativePath,...
                    currentStruct.activeGroup.groupFiles(i).fname);
                if exist(fname, 'file')
                    fileInfo = h_dir(fname);
                    h_openFile3(handles1, fileInfo.name);
                else
                    h_openFile3(handles1, currentStruct.activeGroup.groupFiles(i).name);
                end
            end
        case 'No'
            return;
        otherwise
    end
else
    warndlg('Please turn on sync-Grp to use this function.');
end


% --- Executes on button press in closeAllInstances.
function closeAllInstances_Callback(hObject, eventdata, handles)
% hObject    handle to closeAllInstances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3

choice = questdlg(['This will close all h_imstack3 instances!! Do you want to proceed?'],...
    'Yes','Yes','No','No');
switch choice
    case 'Yes'
        structNames = fieldnames(h_img3);
        j = 1;
        for i = 1:length(structNames)
            if ~strcmpi(structNames{i}, 'common')
                h(j) = h_img3.(structNames{i}).gh.currentHandles.h_imstack3;
                j = j + 1;
            end
        end
        delete(h);% do it this way instead of one by one because there may be funny interaction with the deletion function...
        clear global h_img3
    case 'No'
        return;
    otherwise
end


% --- Executes on button press in syncRedSaturation.
function syncRedSaturation_Callback(hObject, eventdata, handles)
% hObject    handle to syncRedSaturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if get(handles.syncDispOpt, 'value')
    currentImg = currentStruct.image.display.red;
    xlim = get(handles.imageAxes, 'xlim');
    ylim = get(handles.imageAxes, 'ylim');
    currentDisplayImg = currentImg(round(ylim(1):ylim(2)),round(xlim(1):xlim(2)));
    imgValues = sort(currentDisplayImg(:));
    imgValues(isnan(imgValues)) = [];
    
    currentCLimit(1) = str2num(get(handles.redLimitStrLow,'String'));
    ind = mean([find(imgValues>currentCLimit(1), 1, 'first'), find(imgValues<currentCLimit(1), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(1) = ind/length(imgValues);
    
    currentCLimit(2) = str2num(get(handles.redLimitStrHigh,'String'));
    ind = mean([find(imgValues>currentCLimit(2), 1, 'first'), find(imgValues<currentCLimit(2), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(2) = ind/length(imgValues);

    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                img1 = h_img3.(structNames{i}).image.display.red;
                xlim1 = get(handles1.imageAxes, 'xlim');
                ylim1 = get(handles1.imageAxes, 'ylim');
                displayImg1 = img1(round(ylim1(1):ylim1(2)),round(xlim1(1):xlim1(2)));
                cLim = h_climit(displayImg1, currentPct(1), currentPct(2));
                set(handles1.redLimitStrLow, 'String', cLim(1));
                set(handles1.redLimitStrHigh, 'String', cLim(2));
                h_cLimitQuality3(handles1);
                h_replot3(handles1, 'fast');
            end
        end
    end
end


% --- Executes on button press in syncGreenSaturation.
function syncGreenSaturation_Callback(hObject, eventdata, handles)
% hObject    handle to syncGreenSaturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if get(handles.syncDispOpt, 'value')
    currentImg = currentStruct.image.display.green;
    xlim = get(handles.imageAxes, 'xlim');
    ylim = get(handles.imageAxes, 'ylim');
    try
        currentDisplayImg = currentImg(round(ylim(1):ylim(2)),round(xlim(1):xlim(2)));
    catch
    end
    imgValues = sort(currentDisplayImg(:));
    imgValues(isnan(imgValues)) = [];
    
    currentCLimit(1) = str2num(get(handles.greenLimitStrLow,'String'));
    ind = mean([find(imgValues>currentCLimit(1), 1, 'first'), find(imgValues<currentCLimit(1), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(1) = ind/length(imgValues);
    
    currentCLimit(2) = str2num(get(handles.greenLimitStrHigh,'String'));
    ind = mean([find(imgValues>currentCLimit(2), 1, 'first'), find(imgValues<currentCLimit(2), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(2) = ind/length(imgValues);

    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                img1 = h_img3.(structNames{i}).image.display.green;
                xlim1 = get(handles1.imageAxes, 'xlim');
                ylim1 = get(handles1.imageAxes, 'ylim');
                displayImg1 = img1(round(ylim1(1):ylim1(2)),round(xlim1(1):xlim1(2)));
                cLim = h_climit(displayImg1, currentPct(1), currentPct(2));
                set(handles1.greenLimitStrLow, 'String', cLim(1));
                set(handles1.greenLimitStrHigh, 'String', cLim(2));
                h_cLimitQuality3(handles1);
                h_replot3(handles1, 'fast');
            end
        end
    end
end


% --- Executes on button press in syncBlueSaturation.
function syncBlueSaturation_Callback(hObject, eventdata, handles)
% hObject    handle to syncBlueSaturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if get(handles.syncDispOpt, 'value')
    currentImg = currentStruct.image.display.blue;
    xlim = get(handles.imageAxes, 'xlim');
    ylim = get(handles.imageAxes, 'ylim');
    currentDisplayImg = currentImg(round(ylim(1):ylim(2)),round(xlim(1):xlim(2)));
    imgValues = sort(currentDisplayImg(:));
    imgValues(isnan(imgValues)) = [];
    
    currentCLimit(1) = str2num(get(handles.blueLimitStrLow,'String'));
    ind = mean([find(imgValues>currentCLimit(1), 1, 'first'), find(imgValues<currentCLimit(1), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(1) = ind/length(imgValues);
    
    currentCLimit(2) = str2num(get(handles.blueLimitStrHigh,'String'));
    ind = mean([find(imgValues>currentCLimit(2), 1, 'first'), find(imgValues<currentCLimit(2), 1, 'last')]);
    %do it this way because sometime the value is not present.
    currentPct(2) = ind/length(imgValues);

    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncDispOpt, 'value')% only sync if the sync button is checked on the other instance.
                img1 = h_img3.(structNames{i}).image.display.blue;
                xlim1 = get(handles1.imageAxes, 'xlim');
                ylim1 = get(handles1.imageAxes, 'ylim');
                displayImg1 = img1(round(ylim1(1):ylim1(2)),round(xlim1(1):xlim1(2)));
                cLim = h_climit(displayImg1, currentPct(1), currentPct(2));
                set(handles1.blueLimitStrLow, 'String', cLim(1));
                set(handles1.blueLimitStrHigh, 'String', cLim(2));
                h_cLimitQuality3(handles1);
                h_replot3(handles1, 'fast');
            end
        end
    end
end


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3

jbm_synapsescoringengine('global sync',handles)


% --- Executes on scroll wheel click while the figure is in focus.
function h_imstack3_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
if eventdata.VerticalScrollCount > 0
h_adjZStackSlider3([0 0 1], handles);
elseif eventdata.VerticalScrollCount < 0
    h_adjZStackSlider3([0 0 -1], handles);
end



function h_adjZStackSlider3(steps, handles)
% tic
stepLow = steps(1);
stepHigh = steps(2);
stepPos = steps(3);
[xlim,ylim,zlim] = h_getLimits3(handles);

if stepLow~=0
    val = get(handles.zStackSlider1, 'value');
    stepSize = get(handles.zStackSlider1,'SliderStep');
    newValue = val + stepLow*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zStackSlider1, 'value', newValue);
    zstackLow = round(newValue*(diff(zlim))+1);
    set(handles.zStackStrLow,'String',num2str(zstackLow));
    h_zStackQuality3(handles);
    h_replot3(handles);
%   toc
end

if stepHigh~=0
    val = get(handles.zStackSlider2, 'value');
    stepSize = get(handles.zStackSlider2,'SliderStep');
    newValue = val + stepHigh*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zStackSlider2, 'value', newValue);
    zstackHigh = round(newValue*(diff(zlim))+1);
    set(handles.zStackStrHigh,'String',num2str(zstackHigh));
    h_zStackQuality3(handles);
    h_replot3(handles);
%   toc
end

if stepPos~=0
    val = get(handles.zPosSlider, 'value');
    stepSize = get(handles.zPosSlider,'SliderStep');
    newValue = val + stepPos*stepSize(1);
    if newValue<0
        newValue = 0;
    elseif newValue>1
        newValue = 1;
    end
    set(handles.zPosSlider, 'value', newValue);
%     toc
    h_resetZPos3(handles);
%     toc
end


% --- Executes during object creation, after setting all properties.
function currentFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on h_imstack3 and none of its controls.
function h_imstack3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function h_imstack3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to h_imstack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ezgzPush.
function ezgzPush_Callback(hObject, eventdata, handles)
% hObject    handle to ezgzPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h_img3
instances = fields(h_img3);

for i=1:length(instances)
handles2 = h_img3.(instances{i}).gh.currentHandles;
figure(h_img3.(instances{i}).gh.currentHandles.h_imstack3);
j_ezgz3(handles2)
end

