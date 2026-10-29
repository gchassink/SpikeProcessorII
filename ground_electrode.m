%% ground_electrode( channeldisp, channelorder)
% grounds electrode 
function ground_electrode( channeldisp, channelorder)
           global Devices
           HeadStage=uint32(0);
           electrode=channeldisp-1;% MCS=0:59, matlab=1:60
            if Devices.devicelist.Count == 0
                 Msgbox('No MEA USB Device connected!', 'Error Connecting To Device', 'error');
            end
           
            if Devices.status == 0
                Devices.stg.SendStop(uint32(1)); %Devices.stg.Disconnect(); % ,1)
                sideband = int32([bitsll(1, 8), bitsll(3, 8),0]);%[25,25,0];
                StimulusActive= int32([1,1,0]) ;
                
                duration = uint64([20,20,20]); %minimum
                amplitude= int32([-1, 1, 0 ]); %minimum
                Bit0Time=uint32(40) ;% bit0 (blanking switch) activation duration prolongation in ?s (multiples of 20)
                Bit3Time=uint32(800); %bit3 (stimulation switch) activation duration prolongation in ?s
                Bit4Time=uint32(40); %bit4 (stimulus selection switch) activation duration prolongation in ?s
                
                Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emManual);
%                 for i=0:59%find(channelorder==32)-1
%                         Devices.stg.SetElectrodeEnable( i, 0, false);
%                         Devices.stg.SetEnableAmplifierProtectionSwitch( i, true);
%                         Devices.stg.SetBlankingEnable( i, true);
%                 end
                Devices.stg.SetElectrodeEnable( electrode, 0, true);
                %electrodeMode=Devices.stg.GetElectrodeMode(electrode) 
                Devices.stg.SetElectrodeDacMux( electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Ground);% (electrode, index=0, dac)
                % use voltage stimulation
                Devices.stg.SetVoltageMode();
                Devices.stg.PrepareAndSendData(2*HeadStage, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);
                SidebandData = Devices.stg.Stimulus.CreateSideband(StimulusActive, sideband, duration, Bit0Time, Bit3Time, Bit4Time);  
                Devices.stg.PrepareAndSendData(2*HeadStage, SidebandData.Sideband, SidebandData.Duration, Mcs.Usb.STG_DestinationEnumNet.syncoutdata);
                Devices.stg.SetupTrigger(0, uint32(255), uint32(255), uint32(10) );
                
                % start the first trigger
                Devices.stg.SendStart(uint32(1));
                
               % disp(['electrode ' num2str(electrode+1) ' (' num2str(channelorder(electrode+1)) ') has been grounded!']);

            else
                disp ('connection failed');
                disp (dec2hex(Devices.status));
                disp (Mcs.Usb.CMcsUsbNet.GetErrorText(Devices.status));
            end
end