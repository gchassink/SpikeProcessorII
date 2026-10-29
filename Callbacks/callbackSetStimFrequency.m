function callbackSetStimFrequency(source,event)
    %% set stimulation frequency
    global  System
    str=get(source,'String');
    if isempty(str2num(str))
        set(source,'string','0.1');
        warndlg('Input must be numerical');
    end
    System.StimFrequency=str2num(str);
end