function callbackSetSuperRepeats(source,event)
    %% set number of inter repeats 
    global  System
    str=get(source,'String');
    if isempty(str2num(str))
        set(source,'string','1');
        warndlg('Input must be numerical');
    end
    System.SuperRepeats=str2num(str);
end