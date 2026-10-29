function callbackStimulationButtons(source,event)
    %% select electrodes to stimulate
    global System   ;
    System.channeldisp = source.Value;
    if System.Stim(System.channeldisp)==0
        
        System.Stim(System.channeldisp)=1;
        set (source,'BackgroundColor','red');
    else
        
        System.Stim(System.channeldisp)=0;
        set (source,'BackgroundColor', 'blue');
    end
end