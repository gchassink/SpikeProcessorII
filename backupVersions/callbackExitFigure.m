function callbackExitFigure(source,event)
    global exitfigure
    exitfigure = 1;
    %set(findobj(source.Parent.Children,'Tag','SetFilterbtn'),'Enable','Off');
    set(findobj(source.Parent.Children,'Tag','Donebtn'),'Enable','Off');
end