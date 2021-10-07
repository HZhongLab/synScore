function [maxIntensity, sliderSteps] = h_getMaxIntensity3(handles)

global h_img3;
% find the maximum intensity setting for both h_imstack2 and h_imstack2a as specified in handles.
[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if isfield(currentStruct.image.data, 'maxIntensity')
    maxIntensity = currentStruct.image.data.maxIntensity;
    sliderSteps = currentStruct.image.data.sliderSteps;    
	return;
end

data = currentStruct.image.data;

% maxIntensity_g = double(max(data.green(:)));
% maxIntensity_r = double(max(data.red(:)));
% maxIntensity_b = double(max(data.blue(:)));


%some times there are a few values that are very big. So try this:
threshPct = 99.995;
maxIntensity_g = double(prctile(data.green(:), threshPct));
maxIntensity_r = double(prctile(data.red(:), threshPct));
maxIntensity_b = double(prctile(data.blue(:), threshPct));

maxIntensity = max([maxIntensity_r, maxIntensity_g, maxIntensity_b]);

if isempty(maxIntensity) || maxIntensity < 1
    maxIntensity = 1;
    sliderSteps = [0.01, 0.1];
elseif maxIntensity < 2^8
    maxIntensity = 2^8 - 1;
    sliderSteps = [1/maxIntensity, 10/maxIntensity];
elseif maxIntensity < 2^10
    maxIntensity = 2^10 - 1;
    sliderSteps = [2/maxIntensity, 20/maxIntensity];
elseif maxIntensity < 2^11
    maxIntensity = 2^11 - 1;
    sliderSteps = [3/maxIntensity, 50/maxIntensity];
elseif maxIntensity < 2^12
    maxIntensity = 2^12 - 1;
    sliderSteps = [5/maxIntensity, 100/maxIntensity];
elseif maxIntensity < 2^13
    maxIntensity = 2^13 - 1;
    sliderSteps = [10/maxIntensity, 200/maxIntensity];
elseif maxIntensity < 2^14
    maxIntensity = 2^14 - 1;
    sliderSteps = [20/maxIntensity, 200/maxIntensity];
else
    maxIntensity = 2^16 - 1;
    sliderSteps = [100/maxIntensity, 1000/maxIntensity];
end

h_img3.(currentStructName).image.data.maxIntensity = maxIntensity;
h_img3.(currentStructName).image.data.sliderSteps = sliderSteps;