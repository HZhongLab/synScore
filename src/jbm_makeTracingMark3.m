function h_makeTracingMark3 (handles, mark_size)

% to make a white cross mark on h_imstack image and find the x, y, z
% position of the central point. These marks will be used in
% h_traceDendriteSkeleton.m.

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

state = h_img3.(currentStructName).state;
data = h_img3.(currentStructName).image.data;

if ~exist('mark_size', 'var')||isempty(mark_size)
    mark_size = 9; %size of the cross
end

%  UData.flag = get(handles.markFlag,'value'); %JBM 032416
 UData.flag = 1;

cstr = {'blue', 'red', 'green', 'magenta', 'cyan', 'yellow'};

t0 = clock;
point0 = [-1000, -1000]; %the previous position
keepLooping = 1; %make it bigger than 0.5s;
numPoints = 0; %counter for the number of points in this run.
imageAxesOriginalHitTest = get(handles.imageAxes, 'HitTest');
set(handles.imageAxes, 'HitTest', 'off');
childrenOfImageAxes = get(handles.imageAxes, 'Children');
childrenOfImageAxesOriginalHitTest = get(childrenOfImageAxes, 'HitTest');
set(childrenOfImageAxes, 'HitTest', 'off');

try %Use Try to make sure that the HitTest properties are reset even if there is an error.
    axes(handles.imageAxes);
    siz = data.size;

    while keepLooping % add after the program is in place. The current way may not be most efficient
        waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        point1 = point1(1,1:2);              % extract x and y

        t1 = clock;
%         disp(etime(t1, t0))

        if etime(t1, t0) > 0.3 && h_calcDistance(point0, point1) > 0.5
%             disp(h_calcDistance(point0, point1))
            t0 = t1;
            point0 = point1;

            %To find the brightest Z within 3 pixels.
            [Y, X] = ndgrid(1:siz(1), 1:siz(2));
            BW = ((Y - point1(2)).^2 + (X - point1(1)).^2) <= 3^2;%note: x correspond to dimension 2

            zLim(1) = str2num(get(handles.zStackStrLow,'String'));
            zLim(2) = str2num(get(handles.zStackStrHigh,'String'));

            intensity = zeros(1,siz(3));
            switch state.channelForZ.value
                case 1
                    img_data = data.red;
                case 2
                    img_data = data.green;
                case 3
                    img_data = data.blue;
                otherwise
                    error('channel for Z error!');
            end

            for j = 1:siz(3)
                imr = img_data(:,:,j);
                intensity(j) = mean(imr(BW));
            end

            intensity2 = intensity(zLim(1):zLim(2));
            zi = find(intensity2==max(intensity2));
            zi = zi(1) + zLim(1) - 1;

            zRange = zi-2:zi+2;
            zRange = zRange(zRange >= zLim(1));
            zRange = zRange(zRange <= zLim(2));
            
            imga = double(img_data(:,:,zRange));
            imga = imga.*repmat(BW, [1 1 length(zRange)]);
            [x, y, zPos] = h_calculateCenterOfMass(imga);
            zPos = zPos + zRange(1) - 1;
            UData.pos = [point1, zPos];

            % disp(UData.pos);

            %find out the previous ROI info
            tracingMarkObj = findobj(handles.imageAxes,'Tag','h_tracingMark3');
            previousUData = get(tracingMarkObj,'UserData');
            if iscell(previousUData)
                previousUData = cell2mat(previousUData);
            end

            if ~isempty(previousUData)
                previousFlag = [previousUData.flag];
                previousUData = previousUData(previousFlag==UData.flag); %only count those with the same flag
            end

            %plot
            hold on;
            h = plot(point1(1),point1(2),'.','MarkerSize',mark_size, 'Tag', 'h_tracingMark3',...
                'Color','yellow', 'EraseMode','normal', 'HitTest', 'off');
            hold off;

            i = length(previousUData)+1;
            x = point1(1);% + h_img.header.acq.pixelsPerLine/64;
            y = point1(2);% + h_img.header.acq.pixelsPerLine/64;
            h2 = text(x,y,[' ', num2str(UData.flag), '.', num2str(i)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
                'Tag', 'h_tracingMarkText3', 'Color','yellow', 'EraseMode', 'normal',  'HitTest', 'off');

            UData.number = i;
            UData.markHandle = h;
            UData.textHandle = h2;
            UData.timeLastClick = clock;
            UData.timeLastClick(end) = UData.timeLastClick(end)-1;%to make sure that the new mark would not get deleted when double click to quit the loop

            numPoints = numPoints + 1;
            markHandles(numPoints) = h;
            markTextHandles(numPoints) = h2;

            set(h,'UserData',UData);
            set(UData.textHandle,'UserData',UData);

            h_setDendriteTracingVis3(handles);
        else
            keepLooping = 0;
        end
    end
catch
end %Use Try to make sure that the HitTest properties are reset even if there is an error.

if exist('markHandles', 'var') && ~isempty(markHandles)% sometimes due to error, it can be empty.
    set(markHandles, 'ButtonDownFcn', 'h_dragTracingMark3', 'HitTest', 'on');
    set(markTextHandles, 'ButtonDownFcn', 'h_dragTracingMarkText3', 'HitTest', 'on');
end

set(handles.imageAxes, 'HitTest', imageAxesOriginalHitTest);
if ~isempty(childrenOfImageAxes)
    if iscell(childrenOfImageAxesOriginalHitTest)
        for i = 1:length(childrenOfImageAxes)
            set(childrenOfImageAxes(i), 'HitTest', childrenOfImageAxesOriginalHitTest{i});
        end
    else
        set(childrenOfImageAxes, 'HitTest', childrenOfImageAxesOriginalHitTest);
    end
end
