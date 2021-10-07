function [aout] = jbm_makeAndCalcBGROI3(handles,zCo)
global h_img3
global jbm

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

obj = get(handles.imageAxes, 'Children');%unselectAll.
set(obj, 'Selected', 'off');%unselectAll.

Roi_size = 25;


        waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);
        disp(point1)% extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);
        if offset(1)<2 && offset(2)<2
            offset = [Roi_size, Roi_size];
        end
        ROI = [point1, offset(1), offset(2)];
        theta = (0:1/40:1)*2*pi;
        xr = ROI(3)/2;
        yr = ROI(4)/2;
        xc = ROI(1) + ROI(3)/2;
        yc = ROI(2) + ROI(4)/2;
        UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
        UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;

hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'h_dragRoi3', 'Tag', 'BGROI3', 'Color','red');
hold off;
x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;

UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
    'Center','VerticalAlignment','Middle', 'Color','yellow','ButtonDownFcn', 'h_dragRoiText3','FontSize', 14, 'FontWeight', 'Bold');
UserData.number = 'BG';
UserData.ROIhandle = h;
UserData.timeLastClick = clock;
set(h,'UserData',UserData);
set(UserData.texthandle,'UserData',UserData);
aout = UserData;
h_roiQuality3(handles);


aout=UserData;
aout.knob = h;
aout.texthandle = UserData.texthandle;
aout.zCo = zCo;
aout.xc = xc;
aout.yc = yc;
aout.xr = xr;
aout.yr = yr;


% Takes green channel and subtracts the bleedthrough from percentage in h_imstack3
bleedthrough = h_getBleedthrough(currentHandles);
if bleedthrough ~= 0
    intensityMask_red = h_img3.(currentInstance).image.data.intensityMask_red;
    mostAbundantValue_red = h_img3.(currentInstance).image.data.mostAbundantValue_red;
    subtractionImg = (h_img3.(currentInstance).image.data.red-mostAbundantValue_red) .* bleedthrough;
    subtractionImg(~intensityMask_red) = 0;
    greenData = h_img3.(currentInstance).image.data.green - subtractionImg;
end


h_roiQuality3(handles);

siz = h_img3.(currentInstance).image.data.size;

[aout.roi.BW,aout.roi.xi,aoit.roi.yi] = roipoly(ones(siz(1),siz(2)),UserData.roi.xi,UserData.roi.yi);

% Search through green channel
morph_data = h_img3.(currentInstance).image.data.green(:,:,zLim(1):zLim(2));

sigma = 2;
f = fspecial('gaussian',2*(sigma+1)+1);

ind = find(aout.roi.BW);

    zi = 2;
    z_start = 1;
    z_end = 3;
    
    zi = zi + zLim(1) - 1;
    if ~(zi == zCo)
        disp('Check a bug in BG ROI Calc')
    end
    
    
    aout.roi.z = (z_start:z_end) + zLim(1) - 1;
    
     ind2 = [];
    for z = aout.roi.z
        ind2 = vertcat(ind2,ind+(z-1)*siz(1)*siz(2));
    end
    
    aout.roiVol = numel(ind2);
    if ~isempty(h_img3.(currentStructName).image.data.red)
        red = h_img3.(currentStructName).image.data.red(ind2);
        aout.max_intensity.red = max(max(filter2(f,aout.roi.BW .* double(h_img3.(currentStructName).image.data.red(:,:,zi)))));
    else
        red = nan;
        redbg = nan;
        aout.max_intensity.red = nan;
    end
    
    if ~isempty(h_img3.(currentStructName).image.data.green)
        green = h_img3.(currentStructName).image.data.green(ind2);
        aout.max_intensity.green = max(max(filter2(f,aout.roi.BW .* double(h_img3.(currentStructName).image.data.green(:,:,zi)))));
    else
        green = nan;
        aout.max_intensity.green = nan;
    end
    if ~isempty(h_img3.(currentStructName).image.data.blue)
        blue = h_img3.(currentStructName).image.data.blue(ind2);
        aout.max_intensity.blue = max(max(filter2(f,aout.roi.BW .* double(h_img3.(currentStructName).image.data.blue(:,:,zi)))));
    else
        blue = nan;
        aout.max_intensity.blue = nan;
    end
    
    
    
    aout.avg_intensity.red = mean(red);
    aout.avg_intensity.green = mean(green);
    aout.avg_intensity.blue = mean(blue);
    
    aout.max_intensity.red = aout.max_intensity.red;
    aout.max_intensity.green = aout.max_intensity.green;
    aout.max_intensity.blue = aout.max_intensity.blue;
end

% Function that actually gathers the bleedthrough values from the string container on the GUI for use in green subtraction
function bleedthrough = h_getBleedthrough(handles)

bleedStr = get(handles.bleedThroughCorrOpt,'string');
bleedValue = get(handles.bleedThroughCorrOpt,'value');
bleedStr = bleedStr{bleedValue};
pointer1 = strfind(bleedStr,'%');
if ~isempty(pointer1)
    bleedNumStr = bleedStr(6:pointer1-1);
    bleedthrough = str2double(bleedNumStr) * 0.01;
else
    bleedthrough = 0;
end

end


