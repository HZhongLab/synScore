function h_resetZoomBox3(handles, syncFlag)

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[x_lim,y_lim,z_lim] = h_getLimits3(handles);

horizontal = get(handles.moveHorizontal,'Value');
XLimValues = get(handles.imageAxes,'XLim');
previousHorizontal = (XLimValues(1)-0.5)/(diff(x_lim) - diff(XLimValues));
deltaHorizontal = horizontal - previousHorizontal; 
XLimValues = XLimValues + horizontal*(diff(x_lim) - XLimValues(2) + XLimValues(1)) - XLimValues(1);
% XLimValues = floor(XLimValues) + x_lim(1);
XLimValues = XLimValues + x_lim(1);

YLimValues = get(handles.imageAxes,'YLim');
vertical = 1 - get(handles.moveVertical,'Value');
previousVertical = (YLimValues(1)-0.5)/(diff(y_lim) - diff(YLimValues));
deltaVertical = vertical - previousVertical;
YLimValues = YLimValues + vertical*(diff(y_lim) - YLimValues(2) + YLimValues(1)) - YLimValues(1);
% YLimValues = floor(YLimValues) + y_lim(1);
YLimValues = YLimValues + y_lim(1);
% disp([deltaHorizontal, deltaVertical]);
set(handles.imageAxes,'XLim',XLimValues,'YLim',YLimValues);

try % there can be error if the figure has been deleted. Temporary fix
    if isfield(currentStruct.gh, 'otherHandles') && isfield(currentStruct.gh.otherHandles,'separateMaxPrj')...
            && ~isempty(currentStruct.gh.otherHandles.separateMaxPrj)
        h = findobj(currentStruct.gh.otherHandles.separateMaxPrj.figureHandle, 'tag', 'zoomInBox3InSeparateMaxPrj');
        delete(h);
        try hold(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,'on');end%Haining 2015-11-01 fast fix: the separate max img may have gotten deleted.
        xi = [XLimValues(1), XLimValues(1), XLimValues(2), XLimValues(2), XLimValues(1)];
        yi = [YLimValues(1), YLimValues(2), YLimValues(2), YLimValues(1), YLimValues(1)];
        h = plot(currentStruct.gh.otherHandles.separateMaxPrj.imageAxesHandle,...
            xi,yi,'-','Tag','zoomInBox3InSeparateMaxPrj', 'Color','white');
    end
catch
end

% to sync
if syncFlag && get(handles.syncMovement, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncMovement, 'value')% only sync if the sync button is checked on the other instance.
                horizontalPos1 = get(handles1.moveHorizontal, 'value');
                %                 horizontalStep1 = get(handles1.moveHorizontal, 'SliderStep');
                newhorizontalPos1 = horizontalPos1 + deltaHorizontal;
                if newhorizontalPos1>1
                    newhorizontalPos1 = 1;
                elseif newhorizontalPos1<0
                    newhorizontalPos1 = 0;
                end
                set(handles1.moveHorizontal, 'value', newhorizontalPos1);
                
                verticalPos1 = get(handles1.moveVertical, 'value');
                %                 verticalStep1 = get(handles1.moveVertical, 'SliderStep');
                newverticalPos1 = verticalPos1 - deltaVertical;
                if newverticalPos1>1
                    newverticalPos1 = 1;
                elseif newverticalPos1<0
                    newverticalPos1 = 0;
                end
                set(handles1.moveVertical, 'value', newverticalPos1);
                h_resetZoomBox3(handles1, 0);
            end
        end
    end
end
