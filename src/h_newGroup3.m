function h_newGroup3(handles)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[fname,fpath] = uiputfile('*.grp','Please specify a group name.');
if fname == 0
    return;
else
    [pname, fname2, fExt] = fileparts(fname);
    if isempty(fExt)||strcmp(fExt, '.')
        fname = [fname2,'.grp'];
    end        
end

groupFiles = [];
save([fpath,fname],'groupFiles');
% set(handles.currentGroupInfo,'String',['Active Group: ',fname],'FontSize',9);
h_img3.(currentStructName).activeGroup.groupName = fname;
h_img3.(currentStructName).activeGroup.groupPath = fpath;
h_img3.(currentStructName).activeGroup.groupFiles = groupFiles;
h_updateInfo3(handles);


% currentFilename = get(handles.currentFileName,'String');
% groupFiles = dir(currentFilename);


% [pathname, filename] = h_analyzeFilename(currentFilename);
% if ~(exist([pathname,'Analysis'])==7)
%     currpath = pwd;
%     cd (pathname);
%     mkdir('Analysis');
%     cd (currpath);
% end
% groupInfoFile = [pathname,'Analysis\',filename(1:end-4),'_grp.mat'];
% save(groupInfoFile,'groupName');
