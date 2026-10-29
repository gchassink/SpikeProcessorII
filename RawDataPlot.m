global System FileInfo
rawChannelData=double(RawBuffered(System.channeldisp,:))*FileInfo.ResolutionPerDigit;
        hold off
        X_Axes = double(1000) * (1:length(rawChannelData))/ (double(FileInfo.Samplerate));
        plot(X_Axes,rawChannelData);
         %axis([0 5000 -2000 2000]); % changed for slower refresh
        %axis([0 System.loopSize -400 200]); 
        if System.type==0030
        axis([0 1000 -400 200]); 
        hold on
        thresholdplot(1:length(rawChannelData))=FileInfo.threshold_multiplier*System.noisevalues(System.channeldisp);
        plot(X_Axes,thresholdplot);
        hold on
        plot(X_Axes,-thresholdplot);
        end
       
        %hold off
        title(['Raw data of channel ' int2str(FileInfo.channelorder(System.channeldisp))]);
        xlabel('Time (ms)');
        ylabel('Amplitude (\muV)');