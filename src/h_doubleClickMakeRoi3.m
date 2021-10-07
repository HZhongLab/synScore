function h_doubleClickMakeRoi3

% global h_img3



[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3;

% h_unselectAll3(handles);
obj = get(handles.imageAxes, 'Children');%unselectAll.
set(obj, 'Selected', 'off');%unselectAll.

roiobj = findobj(gcf,'Tag','ROI3');
annotationROIObj = findobj(gcf, 'tag', 'annotationROI3');
bgroiobj = findobj(gcf,'Tag','BGROI3');
set(vertcat(roiobj, annotationROIObj, bgroiobj), 'Selected','off', 'linewidth',1);
h_annotationROIQuality3(handles);%assigned synapses use linewidth 2...
h_selectCurrentAnnotationROI3(handles);

UserData = get(gca,'UserData');


t0 = clock;
if ~isfield(UserData,'timeLastClick') || ~(etime(t0,UserData.timeLastClick) < 0.4)
    UserData.timeLastClick = t0;
    set(gca,'UserData',UserData);
    return;
else
    UserData.timeLastClick = 0*t0;%reset the click time.
    set(gca,'UserData',UserData);
    
    Roi_size = 10;
    UserData = [];
    
    switch currentStruct.state.roiShapeOpt.value
        case 1
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            offset = abs(point1-point2);
            if offset(1)<2 && offset(2)<2
                offset = [Roi_size, Roi_size];
            end
            ROI = [p1, offset(1), offset(2)];
            theta = (0:1/40:1)*2*pi;
            xr = ROI(3)/2;
            yr = ROI(4)/2;
            xc = ROI(1) + ROI(3)/2;
            yc = ROI(2) + ROI(4)/2;
            UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
            UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
        case 2
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = min(point1,point2);             % calculate locations
            offset = abs(point1-point2);
            if offset(1)<2 && offset(2)<2
                offset = [Roi_size, Roi_size];
            end
            UserData.roi.xi = [p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1),p1(1)];
            UserData.roi.yi = [p1(2),p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2)];
        case 3
            [BW,UserData.roi.xi,UserData.roi.yi] = roipolyold;
        otherwise
            return;
    end
    hold on;
    if isfield(handles, 'doubleClickOpt') && get(handles.doubleClickOpt,'value')
        currentROIObj = findobj(handles.imageAxes,'Tag','annotationROI3');
        if isempty(currentROIObj)
            i = 1;
        elseif length(currentROIObj)==1
            currentUserdata = get(currentROIObj, 'UserData');
            %     for j = length(currentUserdata)
            i = currentUserdata.number + 1;
        else
            currentUserdata = get(currentROIObj, 'UserData');
            currentUserdata = cell2mat(currentUserdata);
            %     for j = length(currentUserdata)
            i = max([currentUserdata.number]) + 1;
        end

        h = plot(UserData.roi.xi,UserData.roi.yi,'m:', 'linewidth', 1);
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'annotationROI3', 'Color','black', 'EraseMode','xor');
        hold off;

        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(i),'HorizontalAlignment', 'Center','VerticalAlignment','Middle', ...
            'Color','black', 'EraseMode','xor','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
        try
            a = 'clicked'
            jbm_synapsescoringengine('printsynweightnumber',handles)
        end
        UserData.number = i;
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

    else
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'ROI3', 'Color','red', 'EraseMode','xor');
        hold off;
        i = length(findobj(findobj(gcf,'Tag','ROI3')));
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(i),'HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText3');
        UserData.number = i;
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    end
end

h_roiQuality3(handles);

