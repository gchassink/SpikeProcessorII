function callbackNoiseEstimationSpeed(source,event)
    %% set the noise adaptability
    global  FileInfo
   FileInfo.NoiseAdaptability = round(source.Value);
    set(source,'Value',FileInfo.NoiseAdaptability);
    set(findobj(source.Parent.Children,'Tag','adaptval'),'String',FileInfo.NoiseAdaptability);
end