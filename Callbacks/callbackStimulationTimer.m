%% timer callback for stimulation
function callbackStimulationTimer(obj, event, index)
    global System FileInfo Tmr
    stimulate_electrode(FileInfo.StimOrder(index,2), FileInfo.channelorder, System.StimType, (FileInfo.StimOrder(index,3:4)), System.StimDuration);
    %electrode=FileInfo.StimOrder(index,2);electrode
        
    stop(Tmr);
    delete(Tmr);
    System.StimIndex=index+1;  
    if System.StimIndex<=size(FileInfo.StimOrder,1)
        Tmr = timer;
        Tmr.ExecutionMode = 'single';
        Tmr.TimerFcn = {@callbackStimulationTimer,System.StimIndex};%
        System.stimEventTime=datetime;
        prevstim=round(seconds(diff([System.stimStart, System.stimEventTime])),3);
        nextstim=round(double(FileInfo.StimOrder(System.StimIndex,1)),3);
        delay=round(nextstim-prevstim,3);
        
        Tmr.StartDelay=delay;
        start(Tmr);
        
    end
                
end