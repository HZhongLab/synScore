function Aout = h_calcROIDistToFiducial3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
siz = currentStruct.image.data.size;

fiducialObj = findobj(handles.imageAxes, 'Tag', 'fiducialPoint3');

ROIObj = findobj(handles.imageAxes, 'Tag', 'annotationROI3');

fiducialUData = get(fiducialObj, 'UserData');
ROIUData = get(ROIObj, 'UserData');

if iscell(ROIUData)
    ROIUData = cell2mat(ROIUData);
end

x = zeros(length(ROIUData),1);
y = zeros(length(ROIUData),1);
ROINames = cell(length(ROIUData),1);

for i = 1:length(ROIUData)
    if ROIUData(i).synapseAnalysis.synapseNumber < 0
        ROINames{i} = num2str(ROIUData(i).number);
    else
        ROINames{i} = ['S', num2str(ROIUData(i).synapseAnalysis.synapseNumber)];
    end
    BW = roipoly(ones(siz(1), siz(2)), ROIUData(i).roi.xi, ROIUData(i).roi.yi);
    [x(i), y(i)] = h_calculateCenterOfMass(BW);

%     x(i) = mean([max(ROIUData(i).roi.xi), min(ROIUData(i).roi.xi)]);
%     y(i) = mean([max(ROIUData(i).roi.yi), min(ROIUData(i).roi.yi)]);

end

[ROINames, I] = sort(ROINames);
x = x(I);
y = y(I);

Aout.ROINames = ROINames;
Aout.ROIx = x;
Aout.ROIy = y;
Aout.fiducialX = fiducialUData.x;
Aout.fiducialY = fiducialUData.y;
pos1 = horzcat(x, y);
pos2 = horzcat(fiducialUData.x, fiducialUData.y);
pos2 = repmat(pos2, [length(x), 1]);

Aout.dist = h_calcDistance(pos1, pos2);

disp('***************');
for i = 1:length(x)
    disp([ROINames{i}, '   ',num2str(Aout.dist(i))]);
end
disp('***************');
fprintf('\n');
                        
                    

