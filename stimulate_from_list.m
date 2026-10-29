 %% stimulate_from_list
 % defines electrode sequence, amplitude, duration, interstimulus intervals 
 % (ISI) and intervals between sequential electrodes, based on 
 % - System.StimAmplitude
 % - System.StimDuration
 % - System.fileISI
 % - System.StimRepeats
 % - System.electrode_list
 % - System.SuperDelay
 % It then invokes stimulate_electrode in order of electro_list.
 % This will program the stimulator per electrode to be stimulated
 % every core loop it will check if:
 %          FileInfo.RecordingTime-ThisStimStart> delayBetweenRepetitions 
 % if so next electrode to stimulate will be picked
 % like with random stimulation stimulation times and electrodes will be
 % stored in FileInfo.StimOrder for future reference 
 
 if System.stimlistlength==length(System.electrode_list)
     disp('Starting stimulation from list');
     base_amplitude=System.StimAmplitude(1,:)*1000;
     System.ISI=FileInfo.fileISI(1:length(FileInfo.fileISI)) %times in seconds
     repetitionsPerElectrode=length(FileInfo.fileISI); % but can be set to othervalues for future purposes
     delayBetweenRepetitions=System.SuperDelay; %see above
     amplitude=int32([repmat([base_amplitude, 0],1,repetitionsPerElectrode)])%
     %amplitude=int32([-200000, 200000,0,-100000, 100000,0,-50000,50000]);
     %amplitude=int32(repmat([base_amplitude, 0],1,System.StimRepeats));
     
     %duration= int64([0, repmat([System.StimDuration ,0],1,System.StimRepeats),delayBetweenRepetitions,0]);%int32([0, 20,20,40,20,20,40,20,20,100,0]);%repmat([-20;20;40],repeats,1);
     duration= int64(repmat([System.StimDuration ,0],1,repetitionsPerElectrode));%
     %duration= int64([200,200,1000000,200,200,1000000,200,200]);%repmat([-20;20;40],repeats,1);
     %duration(2:3:System.StimRepeats*3)= int64(floor(System.ISI * 1000000/20)*20); %force ISI 20 uS resolution
     duration(3:3:length(duration))= int64(floor(System.ISI * 1000000/20)*20) %force ISI to  20 uS resolution
     listnumber=1;
     %stimulate_electrode_repeatedly( devicelist, System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int32(duration));
     stimulate_electrode(System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int64(duration));
     ThisStimStart=FileInfo.RecordingTime; % in 1000000/System.blocksize uS
     for i=1:length(System.electrode_list)
         i
         for j=1:length(System.ISI)
             FileInfo.StimOrder( ((i-1)*length(System.ISI)) +j,1)=System.ISI(j);
             FileInfo.StimOrder( ((i-1)*length(System.ISI)) +j,2)=System.electrode_list(i);
             FileInfo.StimOrder( ((i-1)*length(System.ISI)) +j,3:4)=base_amplitude;
         end
     end
     CumulativeISIs=cumsum(FileInfo.StimOrder(:,1));
     FileInfo.StimOrder(:,1)=CumulativeISIs;
     System.LastStim=1;
     System.stimlistlength=System.stimlistlength-1;
     
 else
     if FileInfo.RecordingTime-ThisStimStart>((sum(double(duration))/1000000)+delayBetweenRepetitions)*System.blocksize & listnumber<length(System.electrode_list)
         listnumber=listnumber+1;
         %stimulate_electrode_repeatedly( devicelist, System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int32(duration));
         stimulate_electrode(System.electrode_list(listnumber), FileInfo.channelorder, System.StimType, int32(amplitude), int64(duration));
         ThisStimStart=FileInfo.RecordingTime;
         System.stimlistlength=System.stimlistlength-1;
         %CsStim(1:length(TsRel))=System.electrode_list(listnumber);
         %TsStim=TsRel + ThisStimStart;
     end
 end