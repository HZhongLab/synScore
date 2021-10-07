function h_dragRoi3

% global h_img2

handles = guihandles(gcf);

h_showRoi3(handles);

point1 = get(gca,'CurrentPoint'); % button down detected
point1 = point1(1,1:2);              % extract x and y

roiobj = findobj(gcf,'Tag','ROI3');
annotationROIObj = findobj(gcf, 'tag', 'annotationROI3');
bgroiobj = findobj(gcf,'Tag','BGROI3');
j_bgroiobj = findobj(gcf,'Tag','fbgROI3');
fluorroiobj = findobj(gcf,'Tag','fluorROI3');

currentObj = gco;

set(vertcat(roiobj, annotationROIObj, bgroiobj,j_bgroiobj,fluorroiobj), 'Selected','off', 'linewidth',1);
h_annotationROIQuality3(handles);%assigned synapses use linewidth 2...
% set(currentObj,'Selected','on','SelectionHighlight','on');
set(currentObj,'Selected','on','SelectionHighlight','off','linewidth',3);

t0 = clock;
UserData = get(currentObj,'UserData');
if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.4
    if strcmpi(get(currentObj, 'tag'), 'ROI3') || strcmpi(get(currentObj, 'tag'), 'BGROI3') 
        delete(gco);
        delete(UserData.texthandle);
        h = sort(findobj(gcf,'Tag','ROI3'));
        if length(h) < length(roiobj)
            for i = 1:length(h)
                UserData = get(h(i),'UserData');
                UserData.number = i;
                set(UserData.texthandle,'String',num2str(i),'UserData',UserData);
                set(h(i),'UserData',UserData);
            end
        end
        return;
    elseif strcmpi(get(currentObj, 'tag'), 'annotationROI3')
        isDeletion = 1;
        h_selectCurrentAnnotationROI3(handles, currentObj, isDeletion);
        return;
    end
else
    UserData.timeLastClick = t0;
    set(currentObj,'UserData',UserData);
    if strcmpi(get(currentObj, 'tag'), 'annotationROI3')
        isDeletion = 0;
        h_selectCurrentAnnotationROI3(handles, currentObj, isDeletion);
    end
end

currentGcaUnit = get(gca,'Unit');
set(gca,'Unit','normalized');
rectFigure = get(gcf, 'Position');
rectAxes = get(gca, 'Position');
set(gca,'Unit',currentGcaUnit);

Xlimit = get(gca, 'XLim');
Ylimit = get(gca, 'Ylim');
Ylim = Ylimit(2)-Ylimit(1);
Xlim = Xlimit(2)-Xlimit(1);
xmag = (rectFigure(3)*rectAxes(3))/Xlim;  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/Ylim;
yoffset = rectAxes(2)*rectFigure(4);

lockROI = get(handles.lockROI,'Value');
if iscell(lockROI)
    lockROI = lockROI{1};
end

if lockROI
    h = vertcat(roiobj, annotationROIObj, bgroiobj);
else
    h = currentObj;
end

for i = 1:length(h)
    UData{i} = get(h(i),'UserData');
    RoiRect(i,:) = [min(UData{i}.roi.xi),min(UData{i}.roi.yi),...
            max(UData{i}.roi.xi)-min(UData{i}.roi.xi),max(UData{i}.roi.yi)-min(UData{i}.roi.yi)];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

if length(h)==1 && point1(1)>(RoiRect(1)+3/4*RoiRect(3)) && point1(2)>(RoiRect(2)+3/4*RoiRect(4))
    finalRect = rbbox(rects);
else
    finalRect = dragrect(rects);
end

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    
    if RoiRect(i,3) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1)) + newRoix;
    else
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1))/RoiRect(i,3)*newRoiw + newRoix;
    end

    if RoiRect(i,4) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2)) + newRoiy;
    else
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2))/RoiRect(i,4)*newRoih + newRoiy;
    end

    set(h(i),'XData',UData{i}.roi.xi,'YData',UData{i}.roi.yi,'UserData',UData{i});
    set(UData{i}.texthandle, 'Position', [newRoix+newRoiw/2,newRoiy+newRoih/2],'UserData',UData{i});
end

h_roiQuality3(handles);

