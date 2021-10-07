function h_executeGroupCalcRoi3(handles)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

set(handles.pauseGroupCalc,'Enable','on');

if ~isfield(currentStruct, 'activeGroup') || ~isempty(currentStruct.activeGroup)
    disp('No active group!')
    return;
end

currentFilename = get(handles.currentFileName,'String');  
if ismember(lower(currentFilename),lower({currentStruct.activeGroup.groupFiles.name}'))
    disp('Current image does not belong to the active group not match!');
    return;
else
    %%%%%%%%%%% Get ROIs %%%%%%%%%%%%%%%%%%%%%%%%%%%
    roiobj = [sort(findobj(handles.h_imstack,'Tag', 'ROI3'));findobj(handles.h_imstack,'Tag','BGROI3');...
        findobj(handles.imageAxes, 'Tag', 'annotationROI3')];
        roiUData = get(roiobj, 'UserData');
    
    
    
    %%%%%%%%%%%%% Calc one by one %%%%%%%%%%%%%%%%%%%%%%%%%%
    montage = h_montageSize(length(currentStruct.activeGroup.groupFiles));
    fig = figure('Name', currentStruct.activeGroup.groupName);

    for i = 1:length(currentStruct.activeGroup.groupFiles)
        h_img3.(currentStructName).oldimg = h_getOldImg3(handles);
        
        h_quickOpenFile3(currentStruct.activeGroup.groupFiles(i).name);

        h_autoPosition3(handles);
        pause(5);
        [h_img3.(currentStructName).lastAnalysis.calcROI, h_img3.(currentStructName).lastAnalysis.calcAnnotationROI]...
            = h_executecalcRoi3(handles);
        
        F = getframe(handles.imageAxes);
        figure(fig);
        subplot(montage(1),montage(2),i)
        colormap(F.colormap);
        img = image(F.cdata);
        set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[]);
        [pname,filename,fExt] = fileparts(currentStruct.activeGroup.groupFiles(i).name);
        xlabel(filename);
    end
end

h_openFile3(handles, currentFilename);

for j = 1:length(roiobj)
    set(roiobj(j),'UserData',roiUData{j},'XData',roiUData{j}.roi.xi,'YData',roiUData{j}.roi.yi);
    x = (min(roiUData{j}.roi.xi) + max(roiUData{j}.roi.xi))/2;
    y = (min(roiUData{j}.roi.yi) + max(roiUData{j}.roi.yi))/2;
    set(roiUData{j}.texthandle,'UserData',roiUData{j},'Position',[x,y]);
end

set(handles.pauseGroupCalc,'Enable','off');

%     
%     time = horzcat(Aout.time);
%     ratio = horzcat(Aout.ratio);
%     
%     figure;
%     hold on;
%     time = (time - min(time))*24*60;
%     cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'black'};
%     for i = 1:length(roiobj)
%         plot(time,A(i).ratio,'-o','Color', cstr{i});
%     end
%     xlabel('Time (min)');
%     ylabel('Green/Red ratio');
%     title(basename,'FontSize',14);
%     hold off;


            
