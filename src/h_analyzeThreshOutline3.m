function h_analyzeThreshOutline3(handles)

global h_img3;

% jbm/manualthreshold/072715

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

dispAxes = get(handles.viewingAxisControl,'Value');
if dispAxes~=1
    disp('viewing axis has to be x-y!');
    return;
else
    thresh = h_getThresh3(handles);
    if isempty(thresh)
        disp('Cannot determine threshold. Possibly no background ROI or wrong manual value.');
        return;
    end
end

bleedthrough = h_getBleedThrough3(handles);
displayImgOpt = get(handles.useDisplayImgOpt, 'value');

if displayImgOpt
    img_g = currentStruct.image.display.green;
    img_r = currentStruct.image.display.red;
else
    zLim(1) = str2num(get(handles.zStackStrLow,'String'));
    zLim(2) = str2num(get(handles.zStackStrHigh,'String'));
    img_g = max(currentStruct.image.data.green(:,:,zLim(1):zLim(2)), [], 3);
    img_r = max(currentStruct.image.data.red(:,:,zLim(1):zLim(2)), [], 3);
end

img_g = img_g - bleedthrough * (img_r - thresh.bgMean_r);

mask = img_g > thresh.thresh_g;

se = strel('disk', 2);

mask2 = imopen(mask, se);

axes(handles.imageAxes);

h = findobj(handles.imageAxes, 'Tag', 'threshOutline3');
delete(h);

hold on, h = h_plotOutline(gca, mask2, 'm-');
set(h, 'Tag', 'threshOutline3');



%try to use Qian's extrema2 algorithm
img2 = double(img_g).*double(mask2);
[XMAX,IMAX,XMIN,IMIN] = extrema2(double(img_g));
i = 0;
y = zeros(1000, 1);
x = zeros(1000, 1);
while ~isempty(IMAX)
    i = i + 1;
    [y(i), x(i)] = ind2sub(size(img2), IMAX(1));
    eraseMask = img2 > 0.6*XMAX(1);
    labeledEraseMask = bwlabel(eraseMask);
    eraseInd = find(labeledEraseMask(IMAX)==labeledEraseMask(IMAX(1)));
    XMAX(eraseInd) = [];
    IMAX(eraseInd) = [];
end
y(i+1:end) = [];
x(i+1:end) = [];

h = findobj(handles.imageAxes, 'Tag', 'autoDetectedSynapses3');
delete(h);

plot(handles.imageAxes, x, y, 'm+', 'Tag', 'autoDetectedSynapses3');

h_setVisible3(handles);

    


function bleedthrough = h_getBleedThrough3(handles)

bleedStr = get(handles.bleedthroughForSynapseDetection,'string');
bleedValue = get(handles.bleedthroughForSynapseDetection,'value');
bleedStr = bleedStr{bleedValue};
pointer1 = strfind(bleedStr,'%');
if ~isempty(pointer1)
    bleedNumStr = bleedStr(6:pointer1-1);
    bleedthrough = str2double(bleedNumStr) * 0.01;
else
    bleedthrough = 0;
end


function thresh = h_getThresh3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

bgroiobj = findobj(handles.imageAxes,'Tag','BGROI3');
if isempty(bgroiobj)
    thresh = [];
    return;
end

siz = currentStruct.image.data.size;
bgData = get(bgroiobj, 'UserData');
BW = roipoly(ones(siz(1), siz(2)), bgData.roi.xi, bgData.roi.yi);

zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

green = currentStruct.image.data.green(:,:,zLim(1):zLim(2));
red = currentStruct.image.data.red(:,:,zLim(1):zLim(2));

BW = repmat(BW, [1, 1, size(green(3))]);

bgPixels_g = double(green(BW));
bgPixels_r = double(red(BW));

switch get(handles.threshForSynapseDetection, 'value')
    case {1, 6}
        threshSetting = 5;
    case {2}
        threshSetting = 2;
    case {3}
        threshSetting = 2.5;
    case {4}
        threshSetting = 3;
    case {5}
        threshSetting = 4;
    case {7}
        threshSetting = 6;
    case {8}
        threshSetting = 8;
    case {9}
        threshSetting = 10;
    case {10}
        threshSetting = str2num(currentStruct.state.manualThresh.string);
        if isempty(threshSetting)
            disp('Manual threshold not correct!')
            thresh = [];
            return;
        end
    otherwise
end

thresh.threshSetting = threshSetting;
thresh.bgMean_g = mean(bgPixels_g);
thresh.bgSD_g = std(bgPixels_g);
thresh.thresh_g = thresh.bgMean_g + threshSetting * thresh.bgSD_g;
thresh.bgMean_r = mean(bgPixels_r);
thresh.bgSD_r = std(bgPixels_r);
thresh.thresh_r = thresh.bgMean_r + threshSetting * thresh.bgSD_r;




