function callbackSetStimDurNeg(source,event)
    %% set duration of the negative flank of the stimulation (uS)
    global  System
    str=get(source,'String');
    if isempty(str2num(str))
        set(source,'string','200');
        warndlg('Input must be numerical');
    end
    System.StimDuration(1)=int32(str2num(str));
end
