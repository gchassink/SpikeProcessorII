%% [Tmr, System]=firstStimulation(fig, System)
% MATLAB timer functions are not that precise.
% Use stimulate_repeatdly for more accurate timing
function [Tmr, System]=setFirstTimer(System, FileInfo)
      %stop(timerfind);
      delete(timerfind);
      Tmr = timer;
      Tmr.ExecutionMode = 'single';
      Tmr.TimerFcn = {@callbackStimulationTimer,System.StimIndex};%,
        


        if ~isfield(System, 'stimStart')
            System.stimStart=datetime;
        end
            System.stimEventTime=datetime;
            
        prevstim=round(seconds(diff([System.stimStart, System.stimEventTime])),3);
        
        nextstim=round(double(FileInfo.StimOrder(System.StimIndex,1)),3);
       
        delay=round(nextstim-prevstim,3);
        Tmr.StartDelay=delay ;
      %Tmr.StartDelay=round(double(FileInfo.StimOrder(System.StimIndex,1)),3); %delay in seconds based on stimorder, 0.001 second precission 
      %disp(['first timer set, startdelay = ' num2str(Tmr.StartDelay)] )
      %Tmr.UserData=System.StimIndex;
      start(Tmr); 
      %System.stimStart=datetime;
      System.LastStim=1;
      
end