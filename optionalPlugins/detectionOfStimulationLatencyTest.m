%% part of detect_stimulation_latency
 
global System FileInfo 

% preselect 1 electrode to stimulate FileInfo.timeAtButtonPress      

    if ~isempty(triggerTime)
        detection88YesNo=find(Cs==88);% find if the stimulation in the last read
        if ~isempty(detection88YesNo)
            detectionTime=double((Ts(detection88YesNo)));

%             if ~isfield(FileInfo,'stimulationLatencies') % make variable stimulationLatencies to store the latencies
%                 FileInfo.stimulationLatencies(1,1)=triggerTime;
%                 FileInfo.stimulationLatencies(1,2)=detectionTime;
%                 FileInfo.stimulationLatencies(1,3)=( (detectionTime-triggerTime)/double(FileInfo.Samplerate))*1000; %ms
%             else
%                 
%                 FileInfo.stimulationLatencies(end+1,1)=triggerTime;
%                 FileInfo.stimulationLatencies(end,2)=detectionTime;
%                 FileInfo.stimulationLatencies(end,3)=( (detectionTime-triggerTime)/double(FileInfo.Samplerate))*1000; %ms
%             end
            stimulationLatencies(itteration,1)=itteration;
            stimulationLatencies(itteration,2)=triggerTime;
            stimulationLatencies(itteration,3)=detectionTime;
            stimulationLatencies(itteration,4)=( (detectionTime-triggerTime)/double(FileInfo.Samplerate))*1000;
           disp(num2str(stimulationLatencies(itteration,:)));
           itteration=itteration+1;
           % disp ([ num2str( size(stimulationLatencies,1)), ' -- ', num2str(stimulationLatencies(end,:) )]);
            triggerTime=[]; detection88YesNo=[];
             
             
        end
    end

