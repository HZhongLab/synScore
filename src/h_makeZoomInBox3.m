function h_makeZoomInBox3(handles, factor)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h = currentStruct.gh.currentHandles.imageAxes;
delete(findobj(h, 'Tag', 'zoomInBox3'));

xlim = get(h,'xlim');
ylim = get(h,'ylim');

offset(1) = diff(xlim)/factor;
offset(2) = diff(ylim)/factor;

p1(1) = (xlim(1)+xlim(2))/2-offset(1)/2;
p1(2) = (ylim(1)+ylim(2))/2-offset(2)/2;

UserData.roi.xi = [p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1),p1(1)];
UserData.roi.yi = [p1(2),p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2)];

hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'h_dragZoomInBox3', 'Tag', 'zoomInBox3', 'Color','black', 'EraseMode','xor');
hold off;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);

if isfield(currentStruct.gh, 'otherHandles') && isfield(currentStruct.gh.otherHandles,'separateMaxPrj')...
        && ~isempty(currentStruct.gh.otherHandles.separateMaxPrj)
    h = findobj(currentStruct.gh.otherHandles.separateMaxPrj.figureHandle, 'tag', 'zoomInBox3InSeparateMaxPrj');
    delete(h);
    hold(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,'on');
    h = plot(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,...
        UserData.roi.xi,UserData.roi.yi,'-','Tag','zoomInBox3InSeparateMaxPrj', 'Color','black', 'EraseMode','xor');
end
