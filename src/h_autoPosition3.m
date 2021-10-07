function h_autoPosition3(handles)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

h_copyROI3(handles);

reference = h_img3.(currentStructName).image.old(:,:,1);
currentimg = get(findobj(handles.imageAxes,'Type','image'),'CData');
newimg = currentimg(:,:,1);
% if ~isempty(reference)
%     offset = h_corr(reference,newimg);  
%     roiobj = [sort(findobj(handles.imageAxes,'Tag', 'ROI3'));findobj(handles.imageAxes,'Tag','BGROI3');...
%         findobj(handles.imageAxes,'Tag','annotationROI3')];
%     h_moveRoi3(roiobj,[offset(2),offset(1)]);
%     h_roiQuality3(handles);
% end

%%%%% below is modified from h_twoStepAutoPosition2

if ~isempty(reference)
    offset = h_corr(reference,newimg);    
    roiobj = [sort(findobj(handles.imageAxes,'Tag', 'ROI3')); findobj(handles.imageAxes,'Tag','annotationROI3')];%handle ROI and BGROI seperately.
    n_roi = length(roiobj);
    totalOffset = zeros(n_roi, 2);
    for i = 1:n_roi
        UserData = get(roiobj(i),'UserData');
        pos = [min(UserData.roi.xi),min(UserData.roi.yi),max(UserData.roi.xi)-min(UserData.roi.xi),max(UserData.roi.yi)-min(UserData.roi.yi)];
        
        localRefx1 = round(max(pos(1)-2*pos(3),1));
        localRefx2 = round(min(pos(1)+ 3 * pos(3),size(reference,2)));
        localRefy1 = round(max(pos(2)-2*pos(4),1));
        localRefy2 = round(min(pos(2)+ 3 * pos(4),size(reference,1)));
        
%         pos(1) = pos(1) + offset(2);
%         pos(2) = pos(2) + offset(1);
        localImgx1 = localRefx1 + offset(2);
        localImgx2 = localRefx2 + offset(2);
        localImgy1 = localRefy1 + offset(1);
        localImgy2 = localRefy2 + offset(1);
        
        % Correct the local frame that could be out of image
        dx = min([localRefx1,localImgx1,0.5]) - 0.5;
        localRefx1 = round(localRefx1 - dx);
        localRefx2 = round(localRefx2 - dx);
        localImgx1 = round(localImgx1 - dx);
        localImgx2 = round(localImgx2 - dx);

        dy = min([localRefy1,localImgy1,0.5]) - 0.5;
        localRefy1 = round(localRefy1 - dy);
        localRefy2 = round(localRefy2 - dy);
        localImgy1 = round(localImgy1 - dy);
        localImgy2 = round(localImgy2 - dy);
        
        localRef = reference(localRefy1:localRefy2,localRefx1:localRefx2);
        localImg = newimg(localImgy1:localImgy2,localImgx1:localImgx2);
        local_offset = h_corr(localRef,localImg);
        
        totalOffset(i,1) = offset(1)+local_offset(1);
        totalOffset(i,2) = offset(2)+local_offset(2);
        
        
         h_moveRoi3(roiobj(i),[totalOffset(i,2),totalOffset(i,1)]);
% 
% %         pos(1) = pos(1) + local_offset(2);
% %         pos(2) = pos(2) + local_offset(1);
%         UserData.roi.xi = UserData.roi.xi + offset(2) + local_offset(2);
%         UserData.roi.yi = UserData.roi.yi + offset(1) + local_offset(1);
%         set(roiobj(i),'UserData',UserData,'XData',UserData.roi.xi,'YData',UserData.roi.yi);
%         x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
%         y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
%         set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
    end
    bgroiobj = findobj(handles.imageAxes,'Tag', 'BGROI3');
    if ~isempty(bgroiobj)
            h_moveRoi3(bgroiobj,[mean(totalOffset(:,2)),mean(totalOffset(:,1))]);

%         pos = get(bgroiobj,'Position');
%         pos(1) = pos(1) + offset(2);
%         pos(2) = pos(2) + offset(1);
%         UserData = get(roiobj(i),'UserData');
%         UserData.roi.xi = UserData.roi.xi + offset(2);
%         UserData.roi.yi = UserData.roi.yi + offset(1);
%         set(bgroiobj,'UserData',UserData);
%         x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
%         y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
%         set(UserData.texthandle,'Position',[x,y],'UserData',UserData);
    end
    h_roiQuality3(handles);
end



% function h_saveCurrentRoiPos3(handles)
% 
% roiobj = sort(findobj(handles.imageAxes,'Tag', 'ROI3'));
% bgroiobj = sort(findobj(handles.imageAxes,'Tag', 'BGROI3'));
% UserData = get([roiobj;bgroiobj],'UserData');
% if iscell(UserData)
%     UserData = cell2mat(UserData);
% end
% roi = UserData;
% 
% h_img2.internal.savedRoiPos = roi;


function h_moveRoi3(h, offset)

% offset here is (x, y)

UserData = get(h,'UserData');
if iscell(UserData)
    UserData = cell2mat(UserData);
end

for i = 1:length(h)
    UserData(i).roi.xi = UserData(i).roi.xi + offset(1);
    UserData(i).roi.yi = UserData(i).roi.yi + offset(2);
    x = (max(UserData(i).roi.xi) + min(UserData(i).roi.xi))/2;
    y = (max(UserData(i).roi.yi) + min(UserData(i).roi.yi))/2;
    set(UserData(i).ROIhandle,'XData',UserData(i).roi.xi,'YData',UserData(i).roi.yi,'UserData',UserData(i));
    set(UserData(i).texthandle, 'Position', [x,y],'UserData',UserData(i));
end
