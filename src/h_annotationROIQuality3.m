function h_annotationROIQuality3(handles)

ROIObj = findobj(handles.imageAxes, 'Tag', 'annotationROI3');

ROIUData = get(ROIObj, 'UserData');

if iscell(ROIUData)
    ROIUData = cell2mat(ROIUData);
end

for i = 1:length(ROIUData)
    [color, eraseMode, lineWidth] = h_getColor3(ROIUData(i).synapseAnalysis);
    set(ROIUData(i).ROIhandle, 'Color', color, 'EraseMode', eraseMode, 'LineWidth', lineWidth);
    set(ROIUData(i).texthandle, 'Color', color, 'EraseMode', eraseMode);
    if strcmpi(get(ROIUData(i).ROIhandle,'Selected'),'on')
        set(ROIUData(i).ROIhandle, 'LineWidth', 3);
    end
end