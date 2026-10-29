%% stimulate_electrode_burst(channel, channelorder, stimtype, amplitude, duration)
% Allow repeatative burst stimulation using the classical way of
% stimulation where the stimulation electrode cannot read while stimulation
% the pattern.
% (From the documentation of the DLL):
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

            
            % Prepare and send data to a given channel on the STG. Previous data sent to that channel is erased first. 
            % Each datapoint is represented by an signed 32bit integer value. When using voltage stimulation, 
            % the values are in multiple of 1 uV, thus the possible range is += 2000 V. When using current stimulation, 
            % the values are in multiple of 1 nA, this the possible range is += 2000 mA. 
            % The duration is given as a list of 64 bit integers. Durations are given in units of us. 
            % The STG has a resolution of 20 us. 
            % Blocks of data which should repeat can be defined by PREPENDING such a block with an entry in the arrays 
            % where both amplitude AND duration is zero. 
            % The end of such an block is marked by an entry where the DURATION is set to zero 
            % and the AMPLITUDE beeing set to the number of times the block should run. 
            % Blocks can be nested. 


function stimulate_electrode_burst(channel, channelorder, stimtype, amplitude, duration)
            global Devices 
            HeadStage=uint32(0);
            electrode=find(channelorder==channel)-1;% MCS=0:59, matlab=1:60
            if Devices.devicelist.Count == 0
            
                Msgbox('No MEA USB Device connected!', 'Error Connecting To Device', 'error');
            end
                        
            
            if Devices.status == 0

                % Make sure that the stimulation is stopped
                Devices.stg.SendStop(uint32(1));
                % ElectrodeMode: emManual: electrode is permanently selected
                % for stimulation or emAutomatic for automatic
                
                % Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emAutomatic);
                Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emManual);
                % set all channels except the electrode of interest off
                % during stimulation
                for i=0:59%find(channelorder==32)-1
                        % ElectrodeEnable: enable electrode for stimulation
                        Devices.stg.SetElectrodeEnable( i, 0, false);
                        % BlankingEnable: false: do not blank the ADC signal while stimulation is running
                        Devices.stg.SetEnableAmplifierProtectionSwitch( i, true);
                        % AmplifierProtectionSwitch: false: Keep ADC connected to electrode even while stimulation is running
                        Devices.stg.SetBlankingEnable( i, true);
                end
                Devices.stg.SetElectrodeEnable( electrode, 0, true);
                % electrodeMode=Devices.stg.GetElectrodeMode(electrode) 
                Devices.stg.SetElectrodeDacMux( electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Stg1);% (electrode, index=0, dac)

                % 0 = Ground
                % 1 = Stg1
                % 2 = Stg2
                % 3 = Stg3


                if stimtype=='uA'
                    % use current stimulation
                    Devices.stg.SetCurrentMode();
                else
                    % use voltage stimulation
                    Devices.stg.SetVoltageMode();
                    
                end

                % send stimulus data to device
                % Prepare and send data to a given channel on the STG. Previous data sent to that channel is erased first. 
                % Each datapoint is represented by an signed 32bit integer value. When using voltage stimulation, the values are in multiple of 1 uV, thus the possible range is += 2000 V. When using current stimulation, the values are in multiple of 1 nA, this the possible range is += 2000 mA. 
                % The duration is given as a list of 64 bit integers. Durations are given in units of ??s. The STG has a resolution of 20 ??s. 
                % Blocks of data which should repeat can be defined by prepending such a block with an entry in the arrays where both amplitude and duration is zero. The end of such an block is marked by an entry where the duration is set to zero and the amplitude beeing set to the number of times the block should run. Blocks can be nested. 
                % 
                % Parameters:
                % channel The channel number to send data to. 
                % amplitude A list of amplitudes in units of ??V and nA in voltage and current mode, respectively. 
                % duration A list of durations in units of ??s. 
                % destType specifies wheather the data is for syncout, current or voltage stimulation. 
                
                if stimtype =='uA'
                   Devices.stg.PrepareAndSendData(0, amplitude, duration, Mcs.Usb.STG_DestinationEnumNet.channeldata_current); 
 
                else
                    %disp('mV');
                    % very important to use the Net.convertArray functiosn, since Matlab Uint32 itself does not translate correctly apparantly
                    Devices.stg.PrepareAndSendData(2*HeadStage, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);
                    %Devices.stg.PrepareAndSendData(0, amplitude, duration, Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);
                end
               
                % connect all stimulation channels to the first trigger and repeat the
                % pulse 1 times
                Devices.stg.SetupTrigger(0, uint32(255), uint32(255), uint32(1));
                %Devices.stg.SetupTrigger(0, NET.convertArray(255, 'System.UInt32'), NET.convertArray(255, 'System.UInt32'), NET.convertArray(2, 'System.UInt32'));
                %   virtual void SetupTrigger  ( uint32_t  first_trigger,  
                %   array< uint32_t >^  channelmap,  
                %   array< uint32_t >^  syncoutmap,  
                %   array< uint32_t >^  repeat  
                %  )  

                
                % start the first trigger
                Devices.stg.SendStart(uint32(1));
                
                disp(['electrode ' num2str(electrode+1) ' (' num2str(channelorder(electrode+1)) ') will be stimulated!']);
                               

            else
                disp ('connection failed');
                disp (dec2hex(status));
                disp (Mcs.Usb.CMcsUsbNet.GetErrorText(status));
            end
end