function [Aout,info,err] = h_genericOpenTif(filename, frame_numbers)
% [Aout,info] = h_genericOpenTif(filename, frame_numbers)
% h_genericOpenTif   - Opens an Image file with TIF extension.  It can retrieve
% only the frames specified by frame_numbers.

Aout=uint16([]);
header=[];

if ~(exist('frame_numbers')==1)
    frame_numbers = [];
end
err = 0;

if ~(length(frame_numbers)==1 && frame_numbers == 0)
    h = waitbar(0,'Opening Tif image...', 'Name', 'Open TIF Image', 'Pointer', 'watch');
end
try
    info=imfinfo(filename);
    frames = length(info);
    info = info(1);
    
    if isempty(frame_numbers)
        frame_numbers = [1:frames];
    else
        frame_numbers = frame_numbers(frame_numbers<=frames);
        frame_numbers = frame_numbers(frame_numbers~=0);
    end
    
    frame_numbers = frame_numbers(:)';%HN to make sure that frame_numbers is a horizontal vector.
    
    data = imread(filename, frame_numbers(1));
    if length(size(data))>2
        Aout = repmat(data,[1,1,1,length(frame_numbers)]);
        j = 1;
        for i = frame_numbers
            waitbar(i/frames,h, ['Loading Frame Number ' num2str(i)]);    
            Aout(:,:,:,j) = imread(filename, i);
            j = j+1;
        end
    else
        Aout = repmat(data,[1,1,length(frame_numbers)]);
        j = 1;
        for i = frame_numbers
            waitbar(i/frames,h, ['Loading Frame Number ' num2str(i)]);    
            Aout(:,:,j) = imread(filename, i);
            j = j+1;
        end
    end
    
    if exist('h')==1 & ishandle(h)
        waitbar(1,h, 'Done');
        close(h);
    end
catch
    close(h);
    disp(['Cannot load file: ' filename ]);
    err = 1;
end

