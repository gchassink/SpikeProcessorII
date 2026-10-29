function [ normalWaveformIndices, artifactWaveformIndices, cor_Ts, cor_Us, artifactFlag] = detect_artifacts( electrodes, timestamps, waveforms, fs )
    %ARTIFACTDETECTION Detects artifacts in the recorded spikes and returns a
    %list of non artifact indices.
    %   Will detect if there are artefacts in the spikes detected. Will check
    %   if there is only 1 spike in a +- 1ms window, if there is no secondary
    %   spike of 90% amplitude of the original and if there no spike of 50%
    %   amplitude of the original. It also removes and duplicate spikes found.
    %
    %   Returns a list of indices that are not artifacts
    %   Displays a list of types of artifact in percent
    

    cor_Ts=timestamps;
    cor_Us=waveforms;
    % Number of spikes
    numSpikes = length(timestamps);

    % List of all keep to keep
    keep = ones(numSpikes, 1);
    reverseStr = '';

    
    SampleRes=double(fs)/1000;% data points per ms
    MaxShift=double(floor(SampleRes));% was 3000 25000/ 1ms=150/6 
    
     % make artifact detection MEAsystem universal
    if length(unique(electrodes))<62 
        MEAtype=60
    else
        MEAtype=288
    end
    
    %% Peak is not tight in a constant place with MCS software
     % Go over each spike, and shift spike to 2 ms point
    for i=1:numSpikes
        percentDone= 100 * i/numSpikes;
        if rem (percentDone,floor(percentDone))<0.001
            msg = sprintf('checking artifacts percent done = %3.1f', percentDone);
            fprintf([reverseStr, msg]);
            reverseStr= repmat(sprintf('\b'),1, length(msg));
        end

        
        if electrodes(i) <= MEAtype % If it is an stimulation timestamp, never identify as artifact
            
            % Get waveform
            waveform = waveforms(i, :);

            PeakLoc=(2 * round(fs/1000)) +1;
            
           
            [~,I]=max(abs(waveform(PeakLoc-MaxShift:PeakLoc+MaxShift)));
            Shift=-MaxShift-1+double(I);
            PeakLoc=PeakLoc+Shift;
            % correct timestamp
            cor_Ts(i)=cor_Ts(i)+Shift; 
            % shift spike to 2 ms point
            if Shift>0
                cor_Us(i,:)=[waveform(Shift+1:end) waveform(1:Shift)];
                
            elseif Shift<0
                cor_Us(i,:)=[waveform(end+Shift+1:end) waveform(1:end+Shift)];
                
            end
        end
    end

    %% determine types of artefacts
    % Check if the waveform holds true for the following thresholds
    % 1. There should be no peak in either negative or positive direction
    %   that is equal or larger than peak
    % 2. There should be no peak in a +- 1ms window of 90% strength
    % 3. There should be no peak in a +- 1ms window of 50% 
    % 4. There should not be two identical timestamps
    % 5. There should not be a peak thats width is smaller than 2/16 ms at 50% of original peak.

    waveforms= cor_Us; % work with spiketime corrected waveform
    
    PeakLoc=(2 * round(fs/1000)) +1;
    % unit is ms
    Range1=PeakLoc+[-round(SampleRes)+1:round(SampleRes)]; % +- 1 ms including peak
    Range2=PeakLoc+[-round(0.5 * SampleRes)+1:-round(0.12*SampleRes) round(0.12*SampleRes):round( 0.5 * SampleRes)]; % excluding +-0.12 ms
    Range3=PeakLoc+[-round(0.6 * SampleRes)+1:-round(0.5*SampleRes) round(0.5*SampleRes):round( 0.6 * SampleRes)];% round(fs/4000):round(fs/3000)]; 
    Range4=PeakLoc-ceil(0.08*SampleRes):PeakLoc+ceil(0.08*SampleRes);
    Peaks = double(waveforms(:,PeakLoc));
     
    
    % 1. There should be no peak in either negative or positive direction
    OneMax=abs(waveforms(:,Range1))>abs(Peaks);
    keep(sum(OneMax,2)>1)=-1;
    
    % 2. There should be no peak in a +- 0.5 ms window of 90% strength
    NinetyPercent=sign(Peaks) .* double(waveforms(:,Range2)) > double(sign(Peaks).*(0.9 * Peaks)); 
    keep(sum(NinetyPercent,2)>0)=-2;
    
    % 3. There should be no peak in a +- 1ms window of 50% strength
        % gerco 22-8-2018: must be more steep before the peak compared to
        % after so maybe 0.5ms pre- till 1ms post-peak
    FiftyPercent=sign(Peaks) .* double(waveforms(:,Range3)) > double(sign(Peaks).*(0.5 * Peaks)); 
    keep(sum(FiftyPercent,2)>0)=-3;
    
    % 4. There should not be more than two identicalTimestamps
    if length(unique(cor_Ts))>1
    [n, bin] = histcounts(cor_Ts, unique(cor_Ts));
    identicalTimestamps = find(n > MEAtype/30);
    index    = find(ismember(cor_Ts, bin(identicalTimestamps))); %updated by Marieke @25-08-2020; (ismember(bin,multiple) does not find correct Ts)
    keep(index) = -4;
    else
        if length(cor_Ts)>1 & length(cor_Ts) > MEAtype/30
            
            keep(1:length(cor_Ts)) = -4;
        end
    end

    
   
    % 5. There should not be a peak thats width is smaller than 2/16 ms at 50%
    % of original peak.
    singlespike=sign(Peaks) .* double(waveforms(:,Range4)) > double(sign(Peaks).*(0.25 * Peaks)); 
    keep(sum(singlespike,2)<3)=-5;
   
    % ignore artifacts in additional stimulation channel 
    keep(keep~=1 & electrodes>MEAtype)=1; 



    %% Results


    normalWaveformIndices = find(keep == 1);
    artifactWaveformIndices = find(keep ~= 1);
    artifactFlag = keep ;

    disp(['Artifacts detected (' num2str(100*length(artifactWaveformIndices)/numSpikes) '%) ']);
    disp(['Flag-1, There should be no peak in either negative or positive direction (' num2str(100*length(find(keep==-1))/numSpikes) '%) ']);
    disp(['Flag-2, There should be no peak in a +- 1ms window of 90% strength (' num2str(100*length(find(keep==-2))/numSpikes) '%) ']);
    disp(['Flag-3, There should be no peak in a +- 1ms window of 50% strength(' num2str(100*length(find(keep==-3))/numSpikes) '%) ']);
    disp(['Flag-4, There should not be more than two identicalTimestamps (' num2str(100*length(find(keep==-4))/numSpikes) '%) ']);
    disp(['Flag-5, There should not be a peak thats width is smaller than 2/16 ms (' num2str(100*length(find(keep==-5))/numSpikes) '%) ']);
   
    disp(['too noisy (' num2str(100*length(find(keep==-6))/numSpikes) '%) ']);
    disp(['positive amplitude (' num2str(100*length(find(keep==-7))/numSpikes) '%) ']);

    %% bug tracking (uncomment)
    flag=[-1, -2, -3, -5];
   
    if 100*length(find(keep==flag))/numSpikes>101 % in percent. change to do bugtracking
        for i=1:numSpikes
            if ismember(keep(i),flag) && i>40
                EL=electrodes(i);
                plotindex=(i-31)+find(electrodes(i-30:i+30)==EL);
                close all; figure;
                plot(waveforms(plotindex,:)');hold on;
                plot(1:size (waveforms,2),waveforms(i,:),'LineWidth',2); hold on;
                plot(Range2,(0.9 * Peaks(i)),'.'); hold on;
                plot(Range3,(0.5 * Peaks(i)),'.'); hold off;
                title (['keep is ' num2str(keep(i)) ' ElNo =' num2str(electrodes(i)) ' Ts =', num2str(cor_Ts(i))]);
                 pause
            end
        end
    end

end