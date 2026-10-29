function callbackSetThreshold(source,event)
    %% set the noise thresholds multiplier
    global FileInfo
    FileInfo.threshold_multiplier = round(2*source.Value)/2; %om op halven af te ronden
    set(source,'Value',FileInfo.threshold_multiplier);
    set(findobj(source.Parent.Children,'Tag','threshval'),'String',FileInfo.threshold_multiplier);
end
