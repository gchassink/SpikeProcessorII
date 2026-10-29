%% [System.noisevalues rmsmatr]=estimate_noise(data,channels,adaptability,usedsignal,maxvalues,startvalue,rmsmatr)
% Calculate the noise estimations of the incoming data.
% The noise estimation is calculated by taking the average of several RMS
% values that are taken from the data. This is done for every channel.
% The noise estimation of the signal is the RMS of a part of the data,
% specified with 'usedsignal'.
% The adaptability controls how fast the noise estimation adapts to new
% incoming data by limiting how many
% persistent rmsmatr % a matrix of 40 noise values per channel
function [noisevalues rmsmatr]=estimate_noise(data,channels,adaptability,usedsignal,maxvalues,startvalue,rmsmatr)


    if isempty(rmsmatr)
        rmsmatr=ones(channels,maxvalues)*startvalue;
    end
    if adaptability ~= 0
        rmsmatr(:,1)=[];% this clears the first noise value to make room for the 40th (or maxvalues) (new) noise level
        len=length(data);
        for channel = 1:channels
            rmsmatr(channel,maxvalues)=rms(data(channel,1:round(len*usedsignal)));
            %rmsmatr(channel,maxvalues)=7;%fix noise
            

        end
        %System.noisevalues=mean(rmsmatr(:,11-adaptability:10),2);
        noisevalues=mode(round( rmsmatr(:,adaptability:end)),2);%
        
    else
        noisevalues=mode(round(rmsmatr(:,1:end)),2);
        
    end
end