global Figures System FileInfo test Tmr

if System.stimlistlength>0 % check if a stimulation protocol must be started
    disp('start stimulate_from_list');
    stimulate_from_list; % to execute stimulus from list
    %stimulate_burst; % to execute a burst
end
if isfield(FileInfo, 'StimOrder') && System.StimIndex==1 && System.LastStim==0 % Only the first stimulation is initiated here. The subsequent ones are handled by th call back funtion
    [Tmr, System]=setFirstTimer(System, FileInfo); % setFirstTimer

   
    set( findobj(Figures.fig.Children,'Tag','chanstim'),'String',['Next stimulation in channel: ' num2str(FileInfo.StimOrder(System.StimIndex,2))]);
end

if length(CsStim)>=1%check if stimulations occured since the last cycle of which the possible responses are read out now
    
    if System.StimIndex==2
        %System.FirstStim=((TsStim(1)+double(FileInfo.RecordingTime))/double(FileInfo.Samplerate))-FileInfo.StimOrder(1,1) ;
        System.FirstStim=((TsStim(1))/double(FileInfo.Samplerate))-FileInfo.StimOrder(1,1) ;
        
    end
    System.ThisStim=TsStim(length(TsStim));
    
    if System.StimIndex>2 % for debugging purposes; check delays between stimulation set and actual stimulation time
        %StimPrecission=1000*( ( System.ThisStim/double(FileInfo.Samplerate)) - FileInfo.StimOrder(System.StimIndex-1,1)-System.FirstStim);
        StimPrecission=1000*( ( System.ThisStim/double(FileInfo.Samplerate)) - FileInfo.StimOrder(System.StimIndex-1,1));
        set( findobj(Figures.fig.Children,'Tag','stimprecission'),'String',['Stimulation precission (ms): ' num2str(StimPrecission) ]);
    end
    if System.StimIndex<=size(FileInfo.StimOrder,1)
        set( findobj(Figures.fig.Children,'Tag','chanstim'),'String',['Next stimulation in channel: ' num2str(FileInfo.StimOrder(System.StimIndex,2))]);
     
    end
    if System.StimIndex==size(FileInfo.StimOrder,1)
        set( findobj(Figures.fig.Children,'Tag','stimprecission'),'String',['Stimulation series finished']);
    end
end