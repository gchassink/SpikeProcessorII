function callbackSetSuperDelay(source,event)
    %% set inter repeats interval 
    global  System
    switch source.Value
        case 1
            System.SuperDelay=10;
        case 2
            System.SuperDelay=30;
        case 3
            System.SuperDelay=60;
        case 4
            System.SuperDelay=60*30;
        case 5
            System.SuperDelay=60*60;
        case 6
            System.SuperDelay=60*60*6;
    end
    
end