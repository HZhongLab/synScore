function scoringData = jbm_loadSynFile(fname)
try
    extension = fname(end-3:end);
catch
    isstruct(fname) && isfield(fname,'synapseZ')
    scoringData = fname;
    return
end

if strcmp(extension,'.syn')
    aa = load([fname '.mat']);
    scoringData = aa.scoringData;
elseif strcmp(extension,'.mat')
    bb = load(fname);
    scoringData = bb.scoringData;
else
    cc = load([fname '.syn.mat']);
    scoringData = cc.scoringData;
end



