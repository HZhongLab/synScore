function h_dragTracingMark3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3;

state = currentStruct.state;
data = currentStruct.image.data;

% point1 = get(gca,'CurrentPoint'); % button down detected
% point1 = point1(1,1:2);              % extract x and y

tracingMarkObj = findobj(handles.imageAxes,'Tag','h_tracingMark3');
set(tracingMarkObj, 'Selected','off');

set(gco,'Selected','on','SelectionHighlight','off');

t0 = clock;
UserData = get(gco,'UserData');
% disp(etime(t0,UserData.timeLastClick))
if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.5
    delete(gco);
    delete(UserData.textHandle);

    %find out the previous ROI info
    tracingMarkObj = findobj(handles.imageAxes,'Tag','h_tracingMark3');
    previousUData = get(tracingMarkObj,'UserData');
    if iscell(previousUData)
        previousUData = cell2mat(previousUData);
    end

    if ~isempty(previousUData)
        previousFlag = [previousUData.flag];
        previousUData = previousUData(previousFlag==UserData.flag); %only count those with the same flag
    end
    
    %sort the ROIs just in case.
    num = [previousUData.number];
    [num,I] = sort(num);
    previousUData = previousUData(I);

    for i = 1:length(previousUData)
        previousUData(i).number = i;
        set(previousUData(i).textHandle,'String',[' ', num2str(UserData.flag), '.', num2str(i)],'UserData',previousUData(i));
        set(previousUData(i).markHandle,'UserData',previousUData(i));
    end
    
    return;
else
    UserData.timeLastClick = t0;
    set(gco,'UserData',UserData);
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


lockROI = state.lockROI.value;

if lockROI
    h = findobj(handles.imageAxes,'Tag','h_tracingMark3');
else
    h = gco;
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

for i = 1:length(h)
    UserData(i) = get(h(i),'UserData');
    RoiRect(i,:) = [UserData(i).pos(1)-2,UserData(i).pos(2)-2, 4, 4];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

finalRect = dragrect(rects);

%preparation for calculating z
siz = data.size;
[Y, X] = ndgrid(1:siz(1), 1:siz(2));

zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

switch state.channelForZ.value
    case 1
        img_data = data.red;
    case 2
        img_data = data.green;
    case 3
        img_data = data.blue;
    otherwise
        error('channel for Z error!');
end
%preparation for calculating z

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    UserData(i).pos(1) = newRoix+newRoiw/2;
    UserData(i).pos(2) = newRoiy+newRoih/2;
    
    %To find the brightest Z within 3 pixels.
    BW = ((Y - UserData(i).pos(2)).^2 + (X - UserData(i).pos(1)).^2) <= 3^2;%note: X correspond to dimension 2

    intensity = zeros(1,siz(3));
    for j = 1:siz(3)
        imr = img_data(:,:,j);
        intensity(j) = mean(imr(BW));
    end

    intensity2 = intensity(zLim(1):zLim(2));
    zi = find(intensity2==max(intensity2));
    zi = zi(1) + zLim(1) - 1;
    
    zRange = zi-2:zi+2;
    zRange = zRange(zRange >= zLim(1));
    zRange = zRange(zRange <= zLim(2));
    
    imga = double(img_data(:,:,zRange));
    imga = imga.*repmat(BW, [1 1 length(zRange)]);
    [x, y, zPos] = h_calculateCenterOfMass(imga);
    zPos = zPos + zRange(1) - 1;
    UserData(i).pos(3) = zPos;
            
    set(h(i),'XData',UserData(i).pos(1),'YData',UserData(i).pos(2),'UserData',UserData(i));
    set(UserData(i).textHandle, 'Position', [newRoix+newRoiw/2,newRoiy+newRoih/2],'UserData',UserData(i));
end

h_setDendriteTracingVis3(handles);
