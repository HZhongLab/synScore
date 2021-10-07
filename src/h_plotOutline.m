function h = h_plotOutline(axesHandle, mask, plotOptStr, scale, offset)

if ~exist('scale','var') || isempty(scale)
    scale = [1 1];
end

if ~exist('plotOptStr','var') || isempty(plotOptStr)
    plotOptStr = 'w-';
end

if ~exist('offset','var') || isempty(offset)
    offset = [0 0];
end

xscale = scale(1);
yscale = scale(2);

xoffset = offset(1);
yoffset = offset(2);

outline = h_getNucleusOutline(mask);
h = [];
for j = 1:length(outline)
    h(j) = plot(axesHandle, outline{j}(:,2)*xscale+xoffset, outline{j}(:,1)*yscale+yoffset, plotOptStr);
end