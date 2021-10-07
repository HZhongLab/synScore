function [densities,nums] = jbm_calcD0DensFromDD(dendriteData)
fldz = fields(dendriteData)
for i = 1:length(fldz)
   condt = dendriteData.(fldz{i})
   densities.(fldz{i}).total = [];
   densities.(fldz{i}).spines = [];
   densities.(fldz{i}).shafts = [];
   nums.(fldz{i}).total = 0;
   nums.(fldz{i}).spines = 0;
   nums.(fldz{i}).shafts = 0;
   
   condt = rmfield(condt,'group');
   dends = fields(condt);
   
   SAMPLING_DAY = 2;
   
   
   for j = 1:length(dends)
       aa = dendriteData.(fldz{i}).(dends{j}).scoringData
       if isfield(aa,'skeleton')
           
       dendlength = max(dendriteData.(fldz{i}).(dends{j}).scoringData.skeleton.tracingData{1}.skeletonInMicron(:,4))
       if dendlength > 0
           density = dendriteData.(fldz{i}).(dends{j}).dynamics.total.numSyn(SAMPLING_DAY)/dendlength
           densities.(fldz{i}).total = [densities.(fldz{i}).total density]
           nums.(fldz{i}).total = nums.(fldz{i}).total + dendriteData.(fldz{i}).(dends{j}).dynamics.total.numSyn(SAMPLING_DAY);
           
           samplingDaySynapseMatrix = dendriteData.(fldz{i}).(dends{j}).data.synapseMatrix(:,SAMPLING_DAY);
           spinesOnSamplingDay = length(find(samplingDaySynapseMatrix==2));
           shaftsOnSamplingDay = length(find(samplingDaySynapseMatrix == 1));
           spineDensitySamplingDay = spinesOnSamplingDay/dendlength;
           shaftDensitySamplingDay = shaftsOnSamplingDay/dendlength;
       
           nums.(fldz{i}).spines = nums.(fldz{i}).spines + spinesOnSamplingDay;
           nums.(fldz{i}).shafts = nums.(fldz{i}).shafts + shaftsOnSamplingDay;

           densities.(fldz{i}).spines = [densities.(fldz{i}).spines spineDensitySamplingDay];
           densities.(fldz{i}).shafts = [densities.(fldz{i}).shafts shaftDensitySamplingDay]

           
           
 
       else
       end
       end

   end

end

end

