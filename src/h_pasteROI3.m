function h_pasteROI3(handles)

global h_img3;

roiobj = findobj(handles.imageAxes,'Tag','ROI3');
annotationROIObj = findobj(handles.imageAxes, 'tag', 'annotationROI3');
bgroiobj = findobj(handles.imageAxes,'Tag','BGROI3');

h = vertcat(roiobj, annotationROIObj, bgroiobj);
textHandles = zeros(1, length(h));
for i = 1:length(h)
    UData = get(h(i),'UserData');
    textHandles(i) = UData.texthandle;
end

delete(h);
delete(textHandles);

copiedROI = h_img3.common.copiedROI;

axes(handles.imageAxes);
hold on;

for i = 1:length(copiedROI)
    UserData = copiedROI{i};
    if isfield(UserData, 'synapseAnalysis')%annotationROI
        h = plot(UserData.roi.xi,UserData.roi.yi,'m:', 'linewidth', 1);
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'annotationROI3', 'Color','black', 'EraseMode','xor');
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(UserData.number),'HorizontalAlignment', 'Center','VerticalAlignment','Middle', ...
            'Color','black', 'EraseMode','xor','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        UserData.synapseAnalysis.synapseNumber = -1;
        UserData.synapseAnalysis.maxSynapseNumber = 0;
        UserData.synapseAnalysis.synapseStatus = '';
        UserData.synapseAnalysis.isLast = -1;% last and new can be for the same synapse. So has to separate the two.
        UserData.synapseAnalysis.isSpine = -1;% 1 is spine, 0 is not a spine, -1 is unassigned.
        UserData.synapseAnalysis.synapseConfidence = '';
        UserData.synapseAnalysis.previousFileName = '';
        UserData.synapseAnalysis.previousAnalysisNumber = '';
        UserData.synapseAnalysis.nextFileName = '';
        UserData.synapseAnalysis.nextAnalysisNumber = '';
        UserData.synapseAnalysis.note = 'special notes';

        % Josh want to save the current Z information.
        UserData.currentSettings = h_getCurrentSettings3(handles);

        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);

    elseif strcmpi(UserData.number, 'BG')%BG ROI
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'BGROI3', 'Color','black', 'EraseMode','xor');
        hold off;
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','black','EraseMode','xor','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
%         UserData.number = 'BG';
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    else
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'ROI3', 'Color','red', 'EraseMode','xor');
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(UserData.number),'HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText3');
%         UserData.number = UserData.number;
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    end
end
    