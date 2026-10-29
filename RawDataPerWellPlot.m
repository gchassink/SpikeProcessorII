X_Axes = double(1000) * (1:size(RawBuffered,2))/ (double(FileInfo.Samplerate));
wellSize=System.WellSize;
rawChannelData=double(RawBuffered((floor(System.channeldisp/wellSize)*wellSize)+1:(ceil(System.channeldisp/wellSize)*wellSize),:))*FileInfo.ResolutionPerDigit;
        hold off
    if ~(FileInfo.Samplerate <10000)
        %X_Axes = double(1000) * (1:length(rawChannelData))/ (double(FileInfo.Samplerate));
        for i=1:wellSize
        plot(X_Axes,rawChannelData(i,:)+i*100);
        %axis([0 System.loopSize -400 200]); 
        %axis([0 1000 -400 200]); 
        hold on
%         thresholdplot(1:length(rawChannelData))=FileInfo.threshold_multiplier*System.noisevalues(System.channeldisp);
%         plot(X_Axes,thresholdplot);
%         hold on
%         plot(X_Axes,-thresholdplot);
        end
        %hold off
        title(['Raw data of channel ' int2str(FileInfo.channelorder(System.channeldisp))]);
        xlabel('Time (ms)');
        ylabel('Amplitude (\muV)');
 
    else
        try
        testSys = System.NewPlot;
        end
        if ~exist("testSys","var")
            System.NewPlot = zeros(60,1000);
        end
        System.NewPlot = [System.NewPlot(:,2:end) mean(rawChannelData,2)];
        plot(System.NewPlot')
        title(['Raw data of channel ' int2str(FileInfo.channelorder(System.channeldisp))]);
        xlabel('Time (s)');
        ylabel('Amplitude (\muV)');
        y_axlim = [min(System.NewPlot(:,end-10:end),[],'all') ,max(System.NewPlot(:,end-10:end),[],'all')];
        y_axrange = y_axlim(2)-y_axlim(1);
        y_axlim(1) = y_axlim(1) - 0.05*y_axrange;
        y_axlim(2) = y_axlim(2) + 0.05*y_axrange;
        ylim(y_axlim)
    end