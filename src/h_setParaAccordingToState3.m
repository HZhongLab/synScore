function h_setParaAccordingToState3(handles)

global h_img3;

currentInd = h_getCurrendInd3(handles);

state = h_img3.(['I', num2str(currentInd)]).state;

names = fieldnames(state);

for i = 1:length(names)
    try
        ptynames = fieldnames(eval(['state.',names{i}]));
        handlename = ['handles.',names{i}];
        for j = 1:length(ptynames)
            varname = ['state.',names{i},'.',ptynames{j}];
            set(eval(handlename),ptynames{j},eval(varname));
        end
    end
end
