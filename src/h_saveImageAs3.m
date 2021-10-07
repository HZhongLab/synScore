function h_saveImageAs3(handles)

global h_img3;

[currentInd, handles, currentStruct, currentStructName] = h_getCurrendInd3(handles);

[fname, pname, filterindex] = uiputfile({'*.tif', 'Scanimage Tiff, only for scanimage files';...
    '*.tif', 'RGB Tiff (not working yet'; '*.tif', 'Single Color Tiff (not working yet)';}, 'Save as');

if fname==0
    return;
end

[p,f,fExt] = fileparts(fname);
if isempty(fExt)
    fname = [fname,'.tif'];
end
filename = fullfile(pname,fname);
zLim(1) = str2num(get(handles.zStackStrLow,'Str'));
zLim(2) = str2num(get(handles.zStackStrHigh,'Str'));

xLim = get(handles.imageAxes, 'XLim');
xLim(1) = ceil(xLim(1));%e.g., xLim = [0.5 512.5], the wanted pixels are 1:512
xLim(2) = floor(xLim(2));
xSiz = diff(xLim) + 1;

yLim = get(handles.imageAxes, 'YLim');
yLim(1) = ceil(yLim(1));
yLim(2) = floor(yLim(2));
ySiz = diff(yLim) + 1;

% maxIntensity = h_getMaxIntensity3(handles);
% if maxIntensity<=255
%     dataTypeStr = 'uint8';
% else
    dataTypeStr = 'uint16';
% end

switch filterindex
    case 1
        currentFilename = get(handles.currentFileName, 'string');
        d = dir(currentFilename);
        info=imfinfo(currentFilename);
        header = info(1).ImageDescription;
%         siz = currentStruct.image.data.size;
        data = zeros(ySiz, xSiz, (diff(zLim)+1)*2, dataTypeStr);
        data(:,:,1:2:end) = currentStruct.image.data.green(yLim(1):yLim(2),xLim(1):xLim(2),zLim(1):zLim(2));
        data(:,:,2:2:end) = currentStruct.image.data.red(yLim(1):yLim(2),xLim(1):xLim(2),zLim(1):zLim(2));
        for i = 1:size(data, 3)
            if i == 1
                imwrite(data(:,:,i), filename, 'tiff', 'compression', 'none','Description',header);
            else
                try%sometimes there is an error (<10% chance) due to unable to openfile, maybe dropbox associated...
                    imwrite(data(:,:,i), filename, 'tiff', 'compression', 'none', 'WriteMode', 'append');
                catch
                    try
                        imwrite(data(:,:,i), filename, 'tiff', 'compression', 'none', 'WriteMode', 'append');
                    catch
                        try
                            imwrite(data(:,:,i), filename, 'tiff', 'compression', 'none', 'WriteMode', 'append');
                        catch
                            imwrite(data(:,:,i), filename, 'tiff', 'compression', 'none', 'WriteMode', 'append');
                        end
                    end
                end
            end
        end
        h_setModifiedDate(filename, d.date);
% imwrite(data, filename, 'tiff', 'compression', 'none','Description', header);
        
%     case 2
%         for i = zLim(1):zLim(2)
%             data = cat(3,h_img2.image.data.red(:,:,i),h_img2.image.data.green(:,:,i),h_img2.image.data.blue(:,:,i));
% %             if short
% %                 data = uint8(data);
% %             end
%             if i == zLim(1)
%                 header = h_img2.info;
%                 rmfield(header,'fileType');
% %                 imwrite(data, filename, 'tiff', 'compression', 'none','Description',header);
%                 imwrite(data, filename, 'tiff', 'compression', 'none');
%             else
%                 imwrite(data, filename, 'tiff', 'compression', 'none', 'WriteMode', 'append');
%             end
%         end

    case 3
end