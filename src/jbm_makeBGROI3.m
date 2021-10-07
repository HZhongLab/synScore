function aout = jbm_MakeBGROI3(handles)
global h_img3
global jbm
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

obj = get(handles.imageAxes, 'Children');%unselectAll.
set(obj, 'Selected', 'off');%unselectAll.

Roi_size = 25;
which_bg_type=1;
switch which_bg_type
    case 1
        waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);
        disp(point1)% extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);
        if offset(1)<2 && offset(2)<2
            offset = [Roi_size, Roi_size];
        end
        ROI = [point1, offset(1), offset(2)];
        theta = (0:1/40:1)*2*pi;
        xr = ROI(3)/2;
        yr = ROI(4)/2;
        xc = ROI(1) + ROI(3)/2;
        yc = ROI(2) + ROI(4)/2;
        UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
        UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
    case 2
        waitforbuttonpress;
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
        waitforbuttonpress;
        [BW,UserData.roi.xi,UserData.roi.yi] = roipolyold;
    otherwise
        return;
end    
hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'BGROI3', 'Color','red');
hold off;
x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;

UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
    'Center','VerticalAlignment','Middle', 'Color','yellow','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
UserData.number = 'BG';
UserData.ROIhandle = h;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);
set(UserData.texthandle,'UserData',UserData);
aout = UserData;
h_roiQuality3(handles);

aout.knob = h;
aout.texthandle = UserData.texthandle;
aout.xc = xc;
aout.yc = yc;
aout.xr = xr;
aout.yr = yr;
aout.UserData = UserData;


