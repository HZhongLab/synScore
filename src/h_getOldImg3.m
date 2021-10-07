function [oldimg, climit] = h_getOldImg3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

try
    imageModes = get(handles.imageMode,'String');
    currentImageMode = imageModes{get(handles.imageMode,'Value')};
    switch currentImageMode
        case {'Green','G Saturation'}
            oldimg = currentStruct.image.display.green;
            climit(1) = str2num(get(handles.greenLimitStrLow,'String'));
            climit(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        case {'Red','R Saturation','G/R ratio'}
            oldimg = currentStruct.image.display.red;
            climit(1) = str2num(get(handles.redLimitStrLow,'String'));
            climit(2) = str2num(get(handles.redLimitStrHigh,'String'));
        case {'Blue', 'B Saturation'}
            oldimg = currentStruct.image.display.blue;
            climit(1) = str2num(get(handles.blueLimitStrLow,'String'));
            climit(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        case {'Overlay'}
            climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
            climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
            climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
            climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
            climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
            climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
            oldimg = h_createRGBImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
                climitr,climitg,climitb);
            climit = [];
    end
catch
    oldimg = [];
    climit = [];
end