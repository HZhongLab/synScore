function jbm_savetimeseries(varargin)
global jbm;
global h_img3;
startingDirectory = pwd;
sz = size(varargin);
numInputs = sz(2);

s_path = uigetdir();
fnBase = inputdlg('Filename Base: ');

cd(s_path);


if isfield(jbm,'instancesOpen')
    for i = 1:length(jbm.instancesOpen)
        
        handles = h_img3.(jbm.instancesOpen{i}).gh.currentHandles;
        h = figure('position',[100 100 600 600]);
        
        c = copyobj(handles.imageAxes,h);
        set(c,'unit','normalized','position',[0 0 1 1])
      
        set(h,'PaperPositionMode','auto');
        
        map = get(handles.h_imstack3, 'colormap');
        colormap(map);
        print('-dbitmap','-noui',h);
        
        imgFn = [fnBase{1} '_' jbm.instancesOpen{i}];
        
        print(h,imgFn,'-dpng','-noui');
        close(h)
        
    end 
    
else
    disp('Please make a .syn file')
    return
end

end