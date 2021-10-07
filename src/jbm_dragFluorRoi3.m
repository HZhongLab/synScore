function jbm_dragFluorRoi3
global jbm
% global h_img2

handles = guihandles(gcf);

% currentInstance = h_getCurrendInd3(handles);
[currentInstance, handles, currentStruct, currentStructName] = h_getCurrendInd3;



h_showRoi3(handles);

point1 = get(gca,'CurrentPoint'); % button down detected
point1 = point1(1,1:2);              % extract x and y



fluorroiobj = findobj(gcf,'Tag','fluorROI3');

currentObj = gco;

set(fluorroiobj, 'Selected','off', 'linewidth',1);
h_annotationROIQuality3(handles);%assigned synapses use linewidth 2...
% set(currentObj,'Selected','on','SelectionHighlight','on');
set(currentObj,'Selected','on','SelectionHighlight','off','linewidth',3);

h_annotationROIQuality3(handles);%assigned synapses use linewidth 2...
% set(currentObj,'Selected','on','SelectionHighlight','on');
set(currentObj,'Selected','on','SelectionHighlight','off','linewidth',3);

currentGcaUnit = get(gca,'Unit');
set(gca,'Unit','normalized');
rectFigure = get(gcf, 'Position');
rectAxes = get(gca, 'Position');
set(gca,'Unit',currentGcaUnit);

Xlimit = get(gca, 'XLim');
Ylimit = get(gca, 'Ylim');
Ylim = Ylimit(2)-Ylimit(1);
Xlim = Xlimit(2)-Xlimit(1);
xmag = (rectFigure(3)*rectAxes(3))/Xlim;  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/Ylim;
yoffset = rectAxes(2)*rectFigure(4);

%Will only be one but let it do for loops anyway
h = currentObj;

for i = 1:length(h)
    UData{i} = get(h(i),'UserData');
    RoiRect(i,:) = [min(UData{i}.roi.xi),min(UData{i}.roi.yi),...
            max(UData{i}.roi.xi)-min(UData{i}.roi.xi),max(UData{i}.roi.yi)-min(UData{i}.roi.yi)];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

if length(h)==1 && point1(1)>(RoiRect(1)+3/4*RoiRect(3)) && point1(2)>(RoiRect(2)+3/4*RoiRect(4))
    finalRect = rbbox(rects);
else
    finalRect = dragrect(rects);
end

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    
    if RoiRect(i,3) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1)) + newRoix;
    else
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1))/RoiRect(i,3)*newRoiw + newRoix;
    end

    if RoiRect(i,4) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2)) + newRoiy;
    else
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2))/RoiRect(i,4)*newRoih + newRoiy;
    end

%     UData{i}.roi.xc = newRoix; % this is wrong.
%     UData{i}.roi.yc = newRoiy;
    UData{i}.roi.xc = newRoix+newRoiw/2; 
    UData{i}.roi.yc = newRoiy+newRoih/2;
    UData{i}.roi.xr = newRoiw;
    UData{i}.roi.yr = newRoih;
    
    
    set(h(i),'XData',UData{i}.roi.xi,'YData',UData{i}.roi.yi,'UserData',UData{i});
    
end

jbm.scoringData.fluorData{jbm.currentSynIdx,currentInstance}.xc = newRoix;
jbm.scoringData.fluorData{jbm.currentSynIdx,currentInstance}.yc = newRoiy;
% jbm.scoringData.fluorData{jbm.currentSynIdx,currentInstance}.xc = newRoix+newRoiw/2;
% jbm.scoringData.fluorData{jbm.currentSynIdx,currentInstance}.yc = newRoiy+newRoiw/2;

%Haining to move marker position as resizing.

newXCo = newRoix+newRoiw/2;  % this is for the marker.
newYCo = newRoiy+newRoih/2; % this is for the marker.
ii = find(ismember(jbm.instancesOpen, currentStructName));
synMarkerUData = get(jbm.knobs(jbm.currentSynIdx,ii), 'UserData');
synMarkerUData.xCo = newXCo;
synMarkerUData.yCo = newYCo;
set(jbm.knobs(jbm.currentSynIdx,ii), 'UserData', synMarkerUData, 'XData', newXCo, 'YData', newYCo);
set(synMarkerUData.texthandle, 'Position', [newXCo,newYCo],'UserData',synMarkerUData);



for i = 1:length(jbm.instancesOpen)
    if ~isempty(jbm.scoringData.fluorData{jbm.currentSynIdx,i})
        try
        jbm.scoringData.fluorData{jbm.currentSynIdx,i}.xr = newRoiw/2;
        jbm.scoringData.fluorData{jbm.currentSynIdx,i}.yr = newRoih/2;
        
        
        delete(jbm.scoringData.fluorData{jbm.currentSynIdx,i}.knob);
        
        syn = get(jbm.knobs(jbm.currentSynIdx,i));
        ud = syn.UserData;
        
        xCo = ud.xCo;
        yCo = ud.yCo;
        zCo = jbm.scoringData.synapseZ(jbm.currentSynIdx,i);
        
        jbm.scoringData.fluorData{jbm.currentSynIdx,i}.knob = jbm_makeFluorROI3(handles,...
            i,xCo,yCo,zCo,jbm.currentSynIdx,newRoiw/2,newRoih/2);
        
        catch
        end
        
    end
    
end



h_roiQuality3(handles);
% h_replot3(handles) %Haining unnecessary.

