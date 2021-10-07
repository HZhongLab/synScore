function [data, header, err] = h_openScanImageTif2(fname, frameNumbers);

if ~(exist('frameNumbers')==1)
    frameNumbers = [];
end
data = struct('red',[],'green',[],'blue',[],'size',[]);
header = [];

[data1, header1, err] = h_OpenTif(fname,0);

try
    total_Channels = header1.acq.savingChannel1 + header1.acq.savingChannel2 + header1.acq.savingChannel3;
    if ~err
        total_Channels = header1.acq.savingChannel1 + header1.acq.savingChannel2 + header1.acq.savingChannel3;
        switch total_Channels
            case 1
                [data1, header, err] = h_OpenTif(fname,frameNumbers);
                
                data.size = size(data1);
                
                if header1.acq.savingChannel1
                    data.green = data1;
                elseif header1.acq.savingChannel2
                    data.red = data1;
                elseif header1.acq.savingChannel3
                    data.blue = data1;
                end
            case 2
                frameNumbers = [frameNumbers*2-1,frameNumbers*2];
                frameNumbers = sort(frameNumbers(:));
                [data1, header, err] = h_OpenTif(fname,frameNumbers);
                
                data.size = size(data1);
                data.size(3) = data.size(3)/2;
                
                if ~header1.acq.savingChannel1
                    data.red = data1(:,:,1:2:end);
                    data.blue = data1(:,:,2:2:end);
                elseif ~header1.acq.savingChannel2
                    data.green = data1(:,:,1:2:end);
                    data.blue = data1(:,:,2:2:end);
                elseif ~header1.acq.savingChannel3
                    data.green = data1(:,:,1:2:end);
                    data.red = data1(:,:,2:2:end);
                end
            case 3
                frameNumbers = [frameNumbers*3-2,frameNumbers*3-1,frameNumbers*3];
                frameNumbers = sort(frameNumbers(:));
                [data1, header, err] = h_OpenTif(fname,frameNumbers);
                
                data.size = size(data1);
                data.size(3) = data.size(3)/3;
                
                data.green = data1(:,:,1:3:end);
                data.red = data1(:,:,2:3:end);
                data.blue = data1(:,:,3:3:end);
        end
    end
catch
    err = 1;
end