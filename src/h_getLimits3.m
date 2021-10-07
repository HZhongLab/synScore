function [xlim,ylim,zlim] = h_getLimits3(handles)

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

siz = currentStruct.image.data.size;

dispAxes = get(handles.viewingAxisControl,'Value');
switch dispAxes
    case {1}
        viewingAxis = 3;
    case {2}
        viewingAxis = 1;
    case {3}
        viewingAxis = 2;
end

zlim = [1, siz(viewingAxis)];

axesRatioStr = get(handles.ratioBetweenAxes,'String');
axesRatioStr(strfind(axesRatioStr,':')) = '/';
axesRatio = eval(axesRatioStr);
dispAxes2 = [3,1,2];
dispAxes2(dispAxes2==viewingAxis) = [];
if round(siz(dispAxes2(2))*axesRatio)>=siz(dispAxes2(1))
    xlim = [0,siz(dispAxes2(2))] + 0.5;
    ysiz = round(diff(xlim)*axesRatio);
    ylim = [0,ysiz] + 0.5 - round((ysiz-siz(dispAxes2(1)))/2);
else
    ylim = [0,siz(dispAxes2(1))] + 0.5;
    xsiz = round(diff(ylim)/axesRatio);
    xlim = [0,xsiz] + 0.5 - round((xsiz-siz(dispAxes2(2)))/2);
end
