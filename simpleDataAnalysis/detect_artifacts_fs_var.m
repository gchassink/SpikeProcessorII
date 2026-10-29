function [ normalWaveformIndices, artifactWaveformIndices, artifactFlag ] = detect_artifacts_fs_var( electrodes, timestamps, waveforms, fs )
%ARTIFACTDETECTION Detects artifacts in the recorded spikes and returns a
%list of non artifact indices.
%   Will detect if there are artefacts in the spikes detected. Will check
%   if there is only 1 spike in a +- 1ms window, if there is no secondary
%   spike of 90% amplitude of the original and if there no spike of 50%
%   amplitude of the original. It also removes and duplicate spikes found.
%   
%   Returns a list of indices that are not artifacts

    % Number of spikes
    numSpikes = length(timestamps);

    % List of all keep to keep
    keep = ones(numSpikes, 1);

    % make artifact detection MEAsystem universal
    if length(unique(electrodes))<62 
        MEAtype=60
    else
        MEAtype=288
    end

    % Go over each spike, and inspect the waveform
    for i=1:numSpikes
        % If it is an stimulation timestamp, never identify as artifact
        if electrodes(i) == MEAtype
            continue;
        end
        
        % Get waveform
        waveform = waveforms(i, :);
        
        PeakLoc=(2 * round(fs/1000)) +1;
        % Peak is not tight in a constant place with MCS software
        MaxShift=round(fs/3000);
        [~,I]=max(abs(waveform(PeakLoc-MaxShift:PeakLoc+MaxShift)));
        PeakLoc=PeakLoc-MaxShift-1+I;
               
        
        Range1=-round(fs/1000)+1:round(fs/1000);
        Range2=[-round(fs/1000)+1:-3 3:round(fs/1000)];
        
        % Make peak negative
        % All peaks are aligned at position 33 of waveform if fs = 16 kHz
        % (old program)
        if waveform(PeakLoc ) > 0
            waveform = -waveform;
        end
        peak = double(waveform(PeakLoc));

        % Check if the waveform holds true for the following thresholds
        % 1. There should be no peak in either negative or positive direction
        %   that is equal or larger than peak
        % 2. There should be no peak in a +- 1ms window of 90% strength
        % 3. There should be no peak in a +- 1ms window of 50% strength
        % 4. There should not be two identical timestamps
        % 5. There should not be a peak thats width is smaller than 3/16 ms at 50%
        % of original peak.
        if sum(abs(waveform(PeakLoc+Range1)) > abs(peak)) >= 1
            keep(i) = -1;
        elseif sum(waveform(PeakLoc+Range2) < (0.9 * peak)) > 0
            keep(i) = -2;
        elseif sum(sign(peak)*waveform(PeakLoc-2:PeakLoc+2) > sign(peak)*(0.5 * peak)) < 3 % een detectie mag niet uit een enkel sample bestaan (toegevoegd 19/3/2018, joost)
            keep(i) = -5;
        elseif sum(waveform([18:25 42:49]) < (0.5 * peak)) > 0 
            keep(i) = -3;
        else
            if i == numSpikes
                continue;
            end
            
            Shift=-MaxShift-1+I; 
            timestamps(i)=timestamps(i)+Shift;
%             [n, bin] = histcounts(timestamps, unique(timestamps));
%             multiple = find(n > 3);
%             index    = find(ismember(bin, multiple));
%             keep(index) = -4;
%             index=find(timestamps==timestamps(i));
%             if length(index)>2 
%                 keep(index) = -4;
%             end
        end
    end
    
    
    % faster way to obtain 4th exclusion criteria (get rid of duplicates)
    [~,unique_ind] = unique(timestamps, 'stable'); % find indices that timestamps are unique
    duplicates_index = setdiff(1:numel(timestamps),unique_ind); % find the indices that duplicates exist
    keep(duplicates_index) = -4;
    
    normalWaveformIndices = find(keep == 1);
    artifactWaveformIndices = find(keep ~= 1);
    artifactFlag = keep;
    
    % Print the percentages of each exclusion criteria 
    fprintf('Artifacts removed because of exclusion criteria 1: %0.2f%% \n' ,(length(find(keep == -1))/numSpikes)*100);
    fprintf('Artifacts removed because of exclusion criteria 2: %0.2f%% \n', (length(find(keep == -2))/numSpikes)*100);
    fprintf('Artifacts removed because of exclusion criteria 3: %0.2f%% \n' ,(length(find(keep == -3))/numSpikes)*100) ;
    fprintf('Artifacts removed because of exclusion criteria 4: %0.2f%% \n' ,(length(find(keep == -4))/numSpikes)*100);
    fprintf('Artifacts removed because of exclusion criteria 5: %0.2f%% \n' ,(length(find(keep == -5))/numSpikes)*100);
    
    disp(['Artifacts detected in total (' num2str(100*length(artifactWaveformIndices)/numSpikes) '%) and removed.'])
end