function callbackSetStimDelay(source,event)
    %% select start stimulation delay
    global  System
    switch source.Value
        case 1
            System.StimDelay=10;
        case 2
            System.StimDelay=30;
        case 3
            System.StimDelay=60;
        case 4
            System.StimDelay=60*5;
        case 5
            System.StimDelay=60*60;
        case 6
            System.StimDelay=60*60*6;
    end
    
end