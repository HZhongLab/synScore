function h_openFile3(handles,fname)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

if exist(fname, 'file')
%     tic
    [pathname,filename,fExt] = fileparts(fname);
    if ~exist('pathname','var')
        pathname = pwd;
        fname = fullfile(pathname,fname);
    end
    cd (pathname);
    
    currentStruct.image.old = h_getOldImg3(handles);
    if isfield(currentStruct.image, 'zFilteredData')
        currentStruct.image = rmfield(currentStruct.image, 'zFilteredData');
    end
    [currentStruct.image.data,currentStruct.info, err] = h_openScanImageTif2(fname);
    if ~err
        currentStruct.info.fileType = 'scanimage';
    else
        [data,currentStruct.info, err] = h_genericOpenTif(fname);
        siz = size(data);
        if ~err && isfield(currentStruct.info, 'PhotometricInterpretation')
            switch lower(currentStruct.info.PhotometricInterpretation)
                case 'rgb'
                    if length(siz)<4
                        siz(4) = 1;
                    end
                    currentStruct.image.data.red = reshape(data(:,:,1,:),[siz(1),siz(2),siz(4)]);
                    currentStruct.image.data.green = reshape(data(:,:,2,:),[siz(1),siz(2),siz(4)]);
                    currentStruct.image.data.blue = reshape(data(:,:,3,:),[siz(1),siz(2),siz(4)]);
                    currentStruct.image.data.size = [siz(1),siz(2),siz(4)];
                    currentStruct.info.fileType = 'lsmTif';
                case lower('BlackIsZero')
                    if isfield(currentStruct.info,'ImageDescription') && ~isempty(strfind(currentStruct.info.ImageDescription, 'channels=2'));
                        currentStruct.image.data.red = data(:,:,2:2:end);
                        currentStruct.image.data.green = data(:,:,1:2:end);
                        currentStruct.image.data.blue = [];
                        siz(3) = siz(3)/2;
                        currentStruct.image.data.size = siz(1:3);
                        currentStruct.info.fileType = 'G/R_lsmTifConvertedInImageJ';
                    else
                        %                     currentStruct.image.data.red = data(:,:,2:2:end);
                        %                     currentStruct.image.data.green = data(:,:,1:2:end);
                        %                     currentStruct.image.data.blue = [];
                        %                     currentStruct.image.data.size = [siz(1:2),ceil(size(data,3)/2)];
                        %                     currentStruct.info.fileType = 'Robby';
                        currentStruct.image.data.red = [];
                        currentStruct.image.data.green = data(:,:,1:end);
                        currentStruct.image.data.blue = [];
                        if length(siz)<3
                            siz(3) = 1;
                        end
                        currentStruct.image.data.size = siz(1:3);
                        currentStruct.info.fileType = 'singleColorImageStack';
                    end
            end
        end
    end
    
    if isempty(currentStruct.image.data.red)
        currentStruct.image.data.red = uint8(zeros(currentStruct.image.data.size));
    end
    if isempty(currentStruct.image.data.green)
        currentStruct.image.data.green = uint8(zeros(currentStruct.image.data.size));
    end
    if isempty(currentStruct.image.data.blue)
        currentStruct.image.data.blue = uint8(zeros(currentStruct.image.data.size));
    end
%     toc
    h_img3.(currentStructName) = currentStruct;
    set(handles.currentFileName,'String',fname);
    [xlim,ylim,zlim] = h_getLimits3(handles);
    set(handles.zStackStrLow,'String', num2str(zlim(1)));
    set(handles.zStackStrHigh,'String', num2str(zlim(2)));
    set(handles.imageAxes,'XLim',xlim,'YLim',ylim);
    h_zStackQuality3(handles);
    h_cLimitQuality3(handles);
    h_replot3(handles);
    h_roiQuality3(handles);
    h_updateInfo3(handles);
else
    disp('Not a valid file name');
end
