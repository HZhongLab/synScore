function h_autoSetAxesRatio3(handles)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

header = currentStruct.info;
dispAxes = get(handles.viewingAxisControl,'Value');

if strcmpi(header.fileType,'scanimage') && exist('calculateFieldOfView', 'file')
    try
        zoom = header.acq.zoomhundreds*100 + header.acq.zoomtens*10 + header.acq.zoomones;
    catch
        zoom = header.acq.zoomFactor;
    end

    [XfieldOfView, YfieldOfView] = calculateFieldOfView(zoom);
    xPixelLength = XfieldOfView/header.acq.pixelsPerLine;
    yPixelLength = YfieldOfView/header.acq.linesPerFrame;
    
    switch dispAxes
        case {1}
            viewingAxis = 3;
            str = '1:1';
        case {2}
            viewingAxis = 1;
            ratio = round(abs(header.acq.zStepSize) / xPixelLength *10)/10;
            str = ['1:',num2str(ratio)];
        case {3}
            viewingAxis = 2;
            ratio = round(abs(header.acq.zStepSize) / yPixelLength *10)/10;
            str = ['1:',num2str(ratio)];
    end 
else %if not scanimage files and no x, y, z pixel sizes
    switch dispAxes
        case {1}
            viewingAxis = 3;
            str = '1:1';
        case {2}
            viewingAxis = 1;
            str = '1:10';
        case {3}
            viewingAxis = 2;
            str = '1:10';
    end
end

set(handles.ratioBetweenAxes,'String',str);
