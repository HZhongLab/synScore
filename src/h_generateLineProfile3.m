function Aout = h_generateLineProfile3(handles)


[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

% state = currentStruct.state;
data = currentStruct.image.data;

if isfield(currentStruct, 'lastAnalysis') && isfield(currentStruct.lastAnalysis, 'tracingData')
    tracingData = currentStruct.lastAnalysis.tracingData;
else
    disp('tracingData not available');
    return;
end

currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);

[pname2, fname2, fExt2] = fileparts(tracingData.filename);

if ~strcmp(fname, fname2)
    disp('tracing data file name and current image file name not matched.');
    return
end

delete(findobj(handles.imageAxes,'tag', 'h_lineProfileOutline3'));
cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'yellow'};

profileWidthStr = get(handles.profileWidth, 'String');
profileWidthVal = get(handles.profileWidth, 'value');
profileWidth = str2num(profileWidthStr{profileWidthVal});
profileWidth = round(profileWidth/2)*2; % set width always an even integer (so the profile always go through pos.

flags = sort(unique(tracingData.skeletonInPixel(:,5)));
siz = data.size;
for i = 1:length(flags)
    I = find(tracingData.skeletonInPixel(:,5)==flags(i));
    Aout(i).filename = tracingData.filename;
    Aout(i).flag = flags(i);
    Aout(i).profileWidth = profileWidth;
    Aout(i).profileImgR = zeros(profileWidth+1, length(I));
    Aout(i).profileImgG = zeros(profileWidth+1, length(I));
    Aout(i).profileImgB = zeros(profileWidth+1, length(I));
    Aout(i).xi = zeros(profileWidth+1, length(I));
    Aout(i).yi = zeros(profileWidth+1, length(I));
    Aout(i).zi = zeros(1, length(I));
    
    for j = 1:length(I)
        slope = tracingData.skeletonInPixel(I(j),6);
        profslope = -(1/slope);%this is the right angle slope.
        angle = atand(profslope);
%         if angle<0 && abs(angle)>45
%             angle = angle + 180;%clamp it to be 0-180 degree so that the profile outline has a consistent direction.
%         end
        point = tracingData.skeletonInPixel(I(j),1:2);
        z = tracingData.skeletonInPixel(I(j),3);
        Aout(i).zi(I(j)) = z;
        
        zi = round([z-1, z, z+1]);
        zi(zi<1) = [];
        zi(zi>siz(3)) = [];
        imgR = mean(data.red(:,:,zi),3);
        imgG = mean(data.green(:,:,zi),3);
        imgB = mean(data.blue(:,:,zi),3);
                
        [Aout(i).profileImgR(:,j), Aout(i).xi(:,j), Aout(i).yi(:,j)] = h_getLineProfileAtAPoint(imgR, point, angle, profileWidth);
        Aout(i).profileImgG(:,j) = h_getLineProfileAtAPoint(imgG, point, angle, profileWidth);
        Aout(i).profileImgB(:,j) = h_getLineProfileAtAPoint(imgB, point, angle, profileWidth);    
    end
    Aout(i).profileR = mean(Aout(i).profileImgR, 1);
    Aout(i).profileG = mean(Aout(i).profileImgG, 1);
    Aout(i).profileB = mean(Aout(i).profileImgB, 1);
    
    Aout(i).normProfileR = Aout(i).profileR./max(Aout(i).profileR);
    Aout(i).normProfileG = Aout(i).profileG./max(Aout(i).profileG);
    Aout(i).normProfileB = Aout(i).profileB./max(Aout(i).profileB);
    
    axes(handles.imageAxes);
    hold on
    plot(Aout(i).xi(1,:), Aout(i).yi(1,:),':', 'Color', cstr{mod(flags(i)-1,6)+1}, 'tag', 'h_lineProfileOutline3');
    plot(Aout(i).xi(end,:), Aout(i).yi(end,:),':', 'Color', cstr{mod(flags(i)-1,6)+1}, 'tag', 'h_lineProfileOutline3');
    hold off
    
    figure, plot(Aout(i).normProfileR, 'r-');
    hold on, plot(Aout(i).normProfileG, 'G-');
    plot(Aout(i).normProfileB, 'b-');
    
end
h_setDendriteTracingVis3(handles);


    
    
    
    
    





