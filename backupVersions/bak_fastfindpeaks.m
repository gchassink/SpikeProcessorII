%% function locations=fastfindpeaks(Data,Mindist,Minpeaksize)
% A fast and simpler version of findpeaks().
% The function returns the indexes of peak values in 'Data'.
% Data = input data in which the peaks have to be found. Must be a row vector
% Mindist = minimal distance between each peak.
% Minpeaksize = The minimal height of a peak
function locations=fastfindpeaks(Data,Mindist,Minpeaksize)
    
    locs=find(Data(2:end-1) >= Data(1:end-2) & Data(2:end-1) >= Data(3:end) & Data(2:end-1)>=Minpeaksize);
    
    %dy=diff(Data);
    if ~isempty(locs)
        d=diff(locs);
        locations=locs([1,find(d>=Mindist)+1]); %location is actual -1
    else
        locations=[];
    end
    
end