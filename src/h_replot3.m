function h_replot3(handles,mode)

global h_img3;
global jbm;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if ~exist('mode', 'var') || isempty(mode)
    mode = 'slow';
end

imageModes = get(handles.imageMode,'String');
currentImageMode = imageModes{get(handles.imageMode,'Value')};
% axes(handles.imageAxes);

% if isfield(handles,'doubleClickOpt') && get(handles.doubleClickOpt,'value')
%     ButtonDownFcn = 'h_doubleClickMakeAnnotationROI3';
% else
    ButtonDownFcn = 'h_doubleClickMakeRoi3';
% end

switch get(handles.colorMapOpt,'Value')
    case 1
        map = gray(256);
    case 2
        map = jet(256);
    case 3
        map = hot(256);
    case 4
        temp_map = gray(256);
        map = temp_map(end:-1:1,:);
end
gamma = str2num(get(handles.gamma,'String'));
if gamma~=1
    map = imadjust(map,[],[],gamma);
end
colormap(handles.imageAxes, map);

c = findobj(handles.imageAxes,'Type','image');
if isempty(c)
    axes(handles.imageAxes);
    axis square;
    c = image(ones(64));
end
% toc
if ~strcmpi(mode,'fast')
    h_getCurrentImg3(handles);
    currentStruct = h_img3.(currentStructName);
%     h_cLimitQuality3;
end
% toc

switch currentImageMode
    case {'Green','G Saturation'}
        climit(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climit(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climit(2)==climit(1)
            climit(2) = climit(1)+0.001;%otherwise it will cause error below
        end
        set(c,'CData',currentStruct.image.display.green,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        if strcmp(currentImageMode,'G Saturation')
            %         map = [zeros(1,63),1;zeros(1,64);0:1/63:1-1/63,0]';
            %         map1 = jet(64);
            %         map = vertcat(map1(1:38,:),[1,0,0]);
            map = gray(256);
            map(end,:) = [1,0,0];
            colormap(handles.imageAxes,map);
        end
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climit,'ButtonDownFcn',ButtonDownFcn);
    case {'Red','R Saturation'}
        climit(1) = str2num(get(handles.redLimitStrLow,'String'));
        climit(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climit(2)==climit(1)
            climit(2) = climit(1)+0.001;%otherwise it will cause error below
        end
        set(c,'CData',currentStruct.image.display.red,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        if strcmp(currentImageMode,'R Saturation')
            map = gray(256);
            map(end,:) = [1,0,0];
            colormap(handles.imageAxes,map);
        end
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climit,'ButtonDownFcn',ButtonDownFcn);
    case {'Blue', 'B Saturation'}
        climit(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climit(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climit(2)==climit(1)
            climit(2) = climit(1)+0.001;%otherwise it will cause error below
        end
        set(c,'CData',currentStruct.image.display.blue,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        if strcmp(currentImageMode,'B Saturation')
            map = gray(256);
            map(end,:) = [1,0,0];
            colormap(handles.imageAxes,map);
        end
        set(handles.imageAxes, 'XTickLabel', '', 'YTickLabel', '', 'Tag', 'imageAxes','CLim',climit,'ButtonDownFcn',ButtonDownFcn);
    case {'Overlay'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climitb(2)==climitb(1)
            climitb(2) = climitb(1)+0.001;%otherwise it will cause error below
        end
        colorim = h_createRGBImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
            climitr,climitg,climitb);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
    case {'G/R ratio'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        ratioImg = ((currentStruct.image.display.green-climitg(1))/diff(climitg))./((currentStruct.image.display.red-climitr(1))/diff(climitr));
        ratioImg(currentStruct.image.display.red<=3*climitr(1)) = nan;
        climit = h_climit(ratioImg,0.001,0.999);
        rgbimage = ss_makeRGBLifetimeMap(ratioImg,[climit(2),climit(1)], currentStruct.image.display.red,climitr);
        set(c,'CData',rgbimage,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
        
      
    
    case {'Alien'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climitb(2)==climitb(1)
            climitb(2) = climitb(1)+0.001;%otherwise it will cause error below
        end
        colorim = h_createAlienImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
            climitr,climitg,climitb);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
      
    
    case {'Magenta Overlay'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climitb(2)==climitb(1)
            climitb(2) = climitb(1)+0.001;%otherwise it will cause error below
        end
        colorim = h_createMGBImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
            climitr,climitg,climitb);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
   
    
    case {'Green Over Magenta'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climitb(2)==climitb(1)
            climitb(2) = climitb(1)+0.001;%otherwise it will cause error below
        end
        colorim = h_createGOMImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
            climitr,climitg,climitb);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
    
    
    case {'Green Over Red'}
        climitg(1) = str2num(get(handles.greenLimitStrLow,'String'));
        climitg(2) = str2num(get(handles.greenLimitStrHigh,'String'));
        if climitg(2)==climitg(1)
            climitg(2) = climitg(1)+0.001;%otherwise it will cause error below
        end
        climitr(1) = str2num(get(handles.redLimitStrLow,'String'));
        climitr(2) = str2num(get(handles.redLimitStrHigh,'String'));
        if climitr(2)==climitr(1)
            climitr(2) = climitr(1)+0.001;%otherwise it will cause error below
        end
        climitb(1) = str2num(get(handles.blueLimitStrLow,'String'));
        climitb(2) = str2num(get(handles.blueLimitStrHigh,'String'));
        if climitb(2)==climitb(1)
            climitb(2) = climitb(1)+0.001;%otherwise it will cause error below
        end
        colorim = h_createGORImage(currentStruct.image.display.red,currentStruct.image.display.green,currentStruct.image.display.blue,...
            climitr,climitg,climitb);
        gamma = str2num(get(handles.gamma,'String'));
        if gamma~=1
            colorim = imadjust(colorim,[],[],gamma);
        end
        set(c,'CData',colorim,'CDataMapping','scaled','ButtonDownFcn',ButtonDownFcn);
        set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn',ButtonDownFcn );
        
end


try
numSyn = size(jbm.knobs,1);
numDays = size(jbm.knobs,2);
catch
end

%%% White, Blue, Red Color Scheme
try
for i = 1:numDays
    zHi = get(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.zStackStrHigh,'String');
    zLo = get(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.zStackStrLow,'String');
    zHi = str2num(zHi);
    zLo = str2num(zLo);
    plane = mean([zHi zLo]);
    planes = [plane-2 plane-1 plane plane+1 plane+2];
    
    for j = 1:numSyn
        try
        synZ = jbm.scoringData.synapseZ(j,i);
        if ismember(synZ,planes)
            if synZ == plane
                set(jbm.scoringData.fluorData{j,i}.knob,'Color','blue');
            else
            set(jbm.scoringData.fluorData{j,i}.knob,'Color','white');
            end
        else
            set(jbm.scoringData.fluorData{j,i}.knob,'Color','red');
        end
            catch
        end
    end
end

catch
end


%%% White Blue Red Color Scheme on Background

try
    
    numSyn = size(jbm.knobs,1);
    numDays = size(jbm.knobs,2);
    
    
    for i = 1:numDays
        zHi = get(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.zStackStrHigh,'String');
        zLo = get(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.zStackStrLow,'String');
        zHi = str2num(zHi);
        zLo = str2num(zLo);
        plane = mean([zHi zLo]);
        planes = [plane-2 plane-1 plane plane+1 plane+2];
        
        
        bgZ = jbm.scoringData.bgFluorData{i}.roiZ;
        synZ = bgZ;;
        if ismember(bgZ,planes)
            if bgZ == plane
                set(jbm.scoringData.bgFluorData{i}.knob,'Color','blue');
            else
                set(jbm.scoringData.bgFluorData{i}.knob,'Color','white');
            end
        else
            set(jbm.scoringData.bgFluorData{i}.knob,'Color','red');
        end
        
        
        
    end
catch
end


end


