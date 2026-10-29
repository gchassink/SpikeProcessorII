function callbackSetStimRepeats(source,event)
    %% set number of repetitions per electrode
    global  System
    str=get(source,'String');
    if isempty(str2num(str))
        set(source,'string','3');
        warndlg('Input must be numerical');
    end
    System.StimRepeats=str2num(str);
end