function callbackGroundAllElectrodes(source,event)
    %% ground or re-activate all
    % there is need to repeat part of the stg programming code here since
    % calling ground or activate here would be much slower (accessing the
    % stimulator 288 times in stead of 1 time only
    global System Devices FileInfo  ;
    
    HeadStage=uint32(0);
    Devices.stg.SendStop(uint32(1)); 
    sideband = int32([bitsll(1, 8), bitsll(3, 8),0]);%[25,25,0];
    StimulusActive= int32([1,1,0]) ; 
    duration = uint64([20,20,20]); %minimum value
    amplitude= int32([-1, 1, 0 ]); %minimum value
    Bit0Time=uint32(40) ;% bit0 (blanking switch) activation duration prolongation in ?s (multiples of 20)
    Bit3Time=uint32(800); %bit3 (stimulation switch) activation duration prolongation in ?s
    Bit4Time=uint32(40); %bit4 (stimulus selection switch) activation duration prolongation in ?s
    
    if System.GroundAllElectrodes==0
        for i=1 : length(FileInfo.channelorder) 
            if FileInfo.channelorder(i) ~= 15 && FileInfo.channelorder(i) ~= 88 || length(FileInfo.channelorder) >70
                electrode=i-1;
                Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emManual);
                Devices.stg.SetElectrodeEnable( electrode, 0, true);
                %electrodeMode=Devices.stg.GetElectrodeMode(electrode) 
                Devices.stg.SetElectrodeDacMux( electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Ground);
                FileInfo.Ground(i)=1;
            set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor',[.7 .7 .7]);
            end
        end
       System.GroundAllElectrodes=1;
    else
        
        for i=1 : length(FileInfo.channelorder)
            if FileInfo.channelorder(i) ~= 15 && FileInfo.channelorder(i) ~= 88 || length(FileInfo.channelorder) >70
                    electrode=i-1;
                    Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emAutomatic);
                    Devices.stg.SetElectrodeEnable( electrode, 0, true);
                    % electrodeMode=Devices.stg.GetElectrodeMode(electrode) % for debugging
                    Devices.stg.SetElectrodeDacMux( electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Stg1);% (electrode, index=0, dac)
                    %activate_electrode(i, FileInfo.channelorder)
                    FileInfo.Ground(i)=0;
            set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor','green');
            
            end
        end
       System.GroundAllElectrodes=0;
        
    end
    Devices.stg.SetVoltageMode();
    Devices.stg.PrepareAndSendData(2*HeadStage, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);
    SidebandData = Devices.stg.Stimulus.CreateSideband(StimulusActive, sideband, duration, Bit0Time, Bit3Time, Bit4Time);  
    Devices.stg.PrepareAndSendData(2*HeadStage, SidebandData.Sideband, SidebandData.Duration, Mcs.Usb.STG_DestinationEnumNet.syncoutdata);
    Devices.stg.SetupTrigger(0, uint32(255), uint32(255), uint32(10) );
    % start the first trigger
    Devices.stg.SendStart(uint32(1));
    
end


               
