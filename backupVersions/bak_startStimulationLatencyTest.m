%% part of detect_stimulation_latency
 
global System FileInfo Tmr test Devices Figures

% did you preselect 1 electrode to stimulate?  
if test>100 % set the amount of repetiotions here
    System.exit=1; %% set exit flag to stop programm
    disp('finished!')
end
channel12YesNo=find(Cs==12);
if ~isempty(channel12YesNo)
    triggerTime=double(Ts(channel12YesNo)); % time of trigger event

    %% choose either to use predefined stimulation setting or just the trigger
     %  stimulate_electrode(FileInfo.StimOrder(1,2), FileInfo.channelorder, System.StimType, (FileInfo.StimOrder(1,3:4)), System.StimDuration);
    %% explanation: stimulate_electrode( displaychannel, channelorder, stimtype, amplitude, duration)
    Devices.stg.SendStart(uint32(1));
    %% choose a double pulse with a pause in between or single Pulse
    %          pause(0.010);
    %          Devices.stg.SendStart(uint32(1));
    %
    %detection88YesNo=[];% empty detection detector
    test=test+1;


end
   

   
