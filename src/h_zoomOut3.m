function h_zoomOut3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

xlim = get(handles.imageAxes,'XLim');
ylim = get(handles.imageAxes,'YLim');
[x_lim,y_lim,z_lim] = h_getLimits3(handles);
if isfield(currentStruct.state,'lineScanDisplay') && currentStruct.state.lineScanDisplay.value
    y_lim = [0,size(currentStruct.greenimg,1)]+0.5;
end

xlim2(1) = floor(xlim(1) - 1/2*(xlim(2)-xlim(1))) + 0.5;
if xlim2(1) < x_lim(1)
    xlim2(1) = x_lim(1);
end
xlim2(2) = xlim2(1) + 2 * (xlim(2)-xlim(1));
if xlim2(2) > x_lim(2)
    xlim2(2) = x_lim(2);
end

ylim2(1) = floor(ylim(1) - 1/2*(ylim(2)-ylim(1))) + 0.5;
if ylim2(1) < y_lim(1)
    ylim2(1) = y_lim(1);
end
ylim2(2) = ylim2(1) + 2 * (ylim(2)-ylim(1));
if ylim2(2) > y_lim(2)
    ylim2(2) = y_lim(2);
end

set(handles.imageAxes,'XLim',xlim2,'YLim',ylim2);

offset = [xlim2(2)-xlim2(1),ylim2(2)-ylim2(1)];
p1 = [xlim2(1),ylim2(1)];

if diff(x_lim)<=offset(1)
    set(handles.moveHorizontal,'Enable','off');
else
    xstep = min([0.05*offset(1)/(diff(x_lim)-offset(1)),0.1],1);
    xvalue = 1 - (p1(1)-x_lim(1))/(diff(x_lim)-offset(1));
    xstep(2) = max(xstep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
    set(handles.moveHorizontal,'Value',xvalue,'SliderStep',xstep);
end

if diff(y_lim)<=offset(2)
    set(handles.moveVertical,'Enable','off');
else
    ystep = min([0.05*offset(2)/(diff(y_lim)-offset(2)),0.1],1);
    yvalue = 1 - (p1(2)-y_lim(1))/(diff(y_lim)-offset(2));
    ystep(2) = max(ystep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
    set(handles.moveVertical,'Value',yvalue,'SliderStep',ystep);
end

set(handles.zoomIn,'Enable','inactive');
set(handles.zoomIn,'Enable','on');

if isfield(currentStruct.gh, 'otherHandles') && isfield(currentStruct.gh.otherHandles,'separateMaxPrj')...
        && ~isempty(currentStruct.gh.otherHandles.separateMaxPrj)
    h = findobj(currentStruct.gh.otherHandles.separateMaxPrj.figureHandle, 'tag', 'zoomInBox3InSeparateMaxPrj');
    delete(h);
    hold(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,'on');
    xi = [xlim2(1), xlim2(1), xlim2(2), xlim2(2), xlim2(1)];
    yi = [ylim2(1), ylim2(2), ylim2(2), ylim2(1), ylim2(1)];
    h = plot(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,...
        xi,yi,'-','Tag','zoomInBox3InSeparateMaxPrj', 'Color','black', 'EraseMode','xor');
end

