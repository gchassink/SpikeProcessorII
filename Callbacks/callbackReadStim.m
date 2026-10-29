function callbackReadStim(source,event)
    %% Select stimulation pattern from file 
    %  list interstimulus intervals in seconds)
    global  System FileInfo
    [System.stimfile, System.stimpath]=uigetfile('*.txt','Select a file with interstimulus intervals in seconds (ISI)');
    if System.stimfile~=0
        fileID = fopen([System.stimpath System.stimfile],'r');
        formatSpec = '%f';
        FileInfo.fileISI=fscanf(fileID,formatSpec);
        answer = inputdlg('Enter space-separated sequence of electrode(s) to stimulate:', 'Electrode', [1 50]);
        System.electrode_list = int32(str2num(answer{1}));
        
        set(findobj(source.Parent.Children,'Tag','StimAll'),'Enable','Off');
        for i=1:8
            for ii=1:8
                index=i*10+ii;
                if index ~= 11 && index ~= 18 && index ~= 81 && index ~= 88 && index ~= 15
                    set(findobj(source.Parent.Children,'Tag',['stim' num2str(index)]),'Enable','Off','BackgroundColor',[0.7, 0.7, 0.7]);
                    
                end
            end
        end
        set(findobj(source.Parent.Children,'Tag','SetStimFrequency'),'Enable','Off');
        %set(findobj(source.Parent.Children,'Tag','SetStimRepeats'),'Enable','Off');
        %set(findobj(source.Parent.Children,'Tag','SetStimDelay'),'Enable','Off');
        %set(findobj(source.Parent.Children,'Tag','SetStimDurNeg'),'Enable','Off');
        %set(findobj(source.Parent.Children,'Tag','SetStimDurPos'),'Enable','Off');
        %set(findobj(source.Parent.Children,'Tag','SetStimType'),'Enable','Off');
        %StimTable.ColumnEditable= [false false];
               
        
    end

end