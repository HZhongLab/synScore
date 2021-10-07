function [aout] = jbm_makeFluorROI3(handles,instance,xCo,yCo,zCo,synapseIndex,xr,yr)
global h_img3;
global jbm;

currentInstance = jbm.instancesOpen{instance};
currentAxes = h_img3.(currentInstance).gh.currentHandles.imageAxes;
currentFigure = h_img3.(currentInstance).gh.currentHandles.h_imstack3;
currentHandles = h_img3.(currentInstance).gh.currentHandles;
currentStructName = currentInstance;
figure(currentFigure);
axes(currentAxes);


hold on;

theta = (0:1/40:1)*2*pi;


xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xCo;
yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yCo;


UserData.roi.xi = xi;
UserData.roi.yi = yi;

UserData.roi.xr = xr;
UserData.roi.yr = yr;

UserData.roi.yc = yCo;
UserData.roi.xc = xCo;

UserData.synapseIndex = synapseIndex;

h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h, 'Tag', 'fluorROI3','Color','white','ButtonDownFcn', 'jbm_dragFluorRoi3');
set(h,'UserData',UserData);
h_roiQuality3(handles);
aout = h;
