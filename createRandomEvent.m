% createRandomEvent
global System FileInfo test
if test>0
idx=find(Cs==12); Cs(idx)=[];Ts(idx)=[];Ns(idx)=[];Us(idx,:)=[]; % find and clear channel 12 events in this read
YesNo=rand;
chance=(0.25*double(System.blocksize)/double(FileInfo.Samplerate));

    if YesNo<chance % 25% chance? 
        UsSampleSize=int32(1:(FileInfo.Samplerate*Usrange(2)-FileInfo.Samplerate*Usrange(1)));% determine Us size
        Ts=[Ts ; round(rand*double(System.blocksize)) ]; % create extra Ts
        Cs=[Cs; 12];Ns=[Ns; 0]; Us=[Us; UsSampleSize];% create fake event on channel 12
        
        
    end

end