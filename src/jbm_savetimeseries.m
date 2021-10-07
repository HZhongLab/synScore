function jbm_savetimeseries
global jbm;
global h_img3;

startingDirectory = pwd;

s_path = uigetdir();
cd(s_path);

fnBase = inputdlg('Filename Base: ');


fnew = figure('position',[600 600 1200 600]);


for i = 1:length(jbm.instancesOpen)
    handles = h_img3.(jbm.instancesOpen{i}).gh.currentHandles;
    axiscopy = copyobj(handles.imageAxes,fnew);
    subplot(2,4,i,axiscopy);
%     set(axiscopy,'unit','normalized','position',[0,0,1,1]);
    
    set(fnew,'PaperPositionMode','auto');
    map = get(handles.h_imstack3, 'colormap');
    colormap(map);
    
    h = figure('position',[100,100,600,600]);
    c = copyobj(handles.imageAxes,h);
    set(c,'unit','normalized','position',[0,0,1,1]);
    map = get(handles.h_imstack3,'colormap');
    imgfn = [fnBase{1} '_' jbm.instancesOpen{i}];
    saveas(h,imgfn,'png');
    close(h);
end

fn = strcat(fnBase{1},'_FULL.png');

saveas(fnew,strcat('FULL_',fnBase{1}),'png');


close(fnew);
