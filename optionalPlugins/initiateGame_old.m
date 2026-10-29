%% intiateGame 
% Sets the conditions to stimulate a set electrode sequentialy with 1
% second interval and scores the activity in two other sets (defined in
% playGame). one set should become quiet whereas the otherset shoul become
% more active. the reward is silince (lack of input) the punishement is
% stimulation.
% for punishment electrodes not belonging to one th three defined groups
% should be selcted before starting the game.
% this works only if stimulus times are at the beginning of 1000 ms period AND if loopsize is set to 1000
% otherwise responses are 

% for reference System.rasterlayout=[12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87,88];
% 
function initiateGame
global test FileInfo System
    test=0; %to run only once per itteration

    
% set electrodes part of the clock
    FileInfo.countdown=[12];%,48,57,68];%82:87;
    if ~isfield(FileInfo,'StimOrderbase')
        FileInfo.bonus=double(300);
% load the punishment
        FileInfo.StimOrderbase=FileInfo.StimOrder; 
% scoreboard     
        FileInfo.iterations=1; FileInfo.score(1)=0; 
        FileInfo.minimumReactionTime=50;FileInfo.maximumReactionTime=200;% in ms
    end
    FileInfo.iterations= FileInfo.iterations+1;
    FileInfo.StimOrder=FileInfo.StimOrderbase;

% make the stimulation list for one iteration
    for i=1:length(FileInfo.countdown) 
        countdownStimOrder(i,1)=FileInfo.StimOrder(1,1)-(length(FileInfo.countdown*2)+8) +i*2; % time of stimmulation
        countdownStimOrder(i,2)=FileInfo.countdown(i); %itteration
        countdownStimOrder(i,3)=FileInfo.StimOrder(1,3); % voltages/currrents
        countdownStimOrder(i,4)=FileInfo.StimOrder(1,4);
    end
    
    FileInfo.StimOrder=[countdownStimOrder;FileInfo.StimOrder];
    
    FileInfo.StimOrder(:,1)=FileInfo.StimOrder(:,1)+(double(FileInfo.RecordingTime)/double(FileInfo.Samplerate)+ FileInfo.bonus);
    disp(['attempt ' num2str(FileInfo.iterations-1) ' starting @ ' num2str(FileInfo.StimOrder(1,1)) ' seconds' ]);
    System.StimIndex=1;
    System.LastStim=0;
end
