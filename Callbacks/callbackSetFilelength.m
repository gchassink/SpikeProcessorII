function callbackSetFilelength(source,event)
    %% set file length
    global FileInfo
    
    switch source.Value
        case 1
            FileInfo.filelength=3600;
        case 2
            FileInfo.filelength=600;
        case 3
            FileInfo.filelength=60;
        case 4
            FileInfo.filelength=3600*4;
    end
    
end