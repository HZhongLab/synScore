function h_setROIProperties3(handles, flag)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

roi = findobj(handles.imageAxes, 'Tag', 'annotationROI3', 'Selected', 'on');

if length(roi)>1
    error('more than one ROI selected! this should not happen!');
elseif length(roi)==1
    UData = get(roi, 'UserData');
    switch flag
        case {'spine'}
            UData.synapseAnalysis.isSpine = get(handles.setSynapseSpine, 'value');
        case {'uncertain'}
            if get(handles.setSynapseUncertain, 'value')
                UData.synapseAnalysis.synapseConfidence = 'low';
            else
                UData.synapseAnalysis.synapseConfidence = 'high';
            end
        case {'new'}
            if get(handles.newSynapse, 'value')
                UData.synapseAnalysis.synapseStatus = 'new';
            else
                UData.synapseAnalysis.synapseStatus = '';
            end
        case {'last'}
            UData.synapseAnalysis.isLast = get(handles.setSynapseLast, 'value');

    end
    set(roi, 'UserData', UData);
end
h_annotationROIQuality3(handles);
h_selectCurrentAnnotationROI3(handles);
