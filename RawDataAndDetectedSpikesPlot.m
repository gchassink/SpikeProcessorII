rawChannelData=double(RawBuffered(System.channeldisp,:))*FileInfo.ResolutionPerDigit;
        X_Axes = double(1000) * (1:length(rawChannelData))/ (double(FileInfo.Samplerate));
        plot(X_Axes,rawChannelData);
        %axis([0 System.loopSize -400 200]); 
        axis([0 1000 -400 200]); 
        hold on
        thresholdplot(1:length(rawChannelData))=FileInfo.threshold_multiplier*System.noisevalues(System.channeldisp);
        plot(X_Axes,thresholdplot);
        hold on
        plot(X_Axes,-thresholdplot);
        if ~isempty(find(CsBuffered==FileInfo.channelorder(System.channeldisp), 1 ))
              hold on
              TsCurrentChannel=TsBuffered(find(CsBuffered==FileInfo.channelorder(System.channeldisp)));
              CorrectionForWaveshape=double(4);% (4*double(FileInfo.Samplerate)/1000);% 4 ms
              RecordingTime=FileInfo.RecordingTime ;
              msPerSample= double(1000)/(double(FileInfo.Samplerate));
              TsdetectedSpikes= (msPerSample * (TsCurrentChannel - RecordingTime))-CorrectionForWaveshape + double(1000)-System.loopSize;
              flag=0;
              if mode(TsdetectedSpikes)<0 
                    flag=1;
                  TsdetectedSpikes=TsdetectedSpikes+double(1000)-System.loopSize;% not the first, but the 10th so + 900 ms
              end

           xline(TsdetectedSpikes) ;

%          xline( double(1000) * (TsBuffered(find(CsBuffered==FileInfo.channelorder(System.channeldisp))) ...
%                 - (FileInfo.RecordingTime + (4*double(FileInfo.Samplerate)/1000)))...
%                 /(double(FileInfo.Samplerate)) ) ;
        


        end
       

        %% for debugging
%         if length(find(CsBuffered==FileInfo.channelorder(System.channeldisp) ))>20
%        
% 
%             plot(X_Axes,rawChannelData);
%             axis([0 1000 -400 200]); 
%             hold on
%             thresholdplot(1:length(rawChannelData))=FileInfo.threshold_multiplier*System.noisevalues(System.channeldisp);
%             plot(X_Axes,thresholdplot);
%             hold on
%             plot(X_Axes,-thresholdplot);
%             hold on
%             xline( TsdetectedSpikes ) ;
%             chan= System.channeldisp; chan
%             length(find(CsBuffered==System.channeldisp))
%             flag
%             pause
%             close
%             
%         end

        hold off
        title(['Raw data of channel ' int2str(FileInfo.channelorder(System.channeldisp))]);
        xlabel('Time (ms)');
        ylabel('Amplitude (\muV)');