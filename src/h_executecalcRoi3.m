function [Aout, Bout] = h_executecalcRoi3(handles)

% Aout is regular ROI, Bout is annotationROI.

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

Aout = struct('roiNumber',[],'roi', [], 'bgroi', [], 'avg_bg', [], 'avg_intensity', [], 'roiVol', [], 'max_intensity',...
    [], 'roiCentroidPos', [], 'timestr', '', 'filename', '');

fname = get(handles.currentFileName,'String');
[filepath, filename, fExt] = fileparts(fname);

zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

siz = h_img3.(currentStructName).image.data.size;

roiObj = sort(findobj(handles.imageAxes,'Tag', 'ROI3'));
annotationROIObj = findobj(handles.imageAxes, 'tag', 'annotationROI3');

n_roi = length(roiObj);

for j = 1:n_roi
    UserData = get(roiObj(j), 'UserData');
    [Aout.roi(j).BW,Aout.roi(j).xi,Aout.roi(j).yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
    Aout.roiNumber(j) = UserData.number;
end

[Aout.roiNumber,I] = sort(Aout.roiNumber);
Aout.roi = Aout.roi(I);

bgroiobj = findobj(handles.imageAxes,'Tag','BGROI3');
if ~isempty(bgroiobj)
    UserData = get(bgroiobj, 'UserData');
    [Aout.bgroi.BW,Aout.bgroi.xi,Aout.bgroi.yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
    ind_bg = find(Aout.bgroi.BW);
else
    ind_bg = [];
end

switch h_img3.(currentStructName).state.channelForZ.value
    case 1
        morph_data = h_img3.(currentStructName).image.data.red(:,:,zLim(1):zLim(2));
    case 2
        morph_data = h_img3.(currentStructName).image.data.green(:,:,zLim(1):zLim(2));
    case 3
        morph_data = h_img3.(currentStructName).image.data.blue(:,:,zLim(1):zLim(2));
end

%%%%%%%%%%%%%%%%  Calculate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = 2;
f = fspecial('gaussian', 2*(sigma+1)+1, sigma);%to reduce noise in measuring max value.

for i = 1:n_roi
    ind = find(Aout.roi(i).BW);

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
    Aout.roi(i).z = (z_start:z_end) + zLim(1) - 1;
    
%     f = [0 0.15 0; 0.15 0.4 0.15; 0 0.15 0];
    ind2 = [];
    ind_bg2 = [];
    for z = Aout.roi(i).z
        ind2 = vertcat(ind2,ind+(z-1)*siz(1)*siz(2));
        ind_bg2 = vertcat(ind_bg2,ind_bg+(z-1)*siz(1)*siz(2));
    end
    
    Aout.roiVol(i) = numel(ind2);
    
    if ~isempty(h_img3.(currentStructName).image.data.red)
        red = h_img3.(currentStructName).image.data.red(ind2);
        redbg = h_img3.(currentStructName).image.data.red(ind_bg2);
        Aout.max_intensity.red(i) = max(max(filter2(f,Aout.roi(i).BW .* double(h_img3.(currentStructName).image.data.red(:,:,zi)))));
    else
        red = nan;
        redbg = nan;
        Aout.max_intensity.red(i) = nan;
    end
    if ~isempty(h_img3.(currentStructName).image.data.green)
        green = h_img3.(currentStructName).image.data.green(ind2);
        greenbg = h_img3.(currentStructName).image.data.green(ind_bg2);
        Aout.max_intensity.green(i) = max(max(filter2(f,Aout.roi(i).BW .* double(h_img3.(currentStructName).image.data.green(:,:,zi)))));
    else
        green = nan;
        greenbg = nan;
        Aout.max_intensity.green(i) = nan;
    end
    if ~isempty(h_img3.(currentStructName).image.data.blue)
        blue = h_img3.(currentStructName).image.data.blue(ind2);
        bluebg = h_img3.(currentStructName).image.data.blue(ind_bg2);
        Aout.max_intensity.blue(i) = max(max(filter2(f,Aout.roi(i).BW .* double(h_img3.(currentStructName).image.data.blue(:,:,zi)))));
    else
        blue = nan;
        bluebg = nan;
        Aout.max_intensity.blue(i) = nan;
    end
    
    if ~isempty(bgroiobj)
        Aout.avg_bg.red(i) = mean(redbg);
        Aout.avg_bg.green(i) = mean(greenbg);
        Aout.avg_bg.blue(i) = mean(bluebg);
    else
        Aout.avg_bg.red(i) = 0;
        Aout.avg_bg.green(i) = 0;
        Aout.avg_bg.blue(i) = 0;
    end
    
    Aout.avg_intensity.red(i) = mean(red) - Aout.avg_bg.red(i);
    Aout.avg_intensity.green(i) = mean(green) - Aout.avg_bg.green(i);
    Aout.avg_intensity.blue(i) = mean(blue) - Aout.avg_bg.blue(i);
    
    Aout.max_intensity.red(i) = Aout.max_intensity.red(i) - Aout.avg_bg.red(i);
    Aout.max_intensity.green(i) = Aout.max_intensity.green(i) - Aout.avg_bg.green(i);
    Aout.max_intensity.blue(i) = Aout.max_intensity.blue(i) - Aout.avg_bg.blue(i);
end


n_roi = length(annotationROIObj);

Bout = struct('roiNumber',[], 'synapseNumber', [], 'roi', [], 'bgroi', [], 'avg_bg', [], 'avg_intensity', [], 'roiVol', [], 'max_intensity',...
    [], 'roiCentroidPos', [], 'timestr', '', 'filename', '');


for j = 1:n_roi
    UserData = get(annotationROIObj(j), 'UserData');
    [Bout.roi(j).BW,Bout.roi(j).xi,Bout.roi(j).yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
    Bout.roiNumber(j) = UserData.number;
    Bout.synapseNumber(j) = UserData.synapseAnalysis.synapseNumber;
    Bout.annotationROIUserData(j) = UserData;
end

[Bout.roiNumber,I] = sort(Bout.roiNumber);
Bout.roi = Bout.roi(I);
Bout.synapseNumber = Bout.synapseNumber(I);

Bout.bgroi = Aout.bgroi;

%%%%%%%%%%%%%%%%  Calculate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = 2;
f = fspecial('gaussian', 2*(sigma+1)+1, sigma);%to reduce noise in measuring max value.

for i = 1:n_roi
    ind = find(Bout.roi(i).BW);

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
    Bout.roi(i).z = (z_start:z_end) + zLim(1) - 1;
    
%     f = [0 0.15 0; 0.15 0.4 0.15; 0 0.15 0];
    ind2 = [];
    ind_bg2 = [];
    for z = Bout.roi(i).z
        ind2 = vertcat(ind2, ind+(z-1)*siz(1)*siz(2));
        ind_bg2 = vertcat(ind_bg2, ind_bg+(z-1)*siz(1)*siz(2));
    end
    
    Bout.roiVol(i) = numel(ind2);
    
    if ~isempty(h_img3.(currentStructName).image.data.red)
        red = h_img3.(currentStructName).image.data.red(ind2);
        redbg = h_img3.(currentStructName).image.data.red(ind_bg2);
        Bout.max_intensity.red(i) = max(max(filter2(f,Bout.roi(i).BW .* double(h_img3.(currentStructName).image.data.red(:,:,zi)))));
    else
        red = nan;
        redbg = nan;
        Bout.max_intensity.red(i) = nan;
    end
    if ~isempty(h_img3.(currentStructName).image.data.green)
        green = h_img3.(currentStructName).image.data.green(ind2);
        greenbg = h_img3.(currentStructName).image.data.green(ind_bg2);
        Bout.max_intensity.green(i) = max(max(filter2(f,Bout.roi(i).BW .* double(h_img3.(currentStructName).image.data.green(:,:,zi)))));
    else
        green = nan;
        greenbg = nan;
        Bout.max_intensity.green(i) = nan;
    end
    if ~isempty(h_img3.(currentStructName).image.data.blue)
        blue = h_img3.(currentStructName).image.data.blue(ind2);
        bluebg = h_img3.(currentStructName).image.data.blue(ind_bg2);
        Bout.max_intensity.blue(i) = max(max(filter2(f,Bout.roi(i).BW .* double(h_img3.(currentStructName).image.data.blue(:,:,zi)))));
    else
        blue = nan;
        bluebg = nan;
        Bout.max_intensity.blue(i) = nan;
    end
    
    if ~isempty(bgroiobj)
        Bout.avg_bg.red(i) = mean(redbg);
        Bout.avg_bg.green(i) = mean(greenbg);
        Bout.avg_bg.blue(i) = mean(bluebg);
    else
        Bout.avg_bg.red(i) = 0;
        Bout.avg_bg.green(i) = 0;
        Bout.avg_bg.blue(i) = 0;
    end
    
    Bout.avg_intensity.red(i) = mean(red) - Bout.avg_bg.red(i);
    Bout.avg_intensity.green(i) = mean(green) - Bout.avg_bg.green(i);
    Bout.avg_intensity.blue(i) = mean(blue) - Bout.avg_bg.blue(i);
    
    Bout.max_intensity.red(i) = Bout.max_intensity.red(i) - Bout.avg_bg.red(i);
    Bout.max_intensity.green(i) = Bout.max_intensity.green(i) - Bout.avg_bg.green(i);
    Bout.max_intensity.blue(i) = Bout.max_intensity.blue(i) - Bout.avg_bg.blue(i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add the x, y, z localization calculation%
Aout.roiCentroidPos = calculateXYZPos(Aout, currentStruct, zLim);
Bout.roiCentroidPos = calculateXYZPos(Bout, currentStruct, zLim);
%end of adding the x, y, z calculation position%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
switch lower(h_img3.(currentStructName).info.fileType)
    case 'scanimage'
        Aout.timestr = h_img3.(currentStructName).info.internal.triggerTimeString;
        Bout.timestr = h_img3.(currentStructName).info.internal.triggerTimeString;
        if isempty(Aout.timestr)
            fileinfo = dir(fname);
            Aout.timestr = fileinfo.date;
            Bout.timestr = fileinfo.date;
        end
    case 'lsmtif'
        Aout.timestr = h_img3.(currentStructName).info.FileModDate;
        Bout.timestr = h_img3.(currentStructName).info.FileModDate;
    otherwise
        fileinfo = dir(fname);
        Aout.timestr = fileinfo.date;
        Bout.timestr = fileinfo.date;
end

Aout.filename = filename;
Bout.filename = filename;

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~exist(fullfile(filepath,'Analysis'),'dir')
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = h_img3.(currentStructName).state.analysisNumber.value;

fname = fullfile(filepath,'Analysis',[filename,'_V3roi_A',num2str(analysisNumber),'.mat']);
save(fname, 'Aout', 'Bout');%Aout is about ROI3, Bout is about annotationROI3

h_updateInfo3(handles);


function roiCentroidPos = calculateXYZPos(Aout, currentStruct, zLim)

try
    switch lower(currentStruct.info.fileType)
        case 'scanimage'
            info = h_quickinfo(currentStruct.info);
            
            [xFOV yFOV] = calculateFieldOfView(info.zoom);
            % xFOV = 40;%temp - no calculateFieldOfView
            % yFOV = 40;
            xScale = xFOV / currentStruct.info.acq.pixelsPerLine;
            yScale = yFOV / currentStruct.info.acq.linesPerFrame;%pixel size in micron
            zScale = currentStruct.info.acq.zStepSize;
        case 'lsmtif'
            xScale = currentStruct.info.XResolution / currentStruct.info.Width;
            yScale = currentStruct.info.YResolution / currentStruct.info.Height;
            zScale = 1; % this is fake.
        otherwise
            xScale = 1;
            yScale = 1;
            zScale = 1;
    end
catch
    xScale = 1;
    yScale = 1;
    zScale = 1;
end
scale = [xScale yScale zScale];

%%%%%%%% find intensity center of each ROI %%%%%%%%
siz = size(currentStruct.image.data.size);
green_data = currentStruct.image.data.green;
red_data = currentStruct.image.data.red;
blue_data = currentStruct.image.data.blue;

roiCentroidPos.posInPixel_G = zeros(length(Aout.roi),3);% x, y, z in pixels
roiCentroidPos.posInPixel_R = zeros(length(Aout.roi),3);% x, y, z 
roiCentroidPos.posInPixel_B = zeros(length(Aout.roi),3);% x, y, z 
roiCentroidPos.posInMicron_G = zeros(length(Aout.roi),3);% x, y, z in microns
roiCentroidPos.posInMicron_R = zeros(length(Aout.roi),3);% x, y, z 
roiCentroidPos.posInMicron_B = zeros(length(Aout.roi),3);% x, y, z 
roiCentroidPos.scale = scale;

for i = 1:length(Aout.roi)
    BW = Aout.roi(i).BW;
    z = Aout.roi(i).z;
%     xi = Aout.roi(i).xi;
%     yi = Aout.roi(i).yi;

    if ~(z(1)<=zLim(1) || z(end)>=zLim(2))
        zRange = [z(1)-1, z, z(end)+1];
    else
        zRange = z;
    end

    %     BW2 = repmat(BW, [1, 1, length(z)]);
    %calc x, y
    avgGreenImg = mean(green_data(:,:,z),3);%average to reduce noice.
    greenRoiImg = avgGreenImg.*BW;
    [roiCentroidPos.posInPixel_G(i,1), roiCentroidPos.posInPixel_G(i,2)] = h_calculateCenterOfMass(greenRoiImg);
    %use COM instead of gaussian fitting. Many ROIs are not exactly gaussian...
    
    avgRedImg = mean(red_data(:,:,z),3);%average to reduce noice.
    redRoiImg = avgRedImg.*BW;
    [roiCentroidPos.posInPixel_R(i,1), roiCentroidPos.posInPixel_R(i,2)] = h_calculateCenterOfMass(redRoiImg);

    avgBlueImg = mean(blue_data(:,:,z),3);%average to reduce noice.
    blueRoiImg = avgBlueImg.*BW;
    [roiCentroidPos.posInPixel_B(i,1), roiCentroidPos.posInPixel_B(i,2)] = h_calculateCenterOfMass(blueRoiImg);

    %calc z using slightly wider range.
    img = double(green_data(:,:,zRange));
    img = img.*repmat(BW, [1 1 length(zRange)]);
    [x, y, roiCentroidPos.posInPixel_G(i,3)] = h_calculateCenterOfMass(img);
    roiCentroidPos.posInPixel_G(i,3) = roiCentroidPos.posInPixel_G(i,3) + zRange(1) - 1;
    %use COM instead of gaussian fitting. fitting often not converge for z.
    
    img = double(red_data(:,:,zRange));
    img = img.*repmat(BW, [1 1 length(zRange)]);
    [x, y, roiCentroidPos.posInPixel_R(i,3)] = h_calculateCenterOfMass(img);
    roiCentroidPos.posInPixel_R(i,3) = roiCentroidPos.posInPixel_R(i,3) + zRange(1) - 1;
    
    img = double(blue_data(:,:,zRange));
    img = img.*repmat(BW, [1 1 length(zRange)]);
    [x, y, roiCentroidPos.posInPixel_B(i,3)] = h_calculateCenterOfMass(img);
    roiCentroidPos.posInPixel_B(i,3) = roiCentroidPos.posInPixel_B(i,3) + zRange(1) - 1;
    
    roiCentroidPos.posInMicron_G(i,:) = roiCentroidPos.posInPixel_G(i,:) .* scale;
    roiCentroidPos.posInMicron_R(i,:) = roiCentroidPos.posInPixel_R(i,:) .* scale;
    roiCentroidPos.posInMicron_B(i,:) = roiCentroidPos.posInPixel_B(i,:) .* scale;
end
