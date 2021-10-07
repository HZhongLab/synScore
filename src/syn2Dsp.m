function [] = syn2Dsp(synFn)

if strcmp(synFn(end-3:end),'.syn')
    synFn = [synFn '.mat'];
elseif strcmp(synFn(end-3:end),'.mat')
    synFn = synFn;
else
    disp('Wrong File Type');
end

temp = load(synFn,'-mat');
scoringData = temp.scoringData;

if ~isfield(scoringData,'skeleton')
    disp('.syn File Lacks Skeleton')
    return
else
end




keyboard;
end

