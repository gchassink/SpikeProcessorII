function System=callbackSetPlotType(source,event)
    %% set the plot type to be displayed
    global System
    System.plottype=source.Value;
end