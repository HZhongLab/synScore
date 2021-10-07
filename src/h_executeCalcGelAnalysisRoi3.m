function Aout = h_executeCalcGelAnalysisRoi3(handles)

% global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

Aout = struct('roiNumber',[],'roi', [], 'bgroi', [], 'median_bg', [], 'avg_intensity', [], 'max_intensity',...
    [], 'spine_info', [], 'timestr', '', 'filename', '');

fname = get(handles.currentFileName,'String');
[filepath, filename, fExt] = fileparts(fname);

zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

siz = currentStruct.image.data.size;

roiobj = sort(findobj(handles.imageAxes,'Tag', 'ROI3'));
n_roi = length(roiobj);

Aout.roiNumber = [];
for j = 1:n_roi
    UserData = get(roiobj(j), 'UserData');
    [Aout.roi(j).BW,Aout.roi(j).xi,Aout.roi(j).yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
    Aout.roiNumber(j) = UserData.number;
end

[Aout.roiNumber,I] = sort(Aout.roiNumber);
Aout.roi = Aout.roi(I);


%%%%%%%%%%%%%%%%  Calculate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:n_roi
    ind = find(Aout.roi(i).BW);
    [I, J] = find(Aout.roi(i).BW);
    BW2 = false(size(Aout.roi(i).BW));%it could have been easier to use h_getOutline, but keep it as it is.
    BW2(min(I), min(J):max(J)) = 1;
    BW2(max(I), min(J):max(J)) = 1;
    ind_bg = find(BW2);
    
    switch currentStruct.state.channelForZ.value
        case 1
            morph_data = currentStruct.image.data.red(:,:,zLim(1):zLim(2));
        case 2
            morph_data = currentStruct.image.data.green(:,:,zLim(1):zLim(2));
        case 3
            morph_data = currentStruct.image.data.blue(:,:,zLim(1):zLim(2));
    end
    for j = 1:size(morph_data,3)
        im = morph_data(:,:,j);
        intensity(j) = mean(im(ind));
    end
    
    zi = find(intensity==max(intensity));
    zi = zi(1);
    if zi+1 <= size(morph_data,3)
        z_end = zi+1;
    else 
        z_end = zi;
    end
    if zi-1 >= 1 
        z_start = zi-1;
    else 
        z_start = zi;
    end
    zi = zi + zLim(1) - 1;
    Aout.roi(i).z = [z_start:z_end] + zLim(1) - 1;
    
    f = [0 0.15 0; 0.15 0.4 0.15; 0 0.15 0];
    ind2 = [];
    ind_bg2 = [];
    for z = Aout.roi(i).z
        ind2 = [ind2;ind+(z-1)*siz(1)*siz(2)];
        try ind_bg2 = [ind_bg2;ind_bg+(z-1)*siz(1)*siz(2)]; end
    end
    
    Aout.avg_intensity.roi_size (i) = length(ind2);
    
    if ~isempty(currentStruct.image.data.red)
        red = double(currentStruct.image.data.red(ind2));
        redbg = double(currentStruct.image.data.red(ind_bg2));
        Aout.max_intensity.red(i) = max(max(filter2(f,Aout.roi(i).BW .* double(currentStruct.image.data.red(:,:,zi)))));
    else
        red = nan;
        redbg = nan;
        Aout.max_intensity.red(i) = nan;
    end
    if ~isempty(currentStruct.image.data.green)
        green = double(currentStruct.image.data.green(ind2));
        greenbg = double(currentStruct.image.data.green(ind_bg2));
        Aout.max_intensity.green(i) = max(max(filter2(f,Aout.roi(i).BW .* double(currentStruct.image.data.green(:,:,zi)))));
    else
        green = nan;
        greenbg = nan;
        Aout.max_intensity.green(i) = nan;
    end
    if ~isempty(currentStruct.image.data.blue)
        blue = double(currentStruct.image.data.blue(ind2));
        bluebg = double(currentStruct.image.data.blue(ind_bg2));
        Aout.max_intensity.blue(i) = max(max(filter2(f,Aout.roi(i).BW .* double(currentStruct.image.data.blue(:,:,zi)))));
    else
        blue = nan;
        bluebg = nan;
        Aout.max_intensity.blue(i) = nan;
    end
    
%     if ~isempty(bgroiobj)
        Aout.median_bg.red(i) = median(redbg);
        Aout.median_bg.green(i) = median(greenbg);
        Aout.median_bg.blue(i) = median(bluebg);
%     else
%         Aout.avg_bg.red(i) = 0;
%         Aout.avg_bg.green(i) = 0;
%         Aout.avg_bg.blue(i) = 0;
%     end
    
    Aout.avg_intensity.red(i) = mean(red) - Aout.median_bg.red(i);
    Aout.avg_intensity.green(i) = mean(green) - Aout.median_bg.green(i);
    Aout.avg_intensity.blue(i) = mean(blue) - Aout.median_bg.blue(i);
    
    Aout.max_intensity.red(i) = Aout.max_intensity.red(i) - Aout.median_bg.red(i);
    Aout.max_intensity.green(i) = Aout.max_intensity.green(i) - Aout.median_bg.green(i);
    Aout.max_intensity.blue(i) = Aout.max_intensity.blue(i) - Aout.median_bg.blue(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
switch lower(currentStruct.info.fileType)
    case 'scanimage'
        Aout.timestr = currentStruct.info.internal.triggerTimeString;
        if isempty(Aout.timestr)
            fileinfo = dir(fname);
            Aout.timestr = fileinfo.date;
        end
    case 'lsmtif'
        Aout.timestr = currentStruct.info.FileModDate;
    otherwise
        fileinfo = dir(fname);
        Aout.timestr = fileinfo.date;
end

Aout.filename = filename;

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~exist(fullfile(filepath,'Analysis'), 'dir')
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = currentStruct.state.analysisNumber.value;

fname = fullfile(filepath,'Analysis',[filename,'_V3roi_A',num2str(analysisNumber),'.mat']);
save(fname, 'Aout');
