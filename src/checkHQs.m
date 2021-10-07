function checkHQs(dirPath)

files = dir(dirPath);
files = files(3:end);
files = {files.name};

disp(['THERE ARE ' num2str(length(files)) ' SYN FILES']);

for f = 1:length(files)
    file = files{f};
    try
        file = load(file);
     
        fluor = file.scoringData.fluorData;
        disp(size(fluor))
        disp(fluor{1,1})
    catch
        disp([file ' ERROR']);
        
    end
end