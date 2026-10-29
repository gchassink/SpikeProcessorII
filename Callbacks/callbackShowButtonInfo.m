function callbackShowButtonInfo(source,event)
    %% show selected channel
    global System 
    System.indicatorSet(source.UserData)=source.Value;
    end