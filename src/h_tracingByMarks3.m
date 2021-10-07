function Aout = h_tracingByMarks3(handles)

% global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

state = currentStruct.state;
%     data = currentStruct.image.data;

cstr = {'cyan', 'blue', 'green', 'magenta', 'cyan', 'yellow'};

% info does not work for lsm files. So just go by pixels. When caculate,
% only use 1 pixel spacing in x and y.
if strcmp(currentStruct.info.fileType, 'scanimage')
    info = h_quickinfo(currentStruct.info);
    try
        [xFOV yFOV] = calculateFieldOfView(info.zoom);
    catch
        disp('Function calculateFieldOfView is not in path.');
    end
    xScale = xFOV / currentStruct.info.acq.pixelsPerLine;
    yScale = yFOV / currentStruct.info.acq.linesPerFrame;%pixel size in micron
    zScale = currentStruct.info.acq.zStepSize;
    scale = [xScale yScale zScale];
else
    scale = [0.1 0.1 1];
end

inflationFactor = 10;
scale = scale*inflationFactor;%inflate the scale so that the tracing spacing is 0.1 um instead of 1 um.

%find all the marking points
tracingMarkObj = findobj(handles.imageAxes,'Tag','h_tracingMark3');
UData = get(tracingMarkObj,'UserData');
if iscell(UData)
    UData = cell2mat(UData);
end
Aout.tracingMarks = UData;

%%%%%%% make a skeleton %%%%%%%%%
% skeletonInPixel = zeros(10000, 4);%x, y, z and length to first position
skeletonInMicron = zeros(10000, 6);%x, y, z, length to first flag position in micron, flag, and slope in (x,y) of current segment
j = 0;

if ~isempty(UData)
    flag = [UData.flag];
    flag2 = flag;%flag2 is the one that will change within the loop, flag does not change.
    while ~isempty(flag2)
        currentFlag = min(flag2);
        currentUData = UData(flag==currentFlag);

        %sort the ROIs just in case.
        num = [currentUData.number];
        [num,I] = sort(num);
        currentUData = currentUData(I);

        % skeletonInPixel(1,1:3) = UData(1).pos;
        j = j + 1;
        skeletonInMicron(j,1:3) = currentUData(1).pos .* scale;
        skeletonInMicron(j,5) = currentFlag;
        previousMarkPosInMicron = skeletonInMicron(j,1:4);
        k = j;% remember this position.

        for i = 2:length(num)
            currentMarkPosInMicron = currentUData(i).pos .* scale;
            distance = h_calcDistance(previousMarkPosInMicron(1:3), currentMarkPosInMicron);
%             distance = h_calcDistance(previousMarkPosInMicron(1:2), currentMarkPosInMicron(1:2));%only use x and y.
            currentMarkPosInMicron(4) = previousMarkPosInMicron(4) + distance;
            if distance ~= 0 %there will be NaN if zero
%                 steps = ([1:floor(distance*10),distance*10]/10)';%0.1 um steps, marking point always in.
                if previousMarkPosInMicron(4)~=round(previousMarkPosInMicron(4))% if not an integer (e.g. 1, 2)
                    steps = ceil(previousMarkPosInMicron(4)):floor(currentMarkPosInMicron(4));% 1 um steps When scale is set to one, this is one pixel step.
                else
                    steps = (previousMarkPosInMicron(4)+1):floor(currentMarkPosInMicron(4));% 1 um steps When scale is set to one, this is one pixel step.
                end
                dist1 = [previousMarkPosInMicron(4), currentMarkPosInMicron(4)];
                xCoor = [previousMarkPosInMicron(1), currentMarkPosInMicron(1)];
                yCoor = [previousMarkPosInMicron(2), currentMarkPosInMicron(2)];
                zCoor = [previousMarkPosInMicron(3), currentMarkPosInMicron(3)];
                newXCoor = interp1(dist1, xCoor, steps);
                newYCoor = interp1(dist1, yCoor, steps);
                newZCoor = interp1(dist1, zCoor, steps);
                
                temp = zeros(length(steps),6);
                temp(:,1) = newXCoor;
                temp(:,2) = newYCoor;
                temp(:,3) = newZCoor;
                temp(:,4) = steps;
                temp(:,5) = currentFlag;
                temp(:,6) = (previousMarkPosInMicron(2)-currentMarkPosInMicron(2))/(previousMarkPosInMicron(1)-currentMarkPosInMicron(1));%slope
                skeletonInMicron((1:length(steps))+j,:) = temp;
                j = j + length(steps);
            else
%                 steps = 0;%0.1 um steps, marking point always in.
%                 temp = skeletonInMicron(j,:);
            end
            previousMarkPosInMicron = currentMarkPosInMicron;
%             disp([i, j])
        end
        flag2(flag2==currentFlag) = [];
        skeletonInMicron(k,6) = skeletonInMicron(k+1,6);%otherwise this will be zero and is not right.
    end
end

skeletonInMicron(j+1:end,:) = [];
skeletonInMicron(:,1:4) = skeletonInMicron(:,1:4)/inflationFactor;
skeletonInPixel = skeletonInMicron;
skeletonInPixel(:,1:3) = skeletonInPixel(:,1:3) ./ repmat(scale/inflationFactor, [size(skeletonInPixel,1), 1]);

Aout.skeletonInPixel = skeletonInPixel;
Aout.skeletonInMicron = skeletonInMicron;


%write in this way so that in the future it will become an independent
%functional module.
axes(handles.imageAxes);
delete(findobj(handles.imageAxes,'Tag', 'h_dendriteSkeleton3'));
hold on;
flag = Aout.skeletonInPixel(:,5);
flag2 = flag;%flag2 is the one that will change within the loop, flag does not change.
while ~isempty(flag2)
    currentFlag = min(flag2);
    ind = find(flag==currentFlag);    
    plot(Aout.skeletonInPixel(ind,1),Aout.skeletonInPixel(ind,2),'-', 'Color', cstr{mod(currentFlag-1,6)+1},...
        'tag', 'h_dendriteSkeleton3', 'UserData', currentFlag);
    flag2(flag2==currentFlag) = [];
end
hold off;


Aout.voxelSize = scale;  

fname = get(handles.currentFileName,'String');
[filepath, filename, fext] = fileparts(fname);
Aout.filename = [filename, fext];

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~exist(fullfile(filepath,'Analysis'),'file')
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = state.analysisNumber.value;

fname = fullfile(filepath,'Analysis',[filename,'_V3tracing_A',num2str(analysisNumber)]);
save(fname, 'Aout');

h_setDendriteTracingVis3(handles);
h_updateInfo3(handles);





