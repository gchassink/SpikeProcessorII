%% update ground status
 global System FileInfo Devices  ;
for i=1:length(FileInfo.channelorder)
        electrode=i-1;
        ElectrodeStatus=Devices.stg.GetElectrodeMode(electrode);% GetElectrodeDacMux( electrode,0);
        if  ElectrodeStatus==3
            FileInfo.Ground(i)=1 ;
            set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor',[.7 .7 .7]);
        else 
            FileInfo.Ground(i)=0 ;
            set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor','green');
        end
    end