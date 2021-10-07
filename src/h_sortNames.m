function names2 = h_sortnames(names)

if ~iscell(names)
    return;
else
    names = names(:);
end

for i = 1:length(names)
    l(i) = length(names{i});
end
names2 = [];
while ~isempty(l)
    min_length = min(l);
    I = l==min_length;
    names2 = [names2;sortrows(names(I))];
    l(I)=[];
    names(I)=[];
end
