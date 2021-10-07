function h_makeFiducialPoint3(handles)


waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
point1 = point1(1,1:2); 

h = findobj(handles.imageAxes,'Tag','fiducialPoint3');
delete(h);
hold on;

UserData.x = point1(1);
UserData.y = point1(2);

h = plot(UserData.x,UserData.y,'b*','EraseMode', 'XOR', 'MarkerSize', 14, 'Tag', 'fiducialPoint3');

UserData.ROIhandle = h;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);

