%% [Ts,Cs,Us,Ns] = detect_stimulations(data,nchannels,noiseestim,thresholdmultiplier,samplerate,Usrange,channellayout)
% Detect stimulations usng the data2 channel 9 but assignes Cs=88 to them for later identification uses threshold based spike detection using the noise values.
% Works for now with noise setting 10. 
% ehen other channels or other spike values are used a different approach
% might have to be used
function [Ts,Cs,Us,Ns] = detect_stimulations(data,nchannels,noiseestim,thresholdmultiplier,samplerate,Usrange,channellayout)
global FileInfo
    if FileInfo.adaptertype~="Multiwell"
    
        stimchannel=61; % check if the were stimulations 61 (88)
    else
        stimchannel=289; % check if the were stimulations 289
    end


    Ts=double([]);
    Cs=uint16([]);
    Us=int16([]);
    Ns=double([]);
    if size(data,1)>=9
        %% commented out for multiwell
        for channel = 9 % 1:nchannels
            T=fastfindStimulations(abs(-data(channel,(-Usrange(1)*samplerate)+1:length(data)-((Usrange(2)*samplerate)) )), samplerate*0.001, abs(noiseestim*-thresholdmultiplier) )';
            Ts=[Ts;T];
            Cs=[Cs;ones(length(T),1)*channellayout(stimchannel)];
           
            Ns=[Ns;ones(length(T),1)*1];
            for i=1:length(T)
                Us=[Us;data(channel,T(i):T(i)+samplerate*Usrange(2)-1-samplerate*Usrange(1))];
            end

        end
    end
end

