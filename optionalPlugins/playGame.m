 %%playGame
 % make sure you select right electrodes below!

 % System.rasterlayout=[12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87,88];
 global test FileInfo System Tmr
 if isfield(FileInfo,'StimOrderbase') && ~isempty(Cs)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % select electrodes to be checked
     reacted=find(Cs==71 | Cs==72 | Cs==85 | Cs==75);
     notReacted= find(Cs==28 | Cs==38 | Cs==48 | Cs==57);
 % take indices from second before stimulation to check normal activity of these electrodes    
     baselineReacted=find(CsLast==71 | CsLast==72 | CsLast==85 | CsLast==75); 
     baselineNotReacted= find(CsLast==28 | CsLast==38 | CsLast==48 | CsLast==57);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

 % start the countdown
%   length(FileInfo.countdown) 
%   disp(System.StimIndex)
%   disp(System.ThisStim)
     if System.StimIndex<= length(FileInfo.countdown)+1 % if stimindex > 1 there has been a stimulation
         if System.ThisStim~=0
             % check if upon stimulation ratio of the group of reaction vs
             % non-reaction indeed becomes more positive
             % hier klopt nog iets niet: beide groepen zijn niet per
             % definitie gelijk in activiteit. corrigeren is niet makkelijk
             % na stimulatie is de kans groot dat er extra activiteit is in
             % groep A en groep B zou al een grotere basis activiteit
             % kunnen hebben. hoe dit goed te normaliseren? 
             % A_stim A_rust >0
             % B-stim B_rust <0
             % maar hoe bepaal je A en B rust? neem Activiteit van zelfde
             % groep 50 200 ms voor eerste stimulatie
% convert Ts, TsLast and last stimulation to ms
             TsIn_ms=(Ts ) / (double(FileInfo.Samplerate)/1000); 
             %TsLastIn_ms=TsLast / (double(FileInfo.Samplerate)/1000); 
             lastStimIn_ms=double(System.ThisStim) / (double(FileInfo.Samplerate)/1000);
             deltaTs=TsIn_ms-lastStimIn_ms;
             %deltaTsLast=TsLastIn_ms-lastStimIn_ms-1000;%extra -1000 since these are 1 second before
             reactedAtTheRightTime=find( deltaTs(reacted)> FileInfo.minimumReactionTime & deltaTs(reacted)<FileInfo.maximumReactionTime);% value in ms
             keptQuietAtTheRightTime=find( deltaTs(notReacted)> FileInfo.minimumReactionTime & deltaTs(notReacted)<FileInfo.maximumReactionTime);% should be small
             reactionwindow= double( FileInfo.maximumReactionTime-FileInfo.minimumReactionTime)/1000;%convert to 1 second
             moreActive=(double(length(reactedAtTheRightTime))/reactionwindow)-length(baselineReacted);
             lessActive=(double(length(keptQuietAtTheRightTime))/reactionwindow)-length(baselineNotReacted);
             if moreActive>0 || lessActive<0 % very gentle selection criteria
                 disp(['Yes, I reacted! moreActive :' num2str(moreActive) ' lessActive :' num2str(lessActive)]);
                 
                 stop(Tmr);
                 %  clear Tmr;
                 delete(Tmr);
                 System.ThisStim=0;
                 FileInfo.score(FileInfo.iterations,1)=moreActive;
                 FileInfo.score(FileInfo.iterations,2)=lessActive;
                 FileInfo.bonus=double(60);% seconde bonus
                 disp([  num2str(FileInfo.score(FileInfo.iterations)) ' out of '  num2str(FileInfo.iterations-1)  ] );
                 test=1; % prepare for the next iteration
             else
                 disp(['No, Not what I wanted. moreActive :' num2str(moreActive) ' lessActive :' num2str(lessActive)]);
                               
                 System.ThisStim=0;
                 FileInfo.score(FileInfo.iterations,1)=moreActive;
                 FileInfo.score(FileInfo.iterations,2)=lessActive;
                 FileInfo.bonus=double(60);% seconde bonus
                 disp([  num2str(FileInfo.score(FileInfo.iterations)) ' out of '  num2str(FileInfo.iterations-1)  ] );
                 %test=1; % prepare for the next iteration
             end

         end
     else
         if System.StimIndex==size(FileInfo.StimOrder,1) % time is up
             disp('I need to learn more');
             FileInfo.bonus=double(5);% seconde bonus
             
             System.ThisStim=0;
             test=1; % prepare for the next iteration
         end

     end
     if FileInfo.iterations>100
         disp('100 iterations done')
         figure; plot((FileInfo.score));
         pause(0.1);drawnow
        System.exit=1;


     end
 end