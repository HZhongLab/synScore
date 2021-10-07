function aggData = jbm_aggregateSynMatrices(dendriteData)

conditions = fields(dendriteData);
numConditions = length(conditions);

for i = 1:numConditions
    condition = dendriteData.(conditions{i});
    condition = rmfield(condition,'group');

    dendrites = fields(condition);
    numDendrites = length(dendrites);
    aggSpineMatrix = [];
    aggShaftMatrix = [];
    aggTotalMatrix = [];
    aggAddedD4Mtx = [];
    aggAddedD5Mtx = [];



    for j = 1:numDendrites
        dendrite = condition.(dendrites{j});
        data = dendrite.data;
        spineMatrix = data.spinePresenceMatrix;
        shaftMatrix = data.shaftPresenceMatrix;
        totalMatrix = data.presenceMatrix;
        addedD4Matrix = data.addedD4Mtx;
        addedD5Matrix = data.addedD5Mtx;
        
        numTP = size(totalMatrix,2);
        if numTP == 7

            disp([dendrites{j} ' has 7 TP']);

        elseif numTP == 8
            %%
            if ~exist('aggSpineMatrix') && ~isempty(spineMatrix)
                aggSpineMatrix = spineMatrix;
            elseif exist('aggSpineMatrix')
                aggSpineMatrix = vertcat(aggSpineMatrix,spineMatrix);
            end

            if ~exist('aggShaftMatrix') && ~isempty(shaftMatrix)
                aggShaftMatrix = shaftMatrix;
            elseif exist('aggShaftMatrix')
                aggShaftMatrix = vertcat(aggShaftMatrix,shaftMatrix);
            end

            if ~exist('aggTotalMatrix') && ~isempty(totalMatrix)
                aggTotalMatrix = totalMatrix;
            elseif exist('aggTotalMatrix')
                aggTotalMatrix = vertcat(aggTotalMatrix,totalMatrix);
            end
            
            if ~exist('aggAddedD4Matrix') && ~isempty(addedD4Matrix)
                aggAddedD4Matrix = addedD4Matrix;
            elseif exist('aggAddedD4Matrix')
                aggAddedD4Matrix = vertcat(aggAddedD4Matrix,addedD4Matrix);
            end
            
             if ~exist('aggAddedD5Matrix') && ~isempty(addedD5Matrix)
                aggAddedD5Matrix = addedD5Matrix;
            elseif exist('aggAddedD4Matrix')
                aggAddedD5Matrix = vertcat(aggAddedD5Matrix,addedD5Matrix);
            end

        else
            disp('error');
        end




    end

    aggData.(conditions{i}).spines = aggSpineMatrix;
    aggData.(conditions{i}).shafts = aggShaftMatrix;
    aggData.(conditions{i}).total = aggTotalMatrix;
    aggData.(conditions{i}).addedD4 = aggAddedD4Matrix;
    aggData.(conditions{i}).addedD5 = aggAddedD5Matrix;

end
end
