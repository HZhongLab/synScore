function [color, eraseMode, lineWidth] = h_getColor3(synapseAnalysis)

if ~(synapseAnalysis.isLast>0)%unassigned is -1
    ROIType = synapseAnalysis.synapseStatus;
else % if isLast has been assigned and is larger than 1.
    switch(synapseAnalysis.synapseStatus)
        case {'new'}
            ROIType = 'transient';
        case {'', 'same'}%this way, if it is moved, the color is still cyan.
            ROIType = 'last';
        case {'moved'}
            ROIType = 'moved and last';
        otherwise
            ROIType = synapseAnalysis.synapseStatus;
    end
end

switch(ROIType)
    case 'new'
        color = 'green';
        eraseMode = 'normal';
        lineWidth = 2;
    case 'last'
        color = 'red';
        eraseMode = 'normal';
        lineWidth = 2;
    case 'transient'
        color = 'yellow';
        eraseMode = 'normal';
        lineWidth = 2;
    case 'error'
        color = 'red';
        eraseMode = 'normal';
        lineWidth = 10;
    case 'same'
        color = 'blue';
        eraseMode = 'normal';
        lineWidth = 2;
    case 'moved'
        color = 'cyan';
        eraseMode = 'normal';
        lineWidth = 2;
    case 'moved and last'
        color = 'magenta';
        eraseMode = 'normal';
        lineWidth = 2;
    case ''
        color = 'black';
        eraseMode = 'XOR';
        lineWidth = 0.5;
    otherwise
        color = 'black';
        eraseMode = 'XOR';
        lineWidth = 0.5;
end

