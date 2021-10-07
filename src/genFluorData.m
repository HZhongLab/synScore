function genFluorData(handles)
% Start with h_imstack3 open with 8 instances
global h_img3
global jbm

impath = '/Users/Josh/Dropbox/hzlab/esoin_project/data/hq_dendrites_8_TP_only/pv/vip_control/'
synpath = '/Users/Josh/Dropbox/hzlab/esoin_project/analysis/Syn Files/2.3/jbm/first_pass/vip_control/';
syndir = dir(synpath);
synfiles = {syndir(3:end).name};

savepath = fullfile('/Users/Josh/Desktop/FluorData/vipControl/')
num_analyses = length(synfiles);


for i = 1:num_analyses
    try
    jbm_synapsescoringengine('create new dataset',handles)
    dendrite_name = synfiles{i};
    dendrite_name = dendrite_name(1:8);
    p = fullfile([impath dendrite_name(4:5) '/' dendrite_name(4:end) '/' dendrite_name(4:end) '.grp'])
    h_openGroup3(handles,p)
    
    
    
    [currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);
    
    if currentStruct.state.syncGrp.value;
        structNames = fieldnames(h_img3);
        ind  = false(length(structNames), 1);%ind is thd index for instances participate in sync-Grp.
        for i = 1:length(structNames)
            if ~strcmpi(structNames{i}, 'common')
                ind(i) = h_img3.(structNames{i}).state.syncGrp.value;
            end
        end
        
        instanceNames = sort(structNames(ind));
        
        n_toBeOpen = min(length(currentStruct.activeGroup.groupFiles), length(instanceNames));
        
        choice = 'Yes'
        switch choice
            case 'Yes'
                for i = 1:length(instanceNames)
                    h_img3.(instanceNames{i}).activeGroup = currentStruct.activeGroup;
                    
                    handles1 = h_img3.(instanceNames{i}).gh.currentHandles;
                    
                    fname = fullfile(currentStruct.activeGroup.groupPath,currentStruct.activeGroup.groupFiles(i).relativePath,...
                        currentStruct.activeGroup.groupFiles(i).fname);
                    if exist(fname, 'file')
                        fileInfo = h_dir(fname);
                        h_openFile3(handles1, fileInfo.name);
                    else
                        h_openFile3(handles1, currentStruct.activeGroup.groupFiles(i).name);
                    end
                end
            case 'No'
                return;
            otherwise
        end
    else
        warndlg('Please turn on sync-Grp to use this function.');
        
    end
    
    
    %% Load .syn File
    
    fn = fullfile([synpath dendrite_name '.syn' '.mat'])
    global genFluor
    genFluor.synPath = fn
    jbm_synapsescoringengine('load fn',handles)
    
%% Run fluor
jbm_synapsescoringengine('autofluor',handles)
%% Save syn file

numInst = length(jbm.instancesOpen);

save([savepath dendrite_name '_fluor.mat'],'jbm');
end
end
end
function roiHandle = drawscoringroi(ax,xCoordinate,yCoordinate,synapseNumber,roiColor,varargin)
% global h_img3; %Haining.
% global jbm;

ROIsize = 10;

if ax~=gca % only run axes as needed.
    axes(ax);%HN note: axes is a very slow function...
else
end
obj = get(ax,'Children');
set(obj,'Selected','off');
% theta = (0:1/40:1)*2*pi;
% xc = xCoordinate;
% yc = yCoordinate;
% xr = ROIsize;
% yr = ROIsize;
% UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
% UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
hold on;
% mark_size = 9;
roiHandle = plot(xCoordinate,yCoordinate,'.','MarkerSize',ROIsize, 'Tag', 'scoringROI3',...
    'Color',roiColor, 'EraseMode','normal', 'ButtonDownFcn', 'jbm_dragROI3');
hold off;

UserData.texthandle = text(xCoordinate,yCoordinate,[' ', num2str(synapseNumber)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
    'Tag', 'scoringROI3text', 'Color',roiColor,'FontWeight','Bold', 'EraseMode', 'normal', 'ButtonDownFcn', 'jbm_dragText3');




% roiHandle = plot(UserData.roi.xi,UserData.roi.yi,'k-');
% % roiHandle = plot(ax, UserData.roi.xi,UserData.roi.yi,'k-');%HN note: this
% % is faster but this won't work since text can only write to gca.
%
% set(roiHandle,'ButtonDownFcn', 'jbm_dragROI3', 'Tag', 'scoringROI3', 'EraseMode','xor','linewidth',2);
%
% set(roiHandle,'Color',roiColor);
%
% UserData.texthandle = text(xCoordinate,yCoordinate,synapseNumber,'Tag','scoringROI3text','FontSize',13,'FontWeight','bold','HorizontalAlignment',...
%    'Center','VerticalAlignment','Middle', 'Color',roiColor, 'EraseMode','xor', 'ButtonDownFcn', 'jbm_dragText3');

UserData.synapseID = synapseNumber;
UserData.roiHandle = roiHandle;
UserData.timeLastClick = clock;
UserData.xCo = xCoordinate;
UserData.yCo = yCoordinate;
UserData.roiSize = ROIsize;
UserData.roiExist = 1;

set(UserData.texthandle,'UserData',UserData);
set(roiHandle,'UserData',UserData);
end