function h_resetZPos3(handles, syncFlag)

global h_img3;

if ~exist('syncFlag','var')||isempty(syncFlag)
    syncFlag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

zPos = get(handles.zPosSlider,'Value');
[xlim,ylim,zlim] = h_getLimits3(handles);
zSiz = zlim(2) - zlim(1) + 1;

zLow = str2num(get(handles.zStackStrLow,'String'));
zHigh = str2num(get(handles.zStackStrHigh,'String'));

previousZPos = (zLow - 1)/(zSiz - (zHigh-zLow+1));

deltaZ = round((zPos - previousZPos)*(zSiz - (zHigh-zLow+1)));

set(handles.zStackStrLow, 'String', num2str(zLow+deltaZ));
set(handles.zStackStrHigh, 'String', num2str(zHigh+deltaZ));

h_zStackQuality3(handles);
h_replot3(handles);

% to sync
if syncFlag && get(handles.syncZMovement, 'value')
    structNames = fieldnames(h_img3);
    for i = 1:length(structNames)
        if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
            handles1 = h_img3.(structNames{i}).gh.currentHandles;
            if get(handles1.syncZMovement, 'value')% only sync if the sync button is checked on the other instance.
                if strcmpi(get(handles1.zPosSlider,'Enable'), 'on')
                    zPos1 = get(handles1.zPosSlider, 'value');
                    zPosSliderStep1 = get(handles1.zPosSlider, 'SliderStep');
                    newZPos1 = zPos1 + deltaZ*zPosSliderStep1(1);
                    if newZPos1>1
                        newZPos1 = 1;
                    elseif newZPos1<0
                        newZPos1 = 0;
                    end
                    set(handles1.zPosSlider, 'value', newZPos1);
                    h_resetZPos3(handles1, 0);
                end
            end
        end
    end
end
                
    
    