function jbm_sameFieldOfView()
global h_img3;
global jbm;

returnVect= [];
for i = 1:length(jbm.instancesOpen)
    [selectedInstance,handles,currentStruct,currentStructName] = h_getCurrendInd3(h_img3.(jbm.instancesOpen{i}).gh.currentHandles);

infoZ = h_quickinfo(currentStruct.info);
[infoZ.filepath, infoZ.filename, infoZ.fExt] = fileparts(get(handles.currentFileName, 'string'));
returnVect = [returnVect infoZ.zoom];

end
if length(unique(returnVect)) ~= 1
    disp(sprintf(['ZOOM ERROR: \n ' num2str(returnVect)]));
else
    disp(sprintf(['You are good! \n ' num2str(returnVect)]));
end

end
