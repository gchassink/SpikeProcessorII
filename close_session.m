global  Devices test  System FileInfo Figures Tmr 
if  isfile ('recording_on.mat') % true if currently writing data to file
        mat = matfile([FileInfo.Name '.mat'],'Writable',true);
         time=clock;
         FileInfo.EndTime=[int2str(time(4)),':',int2str(time(5)),':',int2str(time(6))];
        mat.FileInfo=FileInfo;
        if System.criticalError==0 % no errors
        recordingIsOff;
        else
            mea_cleanup(Devices)
        end
end