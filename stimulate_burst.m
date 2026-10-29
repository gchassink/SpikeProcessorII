%% stimulate_burst
% (From the documentation of the DLL)
% The STG200x & STG400x Series Stimulus Generators have two distinct modes of operation, 
% the Download mode and the Streaming mode:The Download mode is the "classic" mode of 
% operation, as used by the MC Stimulus software. In this mode, one or multiple 
% waveforms are defined in PC memory and downloaded to the STG. The waveforms 
% are stored in STG device onboard memory and can be sent to the analog and 
% sync outputs once or multiple times. The STG can operate independantly from 
% the PC (without computer connection) after the download. Output is triggered
% either by the front panel start/stop button, the digital trigger inputs or under software control.
% The other mode of operation is the Streaming mode. Here the analog output 
% is sent to the STG device in "real time". The PC has to be connected to the 
% STG all the time. The data that is sent to the analog output is downloaded 
% from the PC to the STG on the fly. The Streaming mode is useful for applications 
% where flexible feedback is needed as well for applications where very long 
% waveforms which are not repeated (such as white noise) are used.
% program burst stimulation of CStg200xDownloadBasicNet directly 20 us
% Each datapoint is represented by an signed 32bit integer value. When using voltage stimulation, the values are in
% multiple of 1 uV, thus the possible range is += 2000 V. When using current stimulation, the values are in multiple of
% 1 nA, this the possible range is += 2000 mA.
% The duration is given as a list of 64 bit integers. Durations are given in units of us. The STG has a resolution of 20 us.
% Blocks of data which should repeat can be defined by prepending such a block with an entry in the arrays where
% both amplitude and duration is zero. The end of such an block is marked by an entry where the duration is set to
% zero and the amplitude beeing set to the number of times the block should run. Blocks can be nested. 
 if System.stimlistlength==length(System.electrode_list)
     base_amplitude=System.StimAmplitude(1,:)*1000;
     repetitionsPerElectrode=System.StimRepeats; % but can be set to othervalues for future purposes
     delayBetweenRepetitions=0; %see above
     % change to desired amplitudes
     amplitude=int32([0,-200000, 200000,0,-100000, 100000,0,-50000,50000,0,repetitionsPerElectrode]);
     % change to desired durations
     duration=int64([0, 2000,2000,4000,2000,2000,4000,2000,2000,10000,0]);
     test=test-1;listnumber=1;
     stimulate_electrode_burst(  System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int64(duration));
     ThisStimStart=FileInfo.RecordingTime; % in 1000000/System.blocksize uS
     
     System.LastStim=1;
     %% set timer for bringing back electrode to reading mode
     proceduretime=(sum(duration)*repetitionsPerElectrode/1000000)+1;% add 1 sec to make sure is slower
     Tmr = timer;
     Tmr.ExecutionMode = 'single';
     Tmr.TimerFcn = {@timer_callback2, System.electrode_list(listnumber)};
     Tmr.StartDelay=proceduretime; %delay in seconds based on stimorder, 0.001 second precission
     start(Tmr);
     
 else
     if FileInfo.RecordingTime-ThisStimStart>((sum(double(duration))/1000000)+System.SuperDelay)*System.blocksize
         test=test-1;listnumber=listnumber+1;
         stimulate_electrode_burst(  System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int64(duration));
         ThisStimStart=FileInfo.RecordingTime;
         
         %% set timer for bringing back electrode to reading mode
         proceduretime=(sum(duration)*repetitionsPerElectrode/1000000)+1;% add 1 sec to make sure is slower
         Tmr = timer;
         Tmr.ExecutionMode = 'single';
         Tmr.TimerFcn = {@timer_callback2, System.electrode_list(listnumber)};
         Tmr.StartDelay=proceduretime; %delay in seconds based on stimorder, 0.001 second precission
         start(Tmr);
     end
 end
 
%% timer callback for repeated stimulation
function timer_callback2(obj, event, channel)
    global Devices System 
    electrode=find(FileInfo.channelorder==channel);
    electrode
    activate_electrode(electrode, FileInfo.channelorder);
    
end