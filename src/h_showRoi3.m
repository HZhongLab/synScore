function h_showRoi3(handles)

roiobj = findobj(handles.h_imstack3,'Tag','ROI3');
annotationROIObj = findobj(handles.h_imstack3, 'tag', 'annotationROI3');
bgroiobj = findobj(handles.h_imstack3,'Tag','BGROI3');

set(vertcat(roiobj, annotationROIObj, bgroiobj), 'Visible','off');
set(vertcat(roiobj, annotationROIObj, bgroiobj), 'Visible','on');

