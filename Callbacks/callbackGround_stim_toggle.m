function callbackGround_stim_toggle(source,event)
    %% switch between ground and stimulation selection
        global System FileInfo Figures ;
    System.ground_stim_toggle = source.Value;
    
end