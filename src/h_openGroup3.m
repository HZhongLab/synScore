function h_openGroup3(handles, filename)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[pname, fname, fExt] = fileparts(filename);

if isempty(pname)
    pname = pwd;
end

% try
    if exist(filename, 'file')
        load(filename,'-mat');
        h_img3.(currentStructName).activeGroup.groupName = [fname, fExt];
        h_img3.(currentStructName).activeGroup.groupPath = pname;
        h_img3.(currentStructName).activeGroup.groupFiles = groupFiles;
%         h_updateInfo3(handles);% it will run later.
    else
        disp([filename,' not exist!']);
    end
% end

h_updateInfo3(handles);
