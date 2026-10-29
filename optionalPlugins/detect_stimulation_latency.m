%% detect_stimulation_latency
 
global System FileInfo Tmr test Devices

reacted=find(Cs==61 );
     
     
if ~isempty(reacted)
    if test==1 && FileInfo.testButtonWasPressed==1
        index=1;
    stimulate_electrode(FileInfo.StimOrder(index,2), FileInfo.channelorder, System.StimType, (FileInfo.StimOrder(index,3:4)), System.StimDuration);
    disp('first stimulation');
    test=0;
    else
        Devices.stg.SendStart(uint32(1));
        
        % disp('a repeat');
    end
   
end