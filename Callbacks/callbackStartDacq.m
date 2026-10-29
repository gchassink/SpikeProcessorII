function  callbackStartDacq(source,event)
    %% start reading from device
    global System FileInfo Figures
    System.dacqstatus=source.Value;
   
    if System.dacqstatus>=2 
        if FileInfo.fname~=""
            set(findobj(source.Parent.Children,'Tag','Recbtn'),'Enable','On');
            set(findobj(source.Parent.Children,'Tag','Rawbtn'),'Enable','On');
        end
    set(source,'String','Stop Dacq','Max',1);
    
    set( findobj(Figures.fig_init.Children,'Tag','SetFilterbtn'),'Enable','Off'); 
    end
    if System.dacqstatus==1
        set(findobj(source.Parent.Children,'Tag','Fnamefld'),'Enable','On');
        set(findobj(source.Parent.Children,'Tag','Recbtn'),'Enable','Off',...
            'string','Start Recording','Max',3);
        set(findobj(source.Parent.Children,'Tag','Rawbtn'),'Enable','Off',...
            'string','Record Raw','Max',3);
        set(source,'String','Start Dacq','Max',2);
        delete(timerfind); % kill possible stimulation timers from previous starts
        set( findobj(Figures.fig_init.Children,'Tag','SetFilterbtn'),'Enable','On');
        if  isfile ('recording_on.mat') % true if currently writing data to file
            mat = matfile([FileInfo.Name '.mat'],'Writable',true);
            time=clock;
            FileInfo.EndTime=[int2str(time(4)),':',int2str(time(5)),':',int2str(time(6))];
            mat.FileInfo=FileInfo;
        end
    end

end