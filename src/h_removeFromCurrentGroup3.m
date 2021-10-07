function h_removeFromCurrentGroup3(handles, filename)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[pname,fname,fExt] = fileparts(filename);

groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
I = ismember(groupFileNames, [fname, fExt]);

if any(I)
    h_img3.(currentStructName).activeGroup.groupFiles(I) = [];
    groupFiles = h_img3.(currentStructName).activeGroup.groupFiles;
    save(fullfile(h_img3.(currentStructName).activeGroup.groupPath,h_img3.(currentStructName).activeGroup.groupName),...
        'groupFiles');
end


