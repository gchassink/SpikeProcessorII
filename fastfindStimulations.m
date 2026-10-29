%% function locations=fastfindStimulations(Data,Mindist,Minpeaksize)
% A fast and simpler version of findpeaks().
% The function returns the indexes of peak values in 'Data'.
% Data = input data in which the peaks have to be found. Must be a row vector
% Mindist = minimal distance between each peak.
% Minpeaksize = The minimal height of a peak
function locations=fastfindStimulations(Data,Mindist,Minpeaksize)

    Data=diff(Data);% stimulation shape is not a single peak, but a blok pulse, to make sure only 1 detection is done,take the diff of the signal
    
    %plot(Data);hold on
    Minpeaksize=-100;
    locs=find(Data(2:end-1) < Data(1:end-2) & Data(2:end-1) < Data(3:end) & Data(2:end-1)<=Minpeaksize);
    % it will find all peaks higher than than threshold as long as peak+1 is lower than peak 
    % this will be all peaks in loopsize + 6ms pre loop
    % how is double reading prevented?
    %dy=diff(Data);
    if ~isempty(locs)
        d=diff(locs);
        locations=locs([1,find(d>=Mindist)+1]); %location is actual -1
        % remove peaks that are too close together
    else
        locations=[];
    end
    
end