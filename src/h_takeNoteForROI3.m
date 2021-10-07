function h_takeNoteForROI3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

roi = findobj(handles.imageAxes, 'Tag', 'annotationROI3', 'Selected', 'on');

if length(roi)>1
    error('more than one ROI selected! this should not happen!');
elseif length(roi)==1 %roi can also be empty
    UData = get(roi, 'UserData');
    UData.synapseAnalysis.note = get(handles.specialNotes, 'string');
    set(roi, 'UserData', UData);
    if strcmpi(UData.synapseAnalysis.note, 'special notes')
        set(handles.specialNotes, 'backgroundColor', 'white');
    else
        set(handles.specialNotes, 'backgroundColor', [0.5 1 0.5]);%note set background to light green if there is notes.
    end
end

