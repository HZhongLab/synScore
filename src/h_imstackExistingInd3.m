function [existingInd, nextInd] = h_imstackExistingInd3

global h_img3

if isstruct(h_img3)
    fieldNames = fieldnames(h_img3);
else
    fieldNames = {};
end

fieldNames(ismember(fieldNames,'common')) = [];

existingInd = [];
for i = 1:length(fieldNames)
    existingInd(i) = h_img3.(fieldNames{i}).instanceInd;
end

candidateInd = 1:100;
candidateInd(ismember(candidateInd, existingInd)) = [];
nextInd = candidateInd(1);

