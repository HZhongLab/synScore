function h_dragBoundaryMark3


[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3;

boundaryMarkObj = findobj(handles.imageAxes,'Tag','boundaryMark3');
set(boundaryMarkObj, 'Selected','off');

set(gco,'Selected','on','SelectionHighlight','off');

t0 = clock;
UserData = get(gco,'UserData');
% disp(etime(t0,UserData.timeLastClick))
if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.5
    delete(gco);
    return;
else
    UserData.timeLastClick = t0;
    set(gco,'UserData',UserData);
end

h = gco;

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

for i = 1:length(h)
    UserData(i) = get(h(i),'UserData');
    RoiRect(i,:) = [UserData(i).xCo-2,UserData(i).yCo-2, 4, 4];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

finalRect = dragrect(rects);

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    UserData(i).xCo = newRoix+newRoiw/2;
    UserData(i).yCo = newRoiy+newRoih/2;
    set(h(i),'XData',UserData(i).xCo,'YData',UserData(i).yCo,'UserData',UserData(i));
end

% h_setDendriteTracingVis3(handles);