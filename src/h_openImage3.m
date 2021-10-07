function h_openImage3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

try
    if ~isempty(strfind(get(handles.currentFileName,'String'),'currentFileName'))...
            && isempty(strfind(lower(pwd), 'haining'))
        cd c:\haining\data;
    end
end
[fname,pname] = uigetfile('*.tif','Select an imaging file to open');
if ~(pname == 0)
    h_openFile3(handles,fullfile(pname,fname));
end
