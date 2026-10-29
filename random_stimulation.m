%% StimOrder=random_stimulation(System)
% Randomizes stimulation of selected electrodes using pre-set frequency and returns a list with: 
%
% [Stimulation times] [electrode] [negative amplitude] [positive amplitude]
%
% Times are absolute from start of recording.
function StimOrder=random_stimulation(System, FileInfo)
electrodes=FileInfo.channelorder(logical(System.Stim));
amplitudes=System.StimAmplitude*1000;%(System.StimAmplitude~=0);
amplitudes(amplitudes==0)=[];
amplitudes=reshape(amplitudes,length(amplitudes)/2,2);
repeats=System.StimRepeats;
ISI=1/System.StimFrequency;
t=System.StimDelay;
n=0;
for r=1:repeats
    for a=1:size(amplitudes,1)
        for e=1:length(electrodes)
            n=n+1;
            StimTemp(n,:)=[electrodes(e),amplitudes(a,1),amplitudes(a,2)];
            stim_times(n)=t;
            t=t+ISI;
        end
    end
end
shuffle=randperm(length(stim_times));
StimShuffled=StimTemp(shuffle,:);
StimOrder=[stim_times', double(StimShuffled)]
disp('done');
     