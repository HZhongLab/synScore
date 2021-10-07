function h_zoomInByClick3(handles, zoomFactor, syncFlag)

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[x_lim,y_lim,z_lim] = h_getLimits3(handles);
currentXLim = get(handles.imageAxes, 'XLim');
currentYLim = get(handles.imageAxes, 'YLim');

zoomBoxSizeX = diff(currentXLim)/zoomFactor;
zoomBoxSizeY = diff(currentYLim)/zoomFactor;

axes(handles.imageAxes);

button = 0;
while button~=1
    [x, y, button] = ginput(1);
end

p1 = [x - zoomBoxSizeX/2, y - zoomBoxSizeY/2];% this is to use old codes from h_zoomIn3.
offset = [zoomBoxSizeX, zoomBoxSizeX];

% old code here.    
set(handles.imageAxes,'XLim',[p1(1),p1(1)+offset(1)],'YLim',[p1(2),p1(2)+offset(2)]);
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
% old code above.


% to sync
if syncFlag && get(handles.syncZoomOpt, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncZoomOpt, 'value')% only sync if the sync button is checked on the other instance.
                try h_zoomInByClick3(handles1, zoomFactor, 0); end % sometimes there can be an error if an instance has no image.
            end
        end
    end
end
