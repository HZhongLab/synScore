function h_cLimitQuality3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[maxIntensity, sliderSteps] = h_getMaxIntensity3(handles);

%%%%%%%%%% Green %%%%%%%%%%%%%%%%%%%
climit(1) = str2num(get(handles.greenLimitStrLow,'String'));
climit(2) = str2num(get(handles.greenLimitStrHigh,'String'));

if climit(1)<0
    climit(1) = 0;
end

if climit(2)<0
    climit(2) = 0;
end

if climit(1)>maxIntensity
    climit(1) = maxIntensity;
end

if climit(2)>maxIntensity
    climit(2) = maxIntensity;
end

climit = sort(climit);
if maxIntensity>10
    climit = round(climit);
else
    climit = round(climit*100)/100;
end


set(handles.greenLimitStrLow,'String',num2str(climit(1)));
set(handles.greenLimitStrHigh,'String',num2str(climit(2)));
set(handles.greenLimitSlider1,'Value',climit(1)/maxIntensity, 'SliderStep',sliderSteps);
set(handles.greenLimitSlider2,'Value',climit(2)/maxIntensity, 'SliderStep',sliderSteps);

%%%%%%%%%% Red %%%%%%%%%%%%%%%%%%%%%5
climit(1) = str2num(get(handles.redLimitStrLow,'String'));
climit(2) = str2num(get(handles.redLimitStrHigh,'String'));

if climit(1)<0
    climit(1) = 0;
end

if climit(2)<0
    climit(2) = 0;
end

if climit(1)>maxIntensity
    climit(1) = maxIntensity;
end

if climit(2)>maxIntensity
    climit(2) = maxIntensity;
end

climit = sort(climit);
if maxIntensity>10
    climit = round(climit);
else
    climit = round(climit*100)/100;
end


set(handles.redLimitStrLow,'String',num2str(climit(1)));
set(handles.redLimitStrHigh,'String',num2str(climit(2)));
set(handles.redLimitSlider1,'Value',climit(1)/maxIntensity, 'SliderStep',sliderSteps);
set(handles.redLimitSlider2,'Value',climit(2)/maxIntensity, 'SliderStep',sliderSteps);


%%%%%%%%%% Blue %%%%%%%%%%%%%%%%%%%%%5

climit(1) = str2num(get(handles.blueLimitStrLow,'String'));
climit(2) = str2num(get(handles.blueLimitStrHigh,'String'));

if climit(1)<0
    climit(1) = 0;
end

if climit(2)<0
    climit(2) = 0;
end

if climit(1)>maxIntensity
    climit(1) = maxIntensity;
end

if climit(2)>maxIntensity
    climit(2) = maxIntensity;
end

climit = sort(climit);
if maxIntensity>10
    climit = round(climit);
else
    climit = round(climit*100)/100;
end


set(handles.blueLimitStrLow,'String',num2str(climit(1)));
set(handles.blueLimitStrHigh,'String',num2str(climit(2)));
set(handles.blueLimitSlider1,'Value',climit(1)/maxIntensity, 'SliderStep',sliderSteps);
set(handles.blueLimitSlider2,'Value',climit(2)/maxIntensity, 'SliderStep',sliderSteps);


