function callbackSetStimType(source,event)
    %% switch from current to voltage stimulation or vice versa
    global  System
    switch source.Value
        case 1
            System.StimType='mV';
            System.StimAmplitude=int32([-1, 1; -5, 5; -10, 10; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0]);
            System.StimReset=1;
        case 2
            System.StimType='uA';
            System.StimAmplitude=int32([-8, 8; -12, 12; -24, 24; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0]);
            System.StimReset=1;
        end
    
end