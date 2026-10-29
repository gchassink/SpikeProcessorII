function [ normalWaveformIndices, artifactWaveformIndices, cor_Ts, cor_Us, artifactFlag, keep] = detect_artifacts_fast( electrodes, timestamps, waveforms, fs )
    %   ARTIFACTDETECTION Detects artifacts in the recorded spikes and returns a
    %   list of non artifact indices.
    %   Will detect if there are artefacts in the spikes detected. Will check
    %   if there is only 1 spike in a +- 1ms window, if there is no secondary
    %   spike of 90% amplitude of the original and if there no spike of 50%
    %   amplitude of the original. It also removes and duplicate spikes found.
    %
    %   Returns a list of indices that are not artifacts
    %   Displays a list of types of artifact in percent
    %
    % almost completely array based, so it faster in handeling big files
    cor_Ts=timestamps;
    cor_Us=waveforms;
    % Number of spikes
    numSpikes = length(timestamps);

    % List of all keep to keep
    keep = ones(numSpikes, 1);
    reverseStr = '';

    %% Go over each spike, and shift spike to 2 ms point
    SampleRes=fs/1000;% data points per ms
    MaxShift=floor(SampleRes);% was 3000 25000/ 1ms=150/6 

    for i=1:numSpikes
        percentDone= 100 * i/numSpikes;
        if rem (percentDone,floor(percentDone))<0.001
            msg = sprintf('checking artifacts percent done = %3.1f', percentDone);
            fprintf([reverseStr, msg]);
            reverseStr= repmat(sprintf('\b'),1, length(msg));
        end
      
        
        if electrodes(i) < 60 % If it is an stimulation timestamp, never identify as artifact
            
            % Get waveform
            waveform = waveforms(i, :);

            PeakLoc=(2 * round(fs/1000)) +1;
            % Piek ligt bij MCS software niet strak op constante plek

            [~,I]=max(abs(waveform(PeakLoc-MaxShift:PeakLoc+MaxShift)));
            Shift=-MaxShift-1+I;
            %PeakLoc=PeakLoc+Shift;
            cor_Ts(i)=cor_Ts(i)+Shift;% Timestamp aanpassen 
            %@ joost: maar moet dat wel? is de timestamp op de werkelijke piek gebaseerd of op het begin van de opgeslagen episode?
            if Shift>0
                cor_Us(i,:)=[waveform(Shift+1:end) waveform(1:Shift)];
                %figure; plot (waveform);hold on; plot (cor_Us(i,:));
            elseif Shift<0
                cor_Us(i,:)=[waveform(end+Shift+1:end) waveform(1:end+Shift)];
                %figure; plot (waveform);hold on; plot (cor_Us(i,:));
            end;
        end
    end

    %% determine types of artefacts
    % Check if the waveform holds true for the following thresholds
    % 1. There should be no peak in either negative or positive direction
    %   that is equal or larger than peak
    % 2. There should be no peak in a +- 1ms window of 90% strength
    % 3. There should be no peak in a +- 1ms window of 50% 
        % gerco 22-8-2018: must be more steep before the peak compared to after so
        % 0.5ms pre- till 1ms post-peak
    % 4. There should not be two identical timestamps
    % 5. There should not be a peak thats width is smaller than 2/16 ms at 50%
    % of original peak.

    waveforms= cor_Us; % work with spiketime corrected waveform
    noise=rms(waveforms(:,1:floor(size(waveforms,2)*(1.8/6))),2);
    PeakLoc=(2 * round(fs/1000)) +1;
    
    Range1=-round(SampleRes)+1:round(SampleRes);
    Range2=[-round(1 * SampleRes)+1:-round(0.12*SampleRes) round(0.12*SampleRes):round( 1 * SampleRes)]; %getallen invoeren in ms
    Range3=[-round(0.25 * SampleRes)+1:-round(0.125*SampleRes)];% round(fs/4000):round(fs/3000)]; 
    Peaks = double(waveforms(:,PeakLoc));
    
    
    
    OneMax=abs(waveforms)>abs(Peaks);
    keep(find(sum(OneMax,2)>0))=-1;

    NinetyPercent=sign(Peaks) .* double(waveforms(:,PeakLoc+Range2)) > double(sign(Peaks).*(0.9 * Peaks)); %waveforms(:,PeakLoc+Range2)<(0.9*peak);
    keep(find(sum(NinetyPercent,2)>0))=-2;
  
    % Fiftypercent selection works only at low noise
%     keep(abs(Peaks)<6*abs(noise))=-6;
    
%     FiftyPercent=sign(Peaks) .* double(waveforms(:,PeakLoc+Range3)) > double(sign(Peaks).*(0.33 * Peaks)); %waveforms(:,PeakLoc+Range2)<(0.5*peak);
%     keep(find(sum(FiftyPercent,2)>0))=-3;

    SingleSpike=sign(Peaks) .* double(waveforms(:,PeakLoc-floor(0.08*SampleRes):PeakLoc+floor(0.08*SampleRes))) > double(sign(Peaks).*(0.25 * Peaks)); % een detectie mag niet uit een enkel sample bestaan (toegevoegd 19/3/2018, joost)
    keep(find(sum(SingleSpike,2)<3))=-5;

    [n, bin] = histcounts(cor_Ts, unique(cor_Ts));
    multiple = find(n > 3);
    index    = find(ismember(bin, multiple));
    keep(index) = -4;






    %% Results


    normalWaveformIndices = find(keep == 1);
    artifactWaveformIndices = find(keep ~= 1);
    artifactFlag = (keep ~= 1);

    disp(['Artifacts detected (' num2str(100*length(artifactWaveformIndices)/numSpikes) '%) ']);
    disp(['bigger peaks in vicinity (' num2str(100*length(find(keep==-1))/numSpikes) '%) ']);
    disp(['not sharp enough tip(' num2str(100*length(find(keep==-2))/numSpikes) '%) ']);
    disp(['not sharp enough stem(' num2str(100*length(find(keep==-3))/numSpikes) '%) ']);
    disp(['too sharp (' num2str(100*length(find(keep==-5))/numSpikes) '%) ']);
    disp(['too many electrodes (' num2str(100*length(find(keep==-4))/numSpikes) '%) ']);
    disp(['too noisy (' num2str(100*length(find(keep==-6))/numSpikes) '%) ']);

    %% bug tracking (uncomment)
    if 100*length(find(keep~=0))/numSpikes>0 % in percent. change to do bugtracking
        for i=1:numSpikes
            if keep(i)~=0 && i>40
                EL=electrodes(i);
                plotindex=(i-31)+find(electrodes(i-30:i+30)==EL);
                close all; figure;
                plot(waveforms(plotindex,:)');hold on;
                plot(1:size (waveforms,2),waveforms(i,:),'LineWidth',2); hold on;
                plot(PeakLoc+Range2,(0.9 * Peaks(i)),'.'); hold on;
                plot(PeakLoc+Range3,(0.33 * Peaks(i)),'.'); hold off;
                title (['keep is ' num2str(keep(i)) ' ElNo =' num2str(electrodes(i)) ' Ts =', num2str(cor_Ts(i))]);
                 pause
            end
        end
    end

end