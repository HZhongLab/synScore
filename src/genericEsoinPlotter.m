function genericEsoinPlotter2Cond(numConditions,varargin)
dendriteData = varargin{1};
parameterToPlot = varargin{2};
numConditions = length(varargin)-2
conditions = {varargin{3:end}}
colors = {'k','r','b'}


f = figure;
f2 = figure;
hold on


f;
for i = 1:numConditions
   condition = conditions{i}
   color = colors{i}
   if strcmp(color,'b')
       bgColor = 'c'
   elseif strcmp(color,'r')
       bgColor = 'm'
   end
   indTraces = dendriteData.(condition).group.total.(parameterToPlot).mtx'
   plot(indTraces,color,'lineWidth',1)
   h(i) = errorbar(dendriteData.(condition).group.total.(parameterToPlot).avg, ...
       dendriteData.(condition).group.total.(parameterToPlot).ste,color,'lineWidth',2,'DisplayName',condition)
   legendzzz{i} = condition;
   
end
    
    
    set(gca,'TickDir','out','lineWidth',2,'fontSize',14,'fontWeight','bold')
    legend(h,legendzzz)
    
    
    switch numConditions
        case 3
    
%   
f2 = figure; hold on; 

avgs = [dendriteData.(conditions{1}).group.total.(parameterToPlot).avg;
dendriteData.(conditions{2}).group.total.(parameterToPlot).avg;dendriteData.(conditions{3}).group.total.(parameterToPlot).avg]';
ste = [dendriteData.(conditions{1}).group.total.(parameterToPlot).ste;
dendriteData.(conditions{2}).group.total.(parameterToPlot).ste;dendriteData.(conditions{3}).group.total.(parameterToPlot).ste]';
barwitherr(ste,avgs); hold on

plot(dendriteData.(conditions{1}).group.total.(parameterToPlot).mtx','ko')
plot(dendriteData.(conditions{2}).group.total.(parameterToPlot).mtx','ro')
plot(dendriteData.(conditions{3}).group.total.(parameterToPlot).mtx','bo')


 
    set(gca,'TickDir','out','lineWidth',2,'fontSize',14,'fontWeight','bold')
        case 2



  
f2 = figure
hold on 

avgs = [dendriteData.(conditions{1}).group.total.(parameterToPlot).avg; dendriteData.(conditions{2}).group.total.(parameterToPlot).avg]';
ste = [dendriteData.(conditions{1}).group.total.(parameterToPlot).ste; dendriteData.(conditions{2}).group.total.(parameterToPlot).ste]';
barwitherr(ste,avgs);
hold on
plot(dendriteData.(conditions{1}).group.total.(parameterToPlot).mtx','bo')
plot(dendriteData.(conditions{2}).group.total.(parameterToPlot).mtx','ro')


 
    set(gca,'TickDir','out','lineWidth',2,'fontSize',14,'fontWeight','bold')









    end

end