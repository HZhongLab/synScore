function Aout = h_loadDendriteTracingData3(handles, flag)


[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);
analysisNumber = currentStruct.state.analysisNumber.value;

cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'yellow'};

switch flag
    case 'v3'
        dataFilename = fullfile(pname,'Analysis',[fname,'_V3tracing_A',num2str(analysisNumber),'.mat']);
    case 'v2'
        dataFilename = fullfile(pname,'Analysis',[fname,'_tracing',num2str(analysisNumber),'.mat']);
    otherwise
end

if ~exist(dataFilename, 'file')
    return;
end

load(dataFilename);

%delete all (temp)
tracingMarkObj = findobj(handles.imageAxes,'tag','h_tracingMark3');
tracingMarkTextObj = findobj(handles.imageAxes,'tag','h_tracingMarkText3');
skeletonObj = findobj(handles.imageAxes,'tag','h_dendriteSkeleton3');

delete(tracingMarkObj);
delete(tracingMarkTextObj);
delete(skeletonObj);

axes(handles.imageAxes);

mark_size = 9;
if isfield(Aout,'tracingMarks') && ~isempty(Aout.tracingMarks)
    for i = 1:length(Aout.tracingMarks)
        UData = Aout.tracingMarks(i);
        point1 = UData.pos;
        hold on;
        h = plot(point1(1),point1(2),'.','MarkerSize',mark_size, 'Tag', 'h_tracingMark3',...
            'Color',cstr{mod(UData.flag-1,6)+1},'ButtonDownFcn', 'h_dragTracingMark3', 'EraseMode','normal');
        hold off;
        
        x = point1(1);% + h_img.header.acq.pixelsPerLine/64;
        y = point1(2);% + h_img.header.acq.pixelsPerLine/64;
        h2 = text(x,y,[' ', num2str(UData.flag), '.', num2str(UData.number)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
            'Tag', 'h_tracingMarkText3', 'Color',cstr{mod(UData.flag-1,6)+1}, 'EraseMode','normal', 'ButtonDownFcn', 'h_dragTracingMarkText3');
        
        UData.markHandle = h;
        UData.textHandle = h2;
        UData.timeLastClick = clock;
        
        set(h,'UserData',UData);
        set(UData.textHandle,'UserData',UData);
    end
end

if strcmpi(flag, 'v3') %only load tracing data if it is 'v3' because the handling is different.
    %write in this way so that in the future it will become an independent
    %functional module.
    axes(handles.imageAxes);
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
%     currentStruct.lastAnalysis.tracingData = Aout;
end

h_setDendriteTracingVis3(handles);
