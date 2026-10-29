function callbackElectrodeButtons(source,event)
    %% callbackElectrodeButtons(source,event)
    % show selected channel
    global System FileInfo
    if System.last_channel>0
         set(findobj(source.Parent.Children,'Tag', num2str(System.last_channel)),'ForegroundColor','white','FontWeight', 'normal');
    end
    System.channeldisp = source.Value;
    set (source,'ForegroundColor','red','FontWeight', 'bold');
    System.last_channel=FileInfo.channelorder(System.channeldisp);
end