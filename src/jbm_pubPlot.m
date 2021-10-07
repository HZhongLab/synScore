function jbm_pubPlot(figureHandle,varargin)
if ~exist('figureHandle')
    try
        figureHandle = gcf;
    catch
        disp('Must pass figure handle or have figure open');
        return
    end

else
    ;
end


if isempty(varargin)
    pos = get(figureHandle,'position');
    set(figureHandle,'position',[pos(1) pos(2) 560 420])
    box off
    set(gca,'fontsize',20,'TickDir','out')

else



















end
