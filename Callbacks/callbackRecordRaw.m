function  callbackRecordRaw(source,event)
    %% set the raw record length
    global System
    switch source.Value
        case 1
            System.rawrecordlength =0;
        case 2
            System.rawrecordlength =5;% minutes
        case 3
            System.rawrecordlength =10;% minutes
        case 4
            System.rawrecordlength = 30;
        case 5
            System.rawrecordlength = 1e5; % very large to ensure always on 
    end
    %System.rawrecordlength=source.Value;
end
