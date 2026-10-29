%% activate_electrode( devicelist, electrode, channelorder)
% classical way the set an electrode to ground
% 
            function ground_electrode( electrode, channelorder)
            global Devices 
            electrode=electrode-1;% MCS=0:59, matlab=1:60
            if Devices.devicelist.Count == 0
            
                Msgbox('No MEA USB Device connected!', 'Error Connecting To Device', 'error');
            end
            
            if Devices.status == 0

                % Make sure that the stimulation is stopped
                Devices.stg.SendStop(uint32(1));

                % ElectrodeMode: emManual: electrode is permanently selected
                % for stimulation or emAutomatic for automatic
                Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emManual);

                % ElectrodeDacMux: DAC to use for stimulation
                % Devices.stg.SetElectrodeDacMux(electrode,0,0);% required to reset the dacmux in between stimulations

                Devices.stg.SetElectrodeDacMux(electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Ground);% (electrode, index=0, dac)

                % 0 = Ground
                % 1 = Stg1
                % 2 = Stg2
                % 3 = Stg3

                % ElectrodeEnable: enable electrode for stimulation
                Devices.stg.SetElectrodeEnable(electrode, 0, true);

                % BlankingEnable: false: do not blank the ADC signal while stimulation is running
                Devices.stg.SetBlankingEnable(electrode, true);

                % AmplifierProtectionSwitch: false: Keep ADC connected to electrode even while stimulation is running
                Devices.stg.SetEnableAmplifierProtectionSwitch(electrode, true);

                % use voltage stimulation
                Devices.stg.SetVoltageMode();

                % very important to use the Net.convertArray functiosn, since Matlab Uint32 itself does not translate correctly apparantly
                % start the first trigger
                Devices.stg.SendStart(uint32(1));
                Devices.stg.SendStop(uint32(1));%stg.Disconnect(); % ,1)
                disp(['electrode ' num2str(electrode+1) ' (' num2str(channelorder(electrode+1)) ') has been grounded!']);

            else
                disp ('connection failed');
                disp (dec2hex(status));
                disp (Mcs.Usb.CMcsUsbNet.GetErrorText(status));
            end
end