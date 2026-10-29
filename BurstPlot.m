function burstIndex=BurstPlot(burstIndex,TsBuffered,CsBuffered,Samplerate,RecordingTime,channeldisp,channelorder,Ras)
  global System
hold on
msPerSample= double(1000)/(double(Samplerate));
edges=1:25:1000;% for histogram with binsize 25 ms
wellSize=System.WellSize; % can range from 12 to 60 electrodes
wells=1:wellSize:System.ChannelsUsed; % can range from 24 to 1
timeFrame=300;% seconds??
Ras_mean=mean(Ras ,2);
meanFiringRatePerChannel=(Ras_mean(1:3:end));
    if isempty(burstIndex)
        
        burstIndex=zeros((length(wells)),length(edges)*timeFrame);
    end

%figure('units','normalized','outerposition',[0 0 1 1]);
            for i=1:length(channelorder) % check all electrodes
                CsInd=find(CsBuffered==channelorder(i));% find all events in a particular electrode(channel)
                sumChannel(i)=length(CsInd);
                electrodeTotal=msPerSample * (TsBuffered(CsInd)-RecordingTime); % Bring Ts buffered back to a 1000 ms period
                %histPerElectrode(i,:)=histcounts(electrodeTotal,edges); % make histogram(s) with bin size 25 ms
                histPerElectrode(i,:)=smoothdata(histcounts(electrodeTotal,edges),'movmean',5)*100*(meanFiringRatePerChannel(i)); % make activity weighted histogram(s) with bin size 25 ms
                 
            end 
            for i=1:(System.ChannelsUsed/wellSize) % check all wells
                sumWell(i)=mean(sumChannel(wells(i):wells(i)+wellSize-1));% sum all electrode events in a particular well= 1 sec average
                meanHistPerWell(i,:)=mean(histPerElectrode(wells(i):wells(i)+wellSize-1,:),1);%/(wellSize); 
                % take the mean and normalize for  mean activity of electrodes in that well and its well size
                
                
            end

%                 burstIndex(:,1:(length(edges)-1))=[];
%                 burstIndex(:,(timeFrame-1)*(length(edges)-1)+1:timeFrame*(length(edges)-1))=meanHistPerWell;

            %sData=smoothdata(meanHistPerWell(ceil(channeldisp/wellSize),:),'movmean',5)*1000;
            sData=meanHistPerWell(ceil(channeldisp/wellSize),:);
          plot(25:25:975,sData);
          %[pks,locs,w,p] = findpeaks(sData, 'MinPeakWidth', 2);
          %[TF,S1,S2] = ischange(sData,'mean','Threshold',250);
          thresLocs=sData>25;
          hold on
%           plot(25:25:9750,(thresLocs)*500); 
%           hold on
          %plot(25:25:975,(smoothdata(meanHistPerWell(ceil(channeldisp/wellSize),:),'movmean',5))/sumWell(ceil(channeldisp/wellSize))*10000); 
          startBurst=find(diff(thresLocs)>=1);
          endBurst=find(diff(thresLocs)<=-1);
          if ~isempty(startBurst)
          xline(startBurst*25, 'color', 'b' );
          
          hold on
          end
          if ~isempty(endBurst)
              xline(endBurst*25, 'color', 'r');
          
            end
%          % ylim([-0.01 0.01]);
    hold off