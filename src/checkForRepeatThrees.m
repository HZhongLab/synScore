function checkForRepeatThrees(dater)
dater = rmfield(dater,'group');
dendrites = fields(dater);
for i = 1:length(dendrites)
    synMtx = dater.(dendrites{i}).data.synapseMatrix;
    threes = synMtx == 3;
    threes = sum(threes,2);
    [repeats] = find(threes>1);
    if isempty(repeats)
        ;
    else
        disp(dendrites{i})
        synMtx(repeats,:)
    end
end
end

