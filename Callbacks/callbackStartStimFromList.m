
function callbackStartStimFromList(source,event)
    
    global System
    if isfield (System, 'electrode_list')
        System.stimlistlength=length(System.electrode_list);
        set(findobj(source.Parent.Children,'Tag','stimbtn'),'BackgroundColor','red','Enable','Off');
    else
        disp('no list selected');
    
    end
end