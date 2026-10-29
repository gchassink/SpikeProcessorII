global System FileInfo test
[Ts,Cs,Us,Ns] = detect_spikes(Data1,System.ChannelsUsed,System.noisevalues,FileInfo.threshold_multiplier,FileInfo.Samplerate,Usrange,FileInfo.channelorder,FileInfo.detectionType);
[TsStim,CsStim,UsStim, NsStim]=detect_stimulations(Data2,System.ChannelsUsed,10,FileInfo.threshold_multiplier,FileInfo.Samplerate,Usrange,FileInfo.channelorder);

%%%%% inject events here

%    createRandomEvent

%%%%%

%% correct timestamp to fit with Raw that might be saved as well:
% so + recordingtime but
% - 1 second (samplerate) because recording time is actually end of each second saved
% - blocksize, same reason but then for a loop
% - 4 ms since detectionscript cutout is shifts the timestamps
Ts=Ts+FileInfo.RecordingTime-double(System.blocksize)-(double(FileInfo.Samplerate)*Usrange(2));
TsStim=TsStim+FileInfo.RecordingTime-double(System.blocksize)-(double(FileInfo.Samplerate)*Usrange(2));
Ts=[Ts;TsStim];
Cs=[Cs;CsStim]; 
Ns=[Ns;NsStim];
Us=[Us;UsStim];


%Ts=Ts+FileInfo.RecordingTime-double(System.blocksize)-(double(FileInfo.Samplerate)*Usrange(2)); % compensate for shift in timestamp;

%% add to the buffer
TsBuffered=[TsBuffered;Ts];
CsBuffered=[CsBuffered;Cs];
    UsBuffered=[UsBuffered;Us];
    NsBuffered=[NsBuffered;Ns];

    %%bugtracking%%
%     tempEL=unique(CsBuffered);
%     for i=1:length(tempEL)
%         hit=find(diff(TsBuffered(CsBuffered==tempEL(i)))>=149 & diff(TsBuffered(CsBuffered==tempEL(i)))<=151);
%         if  ~isempty(hit)
%             TsBuffered(CsBuffered==tempEL(i))
%             tempEL(i)
%             hit
% 
%         end
%         hit=[];
%     end

%% add the spikes to the counter(s)
for i=1:length(Cs)
    System.Channelspikes(Cs(i))=System.Channelspikes(Cs(i))+1; % count events per electrode
    
end
