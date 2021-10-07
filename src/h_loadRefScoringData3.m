function h_loadRefScoringData3(handles)

global jbm;
global h_img3;

%+/- color code
LOST = [1 0.5 0.5];%red
GAINED = [0.5 1 0.5];%green
TRANSIENT = [1 1 0.5];%yellow
PRESENT = [0.5 0.5 1];% blue

[fname, pname] = uigetfile();
if fname~=0
    fullFileName = [pname fname];
    load(fullFileName,'-mat');
    
    siz = size(scoringData.synapseMatrix);
    numSyn = siz(1);
    numTP = siz(2);
    
    % for color purpose
    binaryPresence = logical(scoringData.synapseMatrix);
    differenceMatrix = diff(binaryPresence,1,2);
    additionMatrix = false(size(scoringData.synapseMatrix));
    eliminationMatrix = false(size(scoringData.synapseMatrix));
    additionMatrix(:, 2:end) = differenceMatrix == 1;
    eliminationMatrix(:, 1:end-1) = differenceMatrix == -1;
    transientMatrix = additionMatrix & eliminationMatrix;
    
    for jTP = 1:numTP % it is faster without keep changing axes.
        currentImgAxes = h_img3.(jbm.instancesOpen{jTP}).gh.currentHandles.imageAxes;
        
        refROIObj = findobj(currentImgAxes, 'Tag', 'refROI3');
        delete(refROIObj);
        refROITextObj = findobj(currentImgAxes, 'Tag', 'refROIText3');
        delete(refROITextObj);
        
        hold(currentImgAxes, 'on');
        axes(currentImgAxes);
        
        for iSyn = 1:numSyn            
            xCo = scoringData.roiCoordinates(1,jTP,iSyn);
            yCo = scoringData.roiCoordinates(2,jTP,iSyn);
            synID = scoringData.synapseID{iSyn};
            
            if transientMatrix(iSyn, jTP)
                color = TRANSIENT;
            elseif additionMatrix(iSyn, jTP)
                color = GAINED;
            elseif eliminationMatrix(iSyn, jTP)
                color = LOST;
            else
                color = PRESENT;
            end
            
            ROIsize = 5;
            
            roiHandle = plot(xCo,yCo,'*','MarkerSize',ROIsize, 'Tag', 'refROI3', 'Color', color);            
            texthandle = text(xCo,yCo,[' ', num2str(synID)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
                'Tag', 'refROIText3','FontWeight','Bold', 'Color', color);
        end
        hold(currentImgAxes, 'off');
    end            
end


