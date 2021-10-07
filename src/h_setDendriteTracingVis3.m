function h_setDendriteTracingVis3(handles)


[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

state = currentStruct.state;

tracingMarkObj = findobj(handles.imageAxes,'Tag','h_tracingMark3');
tracingMarkTextObj = findobj(handles.imageAxes,'Tag','h_tracingMarkText3');
skeletonObj = findobj(handles.imageAxes,'Tag','h_dendriteSkeleton3');
profileOutlineObj = findobj(handles.imageAxes,'Tag','h_lineProfileOutline3');
scoringROIObj = findobj(handles.imageAxes, 'Tag', 'scoringROI3');

roiobj = findobj(handles.h_imstack3,'Tag','ROI3');
annotationROIObj = findobj(handles.h_imstack3, 'tag', 'annotationROI3');
bgroiobj = findobj(handles.h_imstack3,'Tag','BGROI3');

imgObj = findobj(handles.imageAxes, 'type', 'image');

refROIObj = findobj(handles.imageAxes, 'Tag', 'refROI3');
refROITextObj = findobj(handles.imageAxes, 'Tag', 'refROIText3');

scoringROIObj = findobj(handles.imageAxes, 'Tag', 'scoringROI3');
scoringROITextObj = findobj(handles.imageAxes, 'Tag', 'scoringROI3text');


try % there can be error if the values in state are not yet set.
    if state.showTracingMark.value
        set(tracingMarkObj, 'visible', 'on');
        if state.showMarkNumber.value
            set(tracingMarkTextObj, 'visible', 'on');
        else
            set(tracingMarkTextObj, 'visible', 'off');
        end
    else
        set(tracingMarkObj, 'visible', 'off');
        set(tracingMarkTextObj, 'visible', 'off');
    end
catch
end

try
    if state.showSkeleton.value
        set(skeletonObj, 'visible', 'on');
    else
        set(skeletonObj, 'visible', 'off');
    end
catch
end

try
    if state.showProfileOutLine.value
        set(profileOutlineObj, 'visible', 'on');
    else
        set(profileOutlineObj, 'visible', 'off');
    end
catch
end

try
    if state.showingImgOpt.value
        set(imgObj, 'visible', 'on');
    else
        set(imgObj, 'visible', 'off');
    end
catch
end

try
    if ~state.hideROI.value %if not hiding ROI, i.e. showing ROI
        set(roiobj, 'visible', 'on');
        UData = get(roiobj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'on');
        end
        set(bgroiobj, 'visible', 'on');
        UData = get(bgroiobj,'UserData');
        if ~isempty(UData)
            textHandles = UData.texthandle;
            set(textHandles, 'visible', 'on');
        end
        set(annotationROIObj, 'visible', 'on');
        UData = get(annotationROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'on');
        end
        set(scoringROIObj, 'visible', 'on');
        UData = get(scoringROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'on');
        end
    else
        set(roiobj, 'visible', 'off');
        UData = get(roiobj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'off');
        end
        
        set(bgroiobj, 'visible', 'off');
        UData = get(bgroiobj,'UserData');
        if ~isempty(UData)
            textHandles = UData.texthandle;
            set(textHandles, 'visible', 'off');
        end
        
        set(annotationROIObj, 'visible', 'off');
        UData = get(annotationROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'off');
        end
        
        set(scoringROIObj, 'visible', 'off');
        UData = get(scoringROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'off');
        end
    end
catch
end

try
    if state.hideScoringDataset.value
        set(scoringROIObj, 'visible', 'off');
        set(scoringROITextObj, 'visible', 'off');
    else
        set(scoringROIObj, 'visible', 'on');
        set(scoringROITextObj, 'visible', 'on');
    end
catch
end

try
    if state.hideRefDataset.value
        set(refROIObj, 'visible', 'off');
        set(refROITextObj, 'visible', 'off');
    else
        set(refROIObj, 'visible', 'on');
        set(refROITextObj, 'visible', 'on');
    end
catch
end

