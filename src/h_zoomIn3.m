function h_zoomIn3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

try
    h = findobj(handles.imageAxes,'Tag', 'zoomInBox3');
    if isempty(h)
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = floor(point1(1,1:2));              % extract x and y
        point2 = floor(point2(1,1:2));
        p1 = min(point1,point2)+0.5;             % calculate locations
        offset = abs(point1-point2);
    else
        UserData = get(h,'UserData');
        p1 = [UserData.roi.xi(1), UserData.roi.yi(1)];
        offset = [UserData.roi.xi(3)-UserData.roi.xi(1), UserData.roi.yi(3) - UserData.roi.yi(1)];
        delete(h);
    end
    
    imgObj = handles.imageAxes;
    set(imgObj,'XLim',[p1(1),p1(1)+offset(1)],'YLim',[p1(2),p1(2)+offset(2)]);
    [xlim,ylim,zlim] = h_getLimits3(handles);
    if isfield(currentStruct.state,'lineScanDisplay') && currentStruct.state.lineScanDisplay.value
        ylim = [0,size(currentStruct.greenimg,1)]+0.5;
    end
    
    if diff(xlim)>offset(1)
        set(handles.moveHorizontal,'Enable','on');
        xstep = min([0.05*offset(1)/(diff(xlim)-offset(1)),0.1],1);
        xvalue = (p1(1)-xlim(1))/(diff(xlim)-offset(1));
        xstep(2) = max(xstep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
        set(handles.moveHorizontal,'Value',xvalue,'SliderStep',xstep);
    end
    
    if diff(ylim)>offset(2)
        set(handles.moveVertical,'Enable','on');
        ystep = min([0.05*offset(2)/(diff(ylim)-offset(2)),0.1],1);
        ystep(2) = max(ystep); %SliderStep (2) cannot be smaller than (1) in R2015a and up.
        yvalue = 1 - (p1(2)-ylim(1))/(diff(ylim)-offset(2));
        set(handles.moveVertical,'Value',yvalue,'SliderStep',ystep);
    end
    
    try % there can be error if the figure has been deleted. Temporary fix
        if isfield(currentStruct.gh, 'otherHandles') && isfield(currentStruct.gh.otherHandles,'separateMaxPrj')...
            && ~isempty(currentStruct.gh.otherHandles.separateMaxPrj)
        h = findobj(currentStruct.gh.otherHandles.separateMaxPrj.figureHandle, 'tag', 'zoomInBox3InSeparateMaxPrj');
        delete(h);
        hold(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,'on');
        xi = [p1(1),p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1)];
        yi = [p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2),p1(2)];
        h = plot(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,...
            xi,yi,'-','Tag','zoomInBox3InSeparateMaxPrj', 'Color','black', 'EraseMode','xor');
        end
    catch
    end
catch
    disp('Zoom error');
end