function h_addToCurrentGroup3(handles, filename)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if isfield(h_img3.(currentStructName),'activeGroup') && ~isempty( h_img3.(currentStructName).activeGroup)
        currentGroupFile = h_dir(filename);
        [currentGroupFile.path, fname, fExt] = fileparts(currentGroupFile.name);
        currentGroupFile.fname = [fname, fExt];
        currentGroupFile.relativePath = h_getRelativePath(currentStruct.activeGroup.groupPath, currentGroupFile.path);
    if isempty(h_img3.(currentStructName).activeGroup.groupFiles)
         h_img3.(currentStructName).activeGroup.groupFiles = currentGroupFile;
    else
        groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
        if ~ismember(lower(currentGroupFile.fname), lower(groupFileNames))
             h_img3.(currentStructName).activeGroup.groupFiles(end+1) = currentGroupFile;
        end
    end
    time = datenum({h_img3.(currentStructName).activeGroup.groupFiles.date}');
    [sortedTime, index] = sort(time);
     h_img3.(currentStructName).activeGroup.groupFiles =  h_img3.(currentStructName).activeGroup.groupFiles(index);
    groupFiles =  h_img3.(currentStructName).activeGroup.groupFiles;
    save(fullfile(h_img3.(currentStructName).activeGroup.groupPath, h_img3.(currentStructName).activeGroup.groupName),'groupFiles');
    [pname,fname,fExt] = fileparts(filename);
    
    %no longer constrain each image can only associate with one group.
%     if ~(exist(fullfile(pname,'Analysis'))==7)
%         currpath = pwd;
%         cd (pname);
%         mkdir('Analysis');
%         cd (currpath);
%     end
%     groupInfoFile = fullfile(pname,'Analysis',[fname,'_grp.mat']);
%     if exist(groupInfoFile)
%         load (groupInfoFile);
%         if ~strcmp(groupName,[ h_img3.(currentStructName).activeGroup.groupPath, h_img3.(currentStructName).activeGroup.groupName])
%             try
%                 load (groupName,'-mat');
%                 I = strmatch(filename,{groupFiles.name}','exact');
%                 groupFiles(I) = [];
%                 save(groupName,'groupFiles');
%             end
%         end
%     end
%     groupName = fullfile( h_img3.(currentStructName).activeGroup.groupPath, h_img3.(currentStructName).activeGroup.groupName);
%     save(groupInfoFile,'groupName');
end
