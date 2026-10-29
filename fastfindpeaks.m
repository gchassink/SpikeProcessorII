%% function locations=fastfindpeaks(Data,Mindist,Minpeaksize)
% A fast and simpler version of findpeaks().
% The function returns the indexes of peak values in 'Data'.
% Data = input data in which the peaks have to be found. Must be a row vector
% Mindist = minimal distance between each peak.
% Minpeaksize = The minimal height of a peak
% Version to detect in 2 D array of raw data
function [Cs, Ts]=fastfindpeaks(Data,Mindist,Minpeaksize)
    % is it a peak and is the found peak larger than the set threshold?
    % [T,C]=find(Data(2:end-1,:) >= Data(1:end-2,:) & Data(2:end-1,:) >= Data(3:end,:) & Data(2:end-1,:)>=Minpeaksize); %results in 1d matrix
    [C,T]=find(Data(:,2:end-1) >= Data(:,1:end-2) & Data(:,2:end-1) >= Data(:,3:end) & Data(:,2:end-1)>=Minpeaksize);
   
   % is the minimum distance between peaks not too close?
    if ~isempty(T)
        [C, idx]= sort(C);T=T(idx);% sort according to channel
        Ts=T(1);Cs=C(1); % always keep the first
        T_cumulative=T+((C-1)*size(Data,2)); %transform linear linearIndex = int32(sub2ind(size(data), C,T)) ;  
        d=diff(T_cumulative); 
        locations=find(d>=Mindist)+1;

        Ts=[Ts; T(locations)]; 
        Cs=[Cs; C(locations)]; 
        
    else
        Ts=[];Cs=[];
    end
    
end

% how to prevent that it reads peaks double?