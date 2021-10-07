function Aout = h_routinesForInVivoAnalysis(flag, varargin)

for ii = 1:length(flag)
    switch(flag(ii))
        case 1 % 1) spine number syntax: Aout = h_routinesForInVivoAnalysis(1, synapseAnalysisData, figFlag)
            presenceMatrix = varargin{1}.presenceMatrix;
            synapseNum = sum(presenceMatrix, 1);
            Aout.synapseNum = synapseNum;
            if nargin>2
                figFlag = varargin{2};
                if figFlag
                    dates = 0:4:4*(length(synapseNum)-1);
                    figure, plot(dates, synapseNum, '-o');
                    ylim([0, ceil(max(synapseNum)/10)*10]);
                    ylabel('synapse number', 'fontsize', 12);
                    xlabel('imaging day', 'fontsize', 12);
                end
            end
        case 2 % 2) survival function: Aout = h_routinesForInVivoAnalysis(2, synapseAnalysisData, figFlag)
            presenceMatrix = varargin{1}.presenceMatrix;
            ind = find(presenceMatrix(:,1));
            survivalFcn = mean(presenceMatrix(ind, :), 1);
            Aout.survivalFcn = survivalFcn;
            if nargin>2
                figFlag = varargin{2};
                if figFlag
                    dates = 0:4:4*(length(survivalFcn)-1);
                    figure, plot(dates, survivalFcn, '-o');
                    ylim([0, 1.1]);
                    ylabel('Survival Fraction', 'fontsize', 12);
                    xlabel('imaging day', 'fontsize', 12);
                end
            end
        case 3 % 3) synapse elimination event Aout = h_routinesForInVivoAnalysis(3, synapseAnalysisData, figFlag)
            presenceMatrix = varargin{1}.presenceMatrix;
            eliminationMatrix = (diff(presenceMatrix, 1, 2)==-1);
            elimination = sum(eliminationMatrix, 1);
            Aout.elimination = elimination;
            if nargin>2
                figFlag = varargin{2};
                if figFlag
                    dates = 0:4:4*(length(elimination)-1);
                    figure, plot(dates, elimination, '-o');
                    ylim([0, max(elimination)+1]);
                    ylabel('Elimination Number', 'fontsize', 12);
                    xlabel('imaging day', 'fontsize', 12);
                end
            end
        case 4 % 4) synapse addition event Aout = h_routinesForInVivoAnalysis(4, synapseAnalysisData, figFlag)
            presenceMatrix = varargin{1}.presenceMatrix;
            additionMatrix = (diff(presenceMatrix, 1, 2)==1);
            addition = sum(additionMatrix, 1);
            Aout.addition = addition;
            if nargin>2
                figFlag = varargin{2};
                if figFlag
                    dates = 0:4:4*(length(addition)-1);
                    figure, plot(dates, addition, '-o');
                    ylim([0, max(addition)+1]);
                    ylabel('Addition Number', 'fontsize', 12);
                    xlabel('imaging day', 'fontsize', 12);
                end
            end
        otherwise
    end
end

    
