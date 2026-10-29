%% activate_electrode( devicelist, electrode, channelorder)
% classical way the bring back an electrode in reading mode from ground
% 
% The STG200x & STG400x Series Stimulus Generators have two distinct modes of operation, 
            % the Download mode and the Streaming mode:The Download mode is the "classic" mode of 
            % operation, as used by the MC Stimulus software. In this mode, one or multiple 
            % waveforms are defined in PC memory and downloaded to the STG. The waveforms 
            % are stored in STG device onboard memory and can be sent to the analog and 
            % sync outputs once or multiple times. The STG can operate independantly from 
            % the PC (without computer connection) after the download. Output is triggered
            % either by the front panel start/stop button, the digital trigger inputs or under software control.
            % The other mode of operation is the Streaming mode. Here the analog output 
            % is sent to the STG device in "real time". The PC has to be connected to the 
            % STG all the time. The data that is sent to the analog output is downloaded 
            % from the PC to the STG on the fly. The Streaming mode is useful for applications 
            % where flexible feedback is needed as well for applications where very long 
            % waveforms which are not repeated (such as white noise) are used.
            function activate_electrode( devicelist, electrode, channelorder)
            global Devices
            electrode=electrode-1;% MCS=0:59, matlab=1:60
            if devicelist.Count == 0
            
                Msgbox('No MEA USB Device connected!', 'Error Connecting To Device', 'error');
            end
            %for electrode = 0 : 60
            %electrode =1
            Devices.stg=Mcs.Usb.CStg200xDownloadNet(); 
                       
            % Connect to the stimulator of the device. The lock mask allows multiple connections to the same device
            status = Devices.stg.Connect(devicelist.GetUsbListEntry(0),1); % ,1) is the lockmask
            if status == 0

                % Make sure that the stimulation is stopped
                Devices.stg.SendStop(uint32(1));

                % ElectrodeMode: emManual: electrode is permanently selected
                % for stimulation or emAutomatic for automatic
                Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emAutomatic);

                % ElectrodeDacMux: DAC to use for stimulation
                % Devices.stg.SetElectrodeDacMux(electrode,0,0);% required to reset the dacmux in between stimulations

                Devices.stg.SetElectrodeDacMux(electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Stg1);% (electrode, index=0, dac)


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

                % array of amplitudes and duration
                amplitude =int32([-1, 1]); % nA or uV
                duration = uint64([1, 1]); % ??s

                % use voltage stimulation
                Devices.stg.SetVoltageMode();

                % send stimulus data to device
                Devices.stg.PrepareAndSendData(0, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);

                % connect all stimulation channels to the first trigger and repeat the
                % pulse 1 times
                Devices.stg.SetupTrigger(0, NET.convertArray(255, 'System.UInt32'), NET.convertArray(255, 'System.UInt32'), NET.convertArray(1, 'System.UInt32'));
                % very important to use the Net.convertArray functiosn, since Matlab Uint32 itself does not translate correctly apparantly
                % start the first trigger
                Devices.stg.SendStart(uint32(1));
                Devices.stg.Disconnect(); % ,1)
                disp(['electrode ' num2str(electrode+1) ' (' num2str(channelorder(electrode+1)) ') has been reactivated!']);

            else
                disp ('connection failed');
                disp (dec2hex(status));
                disp (Mcs.Usb.CMcsUsbNet.GetErrorText(status));
            end
end