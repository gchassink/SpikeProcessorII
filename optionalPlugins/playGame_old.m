 % System.rasterlayout=[12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87,88];
 global test FileInfo System Tmr
 if isfield(FileInfo,'StimOrderbase') && ~isempty(Cs)
 % select electrodes to be checked
     
     reacted=find(Cs==61 | Cs==71 | Cs==62 | Cs==72);
     notReacted= find(Cs==66 | Cs==77 | Cs==78 | Cs==87);

 % start the countdown
     if System.StimIndex< length(FileInfo.countdown)
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

             TsIn_ms=(Ts + FileInfo.RecordingTime) / (double(FileInfo.Samplerate)/1000); 
             lastStimIn_ms=double(System.ThisStim) / (double(FileInfo.Samplerate)/1000);
             deltaTs=TsIn_ms-lastStimIn_ms;
             reactedAtTheRightTime=find( deltaTs(reacted)> FileInfo.minimumReactionTime & deltaTs(reacted)<FileInfo.maximumReactionTime);% value in ms
             keptQuietAtTheRightTime=find( deltaTs(notReacted)> FileInfo.minimumReactionTime & deltaTs(notReacted)<FileInfo.maximumReactionTime);% should be small
            
             if double(length(reactedAtTheRightTime))/(1+double(length(keptQuietAtTheRightTime)))>1 %
                 disp(['Yes, I reacted on electrode(s)!!' num2str(unique(Cs(reacted(reactedAtTheRightTime))'))]);
                 
                 deltaTs(reacted)
                 deltaTs(notReacted)
                 stop(Tmr);
                 %  clear Tmr;
                 delete(Tmr);
                 System.ThisStim=0;
                 FileInfo.score(FileInfo.iterations)=FileInfo.score(FileInfo.iterations-1)+1;
                 FileInfo.bonus=double(60);% seconde bonus
                 disp([  num2str(FileInfo.score(FileInfo.iterations)) ' out of '  num2str(FileInfo.iterations-1)  ] );
                 test=1; % prepare for the next iteration
             end
         end
     else
         if System.StimIndex==size(FileInfo.StimOrder,1) % time is up
             disp('I need to learn more');
             FileInfo.bonus=double(5);% seconde bonus
             FileInfo.score(FileInfo.iterations)=FileInfo.score(FileInfo.iterations-1);
             disp([  num2str(FileInfo.score(FileInfo.iterations)) ' out of '  num2str(FileInfo.iterations-1)  ] );
             System.ThisStim=0;
             test=1; % prepare for the next iteration
         end

     end
 end