function h_fileTypeQuality3(handles)

global h_img3

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);


    currentValue = currentStruct.state.fileTypeForSynAnalysis.value;


switch currentValue
    case {2, 3}% if other instances have the same value, then set them to 1
        if currentValue == 2
            try % this field may not be available.
                set(handles.fileTypeForSynAnalysis, 'BackgroundColor', 'magenta');
                set(handles.assignSameSpines, 'Enable', 'on');
                set(handles.assignMovedSpine, 'Enable', 'on');
                set(handles.unAssignSpine, 'Enable', 'on');
                set(handles.finalizeSpineAssignment, 'Enable', 'on');
                set(handles.retrieveData, 'Enable', 'on');
            end
        else
            try
                set(handles.fileTypeForSynAnalysis, 'BackgroundColor', 'green');
                set(handles.assignSameSpines, 'Enable', 'off');
                set(handles.assignMovedSpine, 'Enable', 'off');
                set(handles.unAssignSpine, 'Enable', 'off');
                set(handles.finalizeSpineAssignment, 'Enable', 'off');
                set(handles.retrieveData, 'Enable', 'off');
            end
        end
        structNames = fieldnames(h_img3);
        for i = 1:length(structNames)
            if ~strcmpi(structNames{i}, currentStructName) && ~strcmpi(structNames{i}, 'common')%only set other instances
                value = h_img3.(structNames{i}).state.fileTypeForSynAnalysis.value;
                if value==currentValue
                    h_img3.(structNames{i}).state.fileTypeForSynAnalysis.value = 1;
                    h_setParaAccordingToState3(h_img3.(structNames{i}).gh.currentHandles);
                    h_fileTypeQuality3(h_img3.(structNames{i}).gh.currentHandles);
                end
            end
        end
    otherwise
        try
            set(handles.fileTypeForSynAnalysis, 'BackgroundColor', 'white');
            set(handles.assignSameSpines, 'Enable', 'off');
            set(handles.assignMovedSpine, 'Enable', 'off');
            set(handles.unAssignSpine, 'Enable', 'off');
            set(handles.finalizeSpineAssignment, 'Enable', 'off');
            set(handles.retrieveData, 'Enable', 'off');
        end
end