function h_selectCurrentAnnotationROI3(handles, currentObj, isDeletion)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if ~exist('currentObj', 'var') || isempty(currentObj)
    currentObj = findobj(handles.imageAxes, 'Tag', 'annotationROI3', 'Selected', 'on');
end

if ~exist('isDeletion', 'var') || isempty(isDeletion)
    isDeletion = 0;
end

if ~isempty(currentObj)
    UserData = get(currentObj,'UserData');
    if isDeletion
        delete(currentObj);
        delete(UserData.texthandle);
        if isfield(handles, 'specialNotes')
            set(handles.specialNotes, 'string', 'special notes', 'backgroundColor', 'white');
            set(handles.setSynapseSpine, 'value', 0);
            set(handles.setSynapseSpine,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            set(handles.setSynapseUncertain, 'value', 0);
            set(handles.setSynapseUncertain,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            set(handles.newSynapse, 'value', 0);
            set(handles.newSynapse,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            set(handles.setSynapseLast, 'value', 0);
            set(handles.setSynapseLast,'BackgroundColor',[ 0.9255    0.9137    0.8471]);        
        end
    else
        %         set(currentObj,'Selected','on');
        if isfield(handles, 'specialNotes')
            set(handles.specialNotes, 'string', UserData.synapseAnalysis.note);
            if strcmpi(UserData.synapseAnalysis.note, 'special notes')
                set(handles.specialNotes, 'backgroundColor', 'white');
            else
                set(handles.specialNotes, 'backgroundColor', [0.5 1 0.5]);%note set background to light green if there is notes.
            end
            if UserData.synapseAnalysis.isSpine>0 %it can be -1...
                set(handles.setSynapseSpine, 'value', 1);
                set(handles.setSynapseSpine,'BackgroundColor',[0.8 0.8 0.8]);%there are some funny handling in the toggle button color. So directly set it.
            else
                set(handles.setSynapseSpine, 'value', 0);
                set(handles.setSynapseSpine,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            end
            if strcmp(UserData.synapseAnalysis.synapseConfidence, 'low')
                set(handles.setSynapseUncertain, 'value', 1);
                set(handles.setSynapseUncertain,'BackgroundColor',[0.8 0.8 0.8]);
            else
                set(handles.setSynapseUncertain, 'value', 0);
                set(handles.setSynapseUncertain,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            end
            if strcmp(UserData.synapseAnalysis.synapseStatus, 'new')
                set(handles.newSynapse, 'value', 1);
                set(handles.newSynapse,'BackgroundColor',[0.8 0.8 0.8]);
            else
                set(handles.newSynapse, 'value', 0);
                set(handles.newSynapse,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            end
            if UserData.synapseAnalysis.isLast>0%it can be -1...
                set(handles.setSynapseLast, 'value', 1);
                set(handles.setSynapseLast,'BackgroundColor',[0.8 0.8 0.8]);
            else
                set(handles.setSynapseLast, 'value', 0);
                set(handles.setSynapseLast,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
            end
            %         if strcmp(UserData.synapseAnalysis.synapseStatus, 'last')
            %             set(handles.setSynapseLast, 'value', 1);
            %         else
            %             set(handles.setSynapseLast, 'value', 0);
            %         end
            
        end
    end
else
    if isfield(handles, 'specialNotes')
        set(handles.specialNotes, 'string', 'special notes', 'backgroundColor', 'white');
        set(handles.setSynapseSpine, 'value', 0);
        set(handles.setSynapseSpine,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
        set(handles.setSynapseUncertain, 'value', 0);
        set(handles.setSynapseUncertain,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
        set(handles.newSynapse, 'value', 0);
        set(handles.newSynapse,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
        set(handles.setSynapseLast, 'value', 0);
        set(handles.setSynapseLast,'BackgroundColor',[ 0.9255    0.9137    0.8471]);    
    end
end

