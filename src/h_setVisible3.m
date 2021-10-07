function h_setVisible3(handles)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

threshOutlineObj = findobj(handles.imageAxes, 'Tag', 'threshOutline3');
autoDetectedSynapseObj = findobj(handles.imageAxes, 'Tag', 'autoDetectedSynapses3');

if currentStruct.state.showThreshOutlines.value
    set(vertcat(threshOutlineObj,autoDetectedSynapseObj), 'Visible', 'on');
else
    set(vertcat(threshOutlineObj,autoDetectedSynapseObj), 'Visible', 'off');
end
