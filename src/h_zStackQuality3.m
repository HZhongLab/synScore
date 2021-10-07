function h_zStackQuality3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

maxProjection = get(handles.maxProjectionOpt,'Value');
maxProjectionEnable = get(handles.maxProjectionOpt,'Enable');
if strcmp(maxProjectionEnable,'off')
    maxProjection = 2;
end
[xlim,ylim,zlim] = h_getLimits3(handles);
siz = zlim(2) - zlim(1) + 1;

zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

if maxProjection==1 || maxProjection==4 
    zLim(2) = zLim(1);
end

if zLim(1)<1
    zLim(1) = 1;
end

if zLim(2)<1
    zLim(2) = 1;
end

if zLim(1)>siz
    zLim(1) = siz;
end

if zLim(2)>siz
    zLim(2) = siz;
end

zLim = sort(zLim);
zLim = round(zLim);

set(handles.zStackStrLow,'String',num2str(zLim(1)));
set(handles.zStackStrHigh,'String',num2str(zLim(2)));
if siz > 1
    set(handles.zStackSlider1,'SliderStep',[1/(siz-1),3/(siz-1)],'Value',(zLim(1)-1)/(siz-1));
    set(handles.zStackSlider2,'SliderStep',[1/(siz-1),3/(siz-1)],'Value',(zLim(2)-1)/(siz-1));
end

% add 06/16/2015 for the z position slider
if (siz - (diff(zLim)+1))==0
    zPos = 0.5;
    set(handles.zPosSlider, 'Value', zPos, 'Enable', 'off');
else
    zPos = (zLim(1) - 1)/(siz - (diff(zLim)+1));
    sliderStep(1) = 1/(siz - (diff(zLim)+1));
    sliderStep(2) = max([sliderStep(1), 0.1]);
    set(handles.zPosSlider, 'SliderStep',sliderStep, 'Value', zPos, 'Enable', 'on');
end
