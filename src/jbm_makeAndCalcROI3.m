function [aout] = jbm_makeAndCalcROI3(handles,instance,xCo,yCo,zCo,xr,yr,high_quality,fin,depthRadii)
% 
RECURSION_THRESHOLD = 0.6;
% Init global databases
global h_img3;
global jbm;

% Make sure we are on the right day, and gather all the relevant figure and axis data
currentInstance = jbm.instancesOpen{instance};
currentAxes = h_img3.(currentInstance).gh.currentHandles.imageAxes;
currentFigure = h_img3.(currentInstance).gh.currentHandles.h_imstack3;
currentHandles = h_img3.(currentInstance).gh.currentHandles;
currentStructName = currentInstance;
figure(currentFigure);
axes(currentAxes);

hold on;

% Draw ciruclar ROI (probably an easier way to do this, or builtin MATLAB function,
% but works fine so leave it) <3

theta = (0:1/40:1)*2*pi;

xc = xCo;
yc = yCo;

xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;

% Takes green channel and subtracts the bleedthrough from percentage in h_imstack3
bleedthrough = h_getBleedthrough(currentHandles);
if bleedthrough ~= 0
    intensityMask_red = h_img3.(currentInstance).image.data.intensityMask_red;
    mostAbundantValue_red = h_img3.(currentInstance).image.data.mostAbundantValue_red;
    subtractionImg = (h_img3.(currentInstance).image.data.red-mostAbundantValue_red) .* bleedthrough;
    subtractionImg(~intensityMask_red) = 0;
    greenData = h_img3.(currentInstance).image.data.green - subtractionImg;
end

% Generate ROI mask
siz = h_img3.(currentInstance).image.data.size;
[aout.roi.BW,aout.roi.xi,aout.roi.yi] = roipoly(ones(siz(1),siz(2)),xi,yi);

% Filter for smoothing fluorescences
sigma = 2;
f = fspecial('gaussian',2*(sigma+1)+1);

% Find XY pixels in mask
ind = find(aout.roi.BW);

% Set zlim bounds based on the depthRadii search scalar
zLim(1) = zCo - depthRadii;
zLim(2) = zCo + depthRadii;

disp('Starting search: *******************************************')
disp('Search distance')
disp(zLim)

% To allow for recursive search through Z (from Haining's center of mass calculation method)
flagZ = 1;
recursions = 0.0;
synZ = zCo;

% 
%     if zLim(2) > size(greenData,3)
%         zLim(2) = size(greenData,3)
%         disp('***** ZLIM ERROR *****')
%         pause(1);
%     end
%     % Slice bleedthrough subtracted image in z
%     morph_data = greenData(:,:,zLim(1):zLim(2));
%     
%     % Go through each specified z plane, take the mean of the roi in those planes
%     intensity = zeros(1, size(morph_data,3));%Haining
%     for j = 1:size(morph_data,3)
%         im = morph_data(:,:,j);
%         intensity(j) = mean(im(ind));
%     end
%     
%     % Get center of mass in z
%     zi2 = sum(intensity.*(1:length(intensity)))/sum(intensity);
%     synZ = zi2 + zLim(1) - 1; 
%     fprintf('Center of mass:')
%     disp(synZ)
%     
%     fprintf('Mean of Zlim:')
%     disp(mean(zLim))
%    
%     % If the center of mass is far off from the original midpoint, call it ok, otherwise try again
%     if abs(synZ-mean(zLim))<= RECURSION_THRESHOLD
%         flagZ = 0; 
%     else 
%         fprintf('Recursion Number: ')
%         zLim = [- depthRadii, depthRadii] + round(synZ);
%         recursions = recursions + 1.0;
%         disp(recursions)
%     end
%     


% Record center of mass
aout.z_recursions = 1;
aout.synZ = synZ;

% Record original data
aout.startZ = zCo;
aout.synX = xCo;
aout.synY = yCo;


% % NEED TO GO OVER THIS WITH HAINING
% zi = find(intensity==max(intensity));
% zi = zi(1);
% if zi+1 <= size(morph_data,3)
%     z_end = zi+1;
% else % This should not happen
%     
%     fprintf('Some ROI has selected max plane to be top slice')
%     z_end = zi+1;
%     aout.z_com_error = true;
% end
% 
% if zi-1 >= 1
%     z_start = zi-1;
% else
%     fprintf('Some ROI has selected bottom plane to be bottom slice')
%     z_start = zi-1;
%     aout.z_com_error = true;
% end
% 
% zi = zi + zLim(1) - 1;
% aout.roi.z = (z_start:z_end) + zLim(1) - 1;
% 
% ind2 = [];
% for z = aout.roi.z
%     ind2 = vertcat(ind2,ind+(z-1)*siz(1)*siz(2)); % Particularly here: for example, why is it z-1!?
% end
% 
% aout.roiVol = numel(ind2);
% 
% if ~isempty(h_img3.(currentStructName).image.data.red)
%     red = h_img3.(currentStructName).image.data.red(ind2);
%     aout.max_intensity.red = max(max(filter2(f,aout.roi.BW .* double(h_img3.(currentStructName).image.data.red(:,:,zi)))));
% else
%     red = nan;
%     redbg = nan;
%     aout.max_intensity.red = nan;
% end
% 
% if ~isempty(greenData)
%     green = greenData(ind2);
%     aout.max_intensity.green = max(max(filter2(f,aout.roi.BW .* double(greenData(:,:,zi)))));
% else
%     green = nan;
%     aout.max_intensity.green = nan;
% end
% 
% if ~isempty(h_img3.(currentStructName).image.data.blue)
%     blue = h_img3.(currentStructName).image.data.blue(ind2);
%     aout.max_intensity.blue = max(max(filter2(f,aout.roi.BW .* double(h_img3.(currentStructName).image.data.blue(:,:,zi)))));
% else
%     blue = nan;
%     aout.max_intensity.blue = nan;
% end
% 
% 
% aout.green = green;
% aout.red = red;
% aout.blue = blue;
% 
% aout.avg_intensity.red = mean(red);
% aout.avg_intensity.green = mean(green);
% aout.avg_intensity.blue = mean(blue);
% 
% aout.max_intensity.red = aout.max_intensity.red;
% aout.max_intensity.green = aout.max_intensity.green;
% aout.max_intensity.blue = aout.max_intensity.blue;

% Haining: now plot
UserData.roi.xi = xi;
UserData.roi.yi = yi;

h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h, 'Tag', 'fluoROI3', 'Color','red','ButtonDownFcn', 'jbm_dragFluorRoi3');
hold off;
set(h,'UserData',UserData);
h_roiQuality3(handles);

aout.knob = h;
aout.xr = xr;
aout.yr = yr;
aout.high_quality = high_quality;
aout.fin = fin;

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% auto size is not working very well for synapse overlap with shaft or for
% very dim one. So bypass for now. Still have a future though if we have to
% go through it in the future.

%     %Haining now dynamically change ROI size
%     bleedThrough = h_getBleedthrough(currentHandles);
%     green = h_img3.(currentInstance).image.data.green(:,:,(-1:1)+round(synZ)) - bleedThrough * h_img3.(currentInstance).image.data.red(:,:,(-1:1)+round(synZ));
%     tempImg = filter2(f, sum(h_img3.(currentInstance).image.data.green(:,:,(-1:1)+round(synZ)),3));%filter the image.
%     sizToTest = 3:15;%Haining probably no synapse will be larger than 15. This can be tuned to gain speed.
%     totalInt = zeros(1, length(sizToTest));
%     BWSiz = zeros(1, length(sizToTest));
%     for ii = 1:length(sizToTest)
%         xr = sizToTest(ii);
%         yr = sizToTest(ii);
%         xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
%         yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
%         BW = roipoly(ones(siz(1),siz(2)),xi,yi);
%         totalInt(ii) = sum(tempImg(BW));
%         BWSiz(ii) = sum(BW(:));
%     end
%     diffInt(1) = totalInt(1);
%     diffInt = horzcat(diffInt,diff(totalInt));
%     diffBWSiz(1) = BWSiz(1);
%     diffBWSiz = horzcat(diffBWSiz,diff(BWSiz));
%     normDiffInt = diffInt./diffBWSiz;
%     [minIncrease, I] = min(normDiffInt); % this need normalization otherwise will bias towards small ROI sizes
%     [maxIncrease, I2] = max(normDiffInt);
%     if maxIncrease<500 % some syn is very dim, this can lead to very large ROI size.
%         maxIncrease = 500; % 300 is because it is the sum of 3 frames, also consider background (not subtract at this point).
%     end
%     thresh = (maxIncrease - minIncrease) * 0.05 + minIncrease;
%     I3 = find(normDiffInt>thresh);
% %     I4 = I3(I3>=I2 & I3<=I);
%     I4 = I3(I3<=I);
%     if max(I4)==1
%         ROISiz = sizToTest(I4);
%     else
%         ROISiz = sizToTest(max(I4)-1);
%     end
