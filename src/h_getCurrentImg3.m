function h_getCurrentImg3(handles)

global h_img3
% tic
[redData, greenData, blueData] = h_getZFilteredData(handles);%this has to be done before below because it may change h_img3;
% toc
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
siz = currentStruct.image.data.size;
currentStruct.image.display = struct('red',[],'green',[],'blue',[]);
% toc
% zLim = [str2num(currentStruct.state.zStackStrLow.str),str2num(currentStruct.state.zStackStrHigh.str)];
zLim(1) = str2num(get(handles.zStackStrLow,'String'));
zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

if isfield(currentStruct.state,'lineScanDisplay') && currentStruct.state.lineScanDisplay.value
    currentStruct.image.display.green = permute(reshape(permute(currentStruct.image.image.green,[2,1,3]),[siz(2),siz(1)*(diff(zLim)+1)]),[2,1]);
    currentStruct.image.display.red = permute(reshape(permute(currentStruct.image.image.red,[2,1,3]),[siz(2),siz(1)*(diff(zLim)+1)]),[2,1]);
    currentStruct.image.display.blue = permute(reshape(permute(currentStruct.image.image.blue,[2,1,3]),[siz(2),siz(1)*(diff(zLim)+1)]),[2,1]);
    YLim = [0,h_img.image.data.size(1)]+0.5;
    set(handles.imageAxes,'YLim',YLim);
else
    dispAxes = get(handles.viewingAxisControl,'Value');
    switch dispAxes
        case {1}
            viewingAxis = 3;
            currentStruct.image.display.green = max(greenData(:,:,zLim(1):zLim(2)),[],viewingAxis);
            currentStruct.image.display.red = max(redData(:,:,zLim(1):zLim(2)),[],viewingAxis);
            currentStruct.image.display.blue = max(blueData(:,:,zLim(1):zLim(2)),[],viewingAxis);
        case {2}
            viewingAxis = 1;
            currentStruct.image.display.green = permute(max(greenData(zLim(1):zLim(2),:,:),[],viewingAxis),[3,2,1]);
            currentStruct.image.display.red = permute(max(redData(zLim(1):zLim(2),:,:),[],viewingAxis),[3,2,1]);
            currentStruct.image.display.blue = permute(max(blueData(zLim(1):zLim(2),:,:),[],viewingAxis),[3,2,1]);

        case {3}
            viewingAxis = 2;
            currentStruct.image.display.green = permute(max(greenData(:,zLim(1):zLim(2),:),[],viewingAxis),[3,1,2]);
            currentStruct.image.display.red = permute(max(redData(:,zLim(1):zLim(2),:),[],viewingAxis),[3,1,2]);
            currentStruct.image.display.blue = permute(max(blueData(:,zLim(1):zLim(2),:),[],viewingAxis),[3,1,2]);
    end
end
% toc
filter_on = get(handles.smoothImage','Value');

switch filter_on
    case 1
        f = [];
    case 2 % 'old'
%         sigma = 1;
        f = [0.07 0.12 0.07; 0.12 0.24 0.12; 0.07 0.12 0.07];
    case 3 % 'GF, s=1'
        sigma = 1;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 4 % 'GF, s=1.5'
        sigma = 1.5;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 5 % 'GF, s=2'
        sigma = 2;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 6 % 'GF, s=3'
        sigma = 3;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 7 % 'GF, s=5'
        sigma = 5;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 8 % 'sharpen'
        f = fspecial('unsharp');%note this is the sharpening filter
    case 9 % 'laplacian'
        f = fspecial('laplacian');%note this is the sharpening filter
    case 10 % 'GF&Sharp'
        sigma = 1;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
        currentStruct.image.display.green = imfilter(currentStruct.image.display.green, f);
        currentStruct.image.display.red = imfilter(currentStruct.image.display.red, f);
        currentStruct.image.display.blue = imfilter(currentStruct.image.display.blue, f);
        f = fspecial('unsharp');%note this is the sharpening filter
%     case 11
%         currentStruct.image.display.green = abs(fft2(currentStruct.image.display.green));
%         currentStruct.image.display.red = abs(fft2(currentStruct.image.display.red));
%         currentStruct.image.display.blue = abs(fft2(currentStruct.image.display.blue));
%         f = [];%note this is the sharpening filter
    otherwise
        f = [];
end
        
% toc
if ~isempty(f) %filter_on > 1
    %     f = ones(3)/9;
%     f = [0.07 0.12 0.07; 0.12 0.24 0.12; 0.07 0.12 0.07];
    currentStruct.image.display.green = imfilter(currentStruct.image.display.green, f);
    currentStruct.image.display.red = imfilter(currentStruct.image.display.red, f);
    currentStruct.image.display.blue = imfilter(currentStruct.image.display.blue, f);
end
% toc

h_img3.(currentStructName) = currentStruct;
        

% % resample the image if it is too big
% unit = get(handles.imageAxes,'unit');
% set(handles.imageAxes,'unit', 'pixel');
% pos = get(handles.imageAxes,'position');
% set(handles.imageAxes,'unit',unit);
% 
% screenPixelSize = max(pos(3:4));
% if any(size(currentStruct.image.display.green) > (2 * screenPixelSize))
%     currentStruct.image.display.green = imresize(currentStruct.image.display.green, [2 * screenPixelSize, 2 * screenPixelSize]);
% end
% if any(size(currentStruct.image.display.red) > (2 * screenPixelSize))
%     currentStruct.image.display.red = imresize(currentStruct.image.display.red, [2 * screenPixelSize, 2 * screenPixelSize]);
% end
% if any(size(currentStruct.image.display.blue) > (2 * screenPixelSize))
%     currentStruc t.image.display.blue = imresize(currentStruct.image.display.blue, [2 * screenPixelSize, 2 * screenPixelSize]);
% end
% currentStruct.image.data.size(1:2) = max(cat(1, size(currentStruct.image.display.green),size(currentStruct.image.display.red),size(currentStruct.image.display.blue)),[],1);

function [redData, greenData, blueData] = h_getZFilteredData(handles)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

siz = currentStruct.image.data.size;
bleedthrough = h_getBleedthrough(handles);    
dispAxes = get(handles.viewingAxisControl,'Value');
zFilter = h_getZFilter(handles);

if isfield(currentStruct.image, 'zFilteredData') && currentStruct.image.zFilteredData.bleedthrough==bleedthrough...
        && currentStruct.image.zFilteredData.dispAxes==dispAxes && currentStruct.image.zFilteredData.zFilter==zFilter... % if there is previously generated zFilteredData, use it.
%         && siz(1) == size(currentStruct.image.zFilteredData.green, 1) && siz(2) == size(currentStruct.image.zFilteredData.green, 2)...
%         && siz(3) == size(currentStruct.image.zFilteredData.green, 3)
    redData = currentStruct.image.zFilteredData.red;
    greenData = currentStruct.image.zFilteredData.green;
    blueData = currentStruct.image.zFilteredData.blue;
else
    redData = currentStruct.image.data.red;
    greenData = currentStruct.image.data.green;
    blueData = currentStruct.image.data.blue;
    % toc
    if bleedthrough ~= 0
        if isfield(currentStruct.image.data,'intensityMask_red') && isfield(currentStruct.image.data,'mostAbundantValue_red')
            intensityMask_red = currentStruct.image.data.intensityMask_red;
            mostAbundantValue_red = currentStruct.image.data.mostAbundantValue_red;

        else
%             tic
            red2 = double(redData(redData<prctile(redData(:), 75))); %get rid of real signal, which has to be at the top 25%
            
            meanRed2 = mean(red2);%red2 is already a vector.
            sdRed2 = std(red2);
            
% toc
            thresh = meanRed2 + 3 * sdRed2;
            threshImg = redData>thresh;
            se2 = strel('disk', 2);
            se3 = strel('disk', 3);
%             toc
            threshImg = imclose(threshImg, se2);
            intensityMask_red = imopen(threshImg, se3);

%             toc
            h_img3.(currentStructName).image.data.intensityMask_red = intensityMask_red;
            redHist = hist(double(redData(:)), double(0:max(redData(:))));
            [maxRedHist, mostAbundantValue_red] = max(redHist);
%             toc
            h_img3.(currentStructName).image.data.mostAbundantValue_red = mostAbundantValue_red;
        end
        %     toc
        subtractionImg = (redData-mostAbundantValue_red) .* bleedthrough;
        subtractionImg(~intensityMask_red) = 0;
        greenData = greenData - subtractionImg;
    end
    
    if zFilter~=1
        switch dispAxes
            case 1
                zFilter2 = [1 1 zFilter];
            case 2
                zFilter2 = [zFilter 1 1];
            case 3
                zFilter2 = [1 zFilter 1];
        end
        if all(siz>1)
            greenData = uint16(smooth3(single(greenData), 'box', zFilter2));
            %make it single is 30% faster. Output is single or double so need to convert back to uint16
            redData = uint16(smooth3(single(redData), 'box', zFilter2));
            blueData = uint16(smooth3(single(blueData), 'box', zFilter2));
        end
    end
        
        h_img3.(currentStructName).image.zFilteredData.red = redData;
        h_img3.(currentStructName).image.zFilteredData.green = greenData;
        h_img3.(currentStructName).image.zFilteredData.blue = blueData;
        h_img3.(currentStructName).image.zFilteredData.bleedthrough = bleedthrough;
        h_img3.(currentStructName).image.zFilteredData.dispAxes = dispAxes;
        h_img3.(currentStructName).image.zFilteredData.zFilter = zFilter;
%     end
end
        

function zFilter = h_getZFilter(handles)

maxProjectionOpt = get(handles.maxProjectionOpt, 'value');

switch maxProjectionOpt
    case {1, 2, 3}
        zFilter = 1;
    case {4, 5, 6}
%         zFilter = cat(3, 1, 1, 1)/3;
        zFilter = 3;
    case {7}
%         zFilter = cat(3, 1, 1, 1, 1, 1)/5;
        zFilter = 5;
end

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
        

