function h_loadProteinGelImg3(handles)

global h_img3;  

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

channelToLoadForGelOpt = get(handles.channelToLoadForGel,'value');

[fname,pname] = uigetfile('*.tif','Select an imaging file to open');

fname = fullfile(pname,fname); %such a weird way because try to combine a couple of previous programs.


if exist(fname, 'file') == 2
    [pathname,filename,fExt] = fileparts(fname);
    if isempty(pathname)
        pathname = pwd;
        fname = fullfile(pathname,fname);
    end
    cd (pathname);

    if isfield(h_img3.(currentStructName).image, 'zFilteredData')
        h_img3.(currentStructName).image = rmfield(h_img3.(currentStructName).image, 'zFilteredData');
    end

    [data,h_img3.(currentStructName).info, err] = h_genericOpenTif(fname, 1);
    siz = size(data);

    if ~err
        switch channelToLoadForGelOpt
            case 1
                if isfield(currentStruct.image, 'data') % there have been image data before.
                    h_img3.(currentStructName).image.data.red = data;
                    siz1 = size(h_img3.(currentStructName).image.data.green);
                    if length(siz)~=length(siz1) || any(siz1~=siz)
                        h_img3.(currentStructName).image.data.green = [];
                        h_img3.(currentStructName).image.data.blue = [];
                    end
                else
                    h_img3.(currentStructName).image.data.red = data;
                    h_img3.(currentStructName).image.data.green = [];
                    h_img3.(currentStructName).image.data.blue = [];
                end
                if length(siz)<3
                    siz(3) = 1;
                end
                h_img3.(currentStructName).image.data.size = siz;
                h_img3.(currentStructName).info.fileType = 'singleColorImageStack';
            case 2
                if isfield(currentStruct.image, 'data') % there have been image data before.
                    h_img3.(currentStructName).image.data.green = data;
                    siz1 = size(h_img3.(currentStructName).image.data.red);
                    if length(siz)~=length(siz1) || any(siz1~=siz)
                        h_img3.(currentStructName).image.data.red = [];
                        h_img3.(currentStructName).image.data.blue = [];
                    end
                else
                    h_img3.(currentStructName).image.data.red = [];
                    h_img3.(currentStructName).image.data.green = data;
                    h_img3.(currentStructName).image.data.blue = [];
                end
                if length(siz)<3
                    siz(3) = 1;
                end
                h_img3.(currentStructName).image.data.size = siz;
                h_img3.(currentStructName).info.fileType = 'singleColorImageStack';
        end
    end


    if isempty(h_img3.(currentStructName).image.data.red)
        h_img3.(currentStructName).image.data.red = uint8(zeros(h_img3.(currentStructName).image.data.size));
    end
    if isempty(h_img3.(currentStructName).image.data.green)
        h_img3.(currentStructName).image.data.green = uint8(zeros(h_img3.(currentStructName).image.data.size));
    end
    if isempty(h_img3.(currentStructName).image.data.blue)
        h_img3.(currentStructName).image.data.blue = uint8(zeros(h_img3.(currentStructName).image.data.size));
    end
    
    h_img3.(currentStructName).image.data = rmfield(h_img3.(currentStructName).image.data, {'maxIntensity', 'sliderSteps'});

    set(handles.currentFileName,'String',fname);
    [xlim,ylim,zlim] = h_getLimits3(handles);
    set(handles.zStackStrLow,'String', num2str(zlim(1)));
    set(handles.zStackStrHigh,'String', num2str(zlim(2)));
    set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
    h_zStackQuality3(handles);
    h_replot3(handles);
    h_roiQuality3(handles);
    h_updateInfo3(handles);
else
    disp('Not a valid file name');
end
