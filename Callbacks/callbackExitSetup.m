function callbackExitSetup(source,event)
    global System
    System.exitSetup = 1;
    %set(findobj(source.Parent.Children,'Tag','SetFilterbtn'),'Enable','Off');
    set(findobj(source.Parent.Children,'Tag','Donebtn'),'Enable','Off');
    set(findobj(source.Parent.Children,'Tag','SetSampleRatebtn'),'Enable','Off');
    
end