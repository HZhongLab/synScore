function h_imstack3CloseFcn

global h_img3;

try
    currentInd = h_getCurrendInd3;
    h_img3 = rmfield(h_img3, ['I', num2str(currentInd)]);
    
    remainingFieldNames = fieldnames(h_img3);
    
    flag = 1;
    for i = 1:length(remainingFieldNames)
        if strfind(remainingFieldNames{i}, 'I')
            flag = 0;
            break;
        end
    end
    
    if flag
        clear global h_img3;
    end
end