function Aout = jbm_miscSynAnalysis(dendriteData)

conditions = fields(dendriteData);
numConditions = length(conditions);

ogDendriteData = dendriteData;

for i = 1:numConditions
  ngDendriteData.(conditions{i}) = rmfield(dendriteData.(conditions{i}),'group');
end

Aout.ngDendriteData = ngDendriteData;
