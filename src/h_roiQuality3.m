function h_roiQuality3(handles)

% [currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

roiobj = [findobj(handles.h_imstack3,'Tag','ROI3');findobj(handles.h_imstack3,'Tag','BGROI3');...
    findobj(handles.h_imstack3,'Tag','annotationROI3');findobj(handles.h_imstack3,'Tag','fbgROI3');...
    findobj(handles.h_imstack3,'Tag','fluorROI3')];

for i = 1:length(roiobj)
    parentobj = get(roiobj(i),'Parent');
    if strcmp(get(parentobj,'Type'),'axes')
        imgobj = findobj(parentobj,'Type','image');
        img = get(imgobj,'CData');
        siz = size(img);
        UserData = get(roiobj(i),'UserData');
        RoiRect = [min(UserData.roi.xi),min(UserData.roi.yi),...
                max(UserData.roi.xi)-min(UserData.roi.xi),max(UserData.roi.yi)-min(UserData.roi.yi)];
        pos = RoiRect;
        if pos(1)+pos(3)>siz(2)+0.5
            pos(1) = siz(2)+0.5-pos(3);
        end
        if pos(1)<0.5
            pos(1) = 0.5;
        end
        if pos(2)+pos(4)>siz(1)+0.5
            pos(2) = siz(1)+0.5-pos(4);
        end
        if pos(2) < 0.5
            pos(2) = 0.5;
        end
        UserData.roi.xi = UserData.roi.xi - RoiRect(1) + pos(1);
        UserData.roi.yi = UserData.roi.yi - RoiRect(2) + pos(2);
        set(roiobj(i),'XData',UserData.roi.xi,'YData',UserData.roi.yi,'UserData',UserData);
        try
        set(UserData.texthandle, 'Position', [pos(1)+pos(3)/2,pos(2)+pos(4)/2],'UserData',UserData);
        catch
        end
    end
end
