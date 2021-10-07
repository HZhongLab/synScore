function addClusteringToDir(dirPath)

files = dir(dirPath);
files = files(3:end);
files = {files.name};

disp(['THERE ARE ' num2str(length(files)) ' SYN FILES']);
NUM_WITH = 0;
NUM_WITHOUT = 0;

for f = 1:length(files)
    file = files{f};
    try
        synClustOnFile(file);
    catch
        disp([file ' ERROR']);
        
    end
end