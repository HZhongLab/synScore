function Aout = esoin_dataMunge(experimenter,rig)
TIF_LENGTH = 17;

raw_dir = uigetdir('','Please select raw data directory');
munge_dir = uigetdir('','Please select target munged directory');

init_string = 'Initializing Munge ... ';
munge_string = 'Munging ... ';
commence_string = 'Munge Complete ';

disp(init_string);
disp(munge_string);

raw_files = dir(raw_dir);
raw_files = raw_files(3:end); %Remove pointer directories ('.', '..')
raw_filenames = {raw_files.name};
raw_subdirs = raw_filenames([raw_files.isdir]);

for i = 1:length(raw_subdirs)
    if (length(raw_subdirs{i})<length([experimenter rig]))
        raw_subdirs{i} = [];
    end
end

raw_subdirs = raw_subdirs(~cellfun('isempty',raw_subdirs));

for i = 1:length(raw_subdirs)
    if raw_subdirs{i}(1:4) ~= [experimenter rig]
        raw_subdirs{i} = [];
    end
end
raw_subdirs = raw_subdirs(~cellfun('isempty',raw_subdirs));

% Tested up until this point.

for i = 1:length(raw_subdirs)
    subdir_tifs(i).files = dir(strcat(raw_dir,'\',raw_subdirs{i},'\*.tif'));
end

for i = 1:length(subdir_tifs)
    aa = subdir_tifs(i).files;
    for j = 1:length(aa)
        subdir_tifs(i).filenames = {aa.name};
    end
end

for i = 1:length(subdir_tifs)
    aa = find(cellfun('length',subdir_tifs(i).filenames) == TIF_LENGTH);
    subdir_tifs(i).filenames = subdir_tifs(i).filenames(aa);
    for j = 1:length(subdir_tifs(i).filenames)
        bb = char(subdir_tifs(i).filenames{j});
        if bb(1:4) ~= strcat(experimenter,rig)
            subdir_tifs(i).filenames(j) = [];
        end
    end
    subdir_tifs(i).filenames = subdir_tifs(i).filenames(~cellfun('isempty',subdir_tifs(i).filenames));

end

k = 1;
for i = 1:length(subdir_tifs)
    aa = subdir_tifs(i).filenames;
    for j = 1:length(aa)
        tif_paths{k} = strcat(raw_dir,'\',raw_subdirs(i),'\',aa(j));
        k = k+1;
    end
end

all_tifs = [subdir_tifs.filenames];

for i = 1:length(all_tifs)
    aa = char(all_tifs(i));
    animals{i} = aa(9:10);
end

for i = 1:length(all_tifs)
    aa = char(all_tifs(i));
    dendrites{i} = aa(9:end-4);
end

dendrites = unique(dendrites);

wb = waitbar(0,'Munge Progress');


for i = 1:length(dendrites)
    waitbar(i/length(dendrites),wb);
    if ~exist(strcat(munge_dir,'\',char(dendrites(i))))
        mkdir(strcat(munge_dir,'\',char(dendrites(i))));
    end
    
    
    for j = 1:length(tif_paths)
        aa = char(tif_paths{j});
        if strcmp(aa(end-8:end-4),dendrites(i)) && ~exist(strcat(munge_dir,'\',char(dendrites(i)),'\',aa(end-16:end)));
            bb = strcat(munge_dir,'\',dendrites{i},'\',all_tifs{j});
            copyfile(aa,bb,'f');
        end
    end            
end


disp(commence_string);


Aout.raw_dir = raw_dir;
Aout.munge_dir = munge_dir;
Aout.raw_subdirs = raw_subdirs;
Aout.subdir_tifs = subdir_tifs;
Aout.animals = animals;
Aout.dendrites = dendrites;
Aout.all_tifs = all_tifs;
Aout.tifpaths = tif_paths;