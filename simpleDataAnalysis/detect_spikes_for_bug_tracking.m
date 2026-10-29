%% [Ts,Cs,Us,Ns] = detect_spikes(data,nchannels,noiseestim,thresholdmultiplier,samplerate,Usrange,pinlayout)
% base interface for spike detection. For now fastfindpeaks is used but
% others can be implemented here
% Detect_spikes uses threshold based spike detection using the noise values.
% Returns for each spike: Time in samples, Channel where the spike is found, a part of the waveshape (Size is determined by
% Usrange), and the noise estimation of the channel.
% Data = data used for spike detection
% nchannels = number of used channels
% noiseestim = vector with noise estimation for each channel
% thresholdmultiplier = how many times the noise is multiplied to determine
% the threshold.
% samplerate = samplerate of the MEA device
% Usrange = The range of recorded waveforms in seconds
% Channellayout is an array used to find the right channel number,
% corresponding with the rows of data.
function [Ts,Cs,Us,Ns] = detect_spikes(data,nchannels,noiseestim,thresholdmultiplier,samplerate,Usrange,channellayout,detectionType)
     
    Ts=double([]);
    Cs=uint16([]);
    Us=int16([]);
    Ns=double([]);
        channel = 1:nchannels;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Choose whether you want absolute or negative only detection %%%
        %%% NEGATIVE ONLY be aware for detecting noise as spikes (look the
        %%% same)
        if detectionType==1
            [C, T]=fastfindpeaks(-data(channel,: ), samplerate*0.0005, noiseestim(channel)*-thresholdmultiplier);
            %(-Usrange(1)*samplerate):length(data)-(Usrange(2)*samplerate)
            %[C, T]=fastfindpeaks(-data(channel,(-Usrange(1)*samplerate):length(data)-(Usrange(2)*samplerate) ), samplerate*0.0005, noiseestim(channel)*-thresholdmultiplier);
            % this takes a cut from the data removing first 2 ms and last 4 ms,
            % to prevent double detections
        else
            %%% POSITIVE and NEGATIVE be aware that you might detect the
            %%% positive component of the spike in stead of the negative one,
            %%% artifact detection might be nessesary
            [C, T]=fastfindpeaks(abs( -data(channel,(-Usrange(1)*samplerate)-1:1+length(data)-(Usrange(2)*samplerate) ) ), samplerate*0.001, abs(noiseestim(channel)*-thresholdmultiplier));
        end
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if ~isempty(T)
             eventsInBlock=find(T> (-Usrange(1)*samplerate) & T<(size(data,2)-( (Usrange(2)-Usrange(1)) *samplerate)));
             if ~isempty(eventsInBlock)


                 Ts=T(eventsInBlock);

                 Cs=channellayout(C(eventsInBlock))';
                 Ns=noiseestim(C(eventsInBlock));

                 %UsSampleSize=int32(1:(samplerate*Usrange(2)-samplerate*Usrange(1)));
                 UsSampleSize=int32((samplerate*Usrange(1))+1:(samplerate*Usrange(2)));
                 dataTransformed=data';
                 linearIndex = int32(sub2ind(size(dataTransformed), T(eventsInBlock),C(eventsInBlock))) ;

                 Indices=linearIndex + UsSampleSize;
                 %data2=data';
                 TheseUs=dataTransformed(Indices);
                 %         Indices=int32(T)+UsSampleSize;
                 %         TheseData=data(channel,:);
                 %         TheseUs=TheseData(Indices);

                 Us=[Us;TheseUs];
             end
         end

%         for i=1:length(T)
%             Us=[Us;data(channel,T(i):T(i)+samplerate*Usrange(2)-1-samplerate*Usrange(1))];
%         end
        
    %end
    
end

