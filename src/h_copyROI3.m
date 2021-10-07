function h_copyROI3(handles)

global h_img3;

roiobj = findobj(handles.imageAxes,'Tag','ROI3');
annotationROIObj = findobj(handles.imageAxes, 'tag', 'annotationROI3');
bgroiobj = findobj(handles.imageAxes,'Tag','BGROI3');

h = vertcat(roiobj, annotationROIObj, bgroiobj);

for i = 1:length(h)
    UData{i} = get(h(i),'UserData');
end

h_img3.common.copiedROI = UData;