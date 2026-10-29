%% stimulate_electrode( electrode, channelorder, stimtype, amplitude, duration)
% This stimulation method makes use of sideband programming to supress stimulus
% artifacts.
% stimulus duration and amplitudes are supplemented with a 0 amplitude to
% extend the blanking period.
% a 3rd array "Sideband" contains information in the first 8 bits of each that are used to suspress the stimulus artifact
% These numbers should not touch the the first 8 bits. So to program them
% use bitshift functions 'bitsll(number, 8)'.
% besides this a 4th array should be programmed "Stimulus Active" which 1
% at places it should blanc and 0 at places it should read
% documentation is unclear about how it exactly works when but programmed in this way it works. 


function stimulate_electrode( displaychannel, channelorder, stimtype, amplitude, duration)
           global Devices FileInfo
           
           HeadStage=uint32(0);%0 for mea2100, 1 for multiwell?
           
           electrode=find(channelorder==displaychannel)-1;% MCS=0:59, matlab=1:60
           
           if Devices.devicelist.Count > 0
               Devices.stg.SendStop(uint32(1)); % to make sure early programmed stimulations are canceled
               %% base format side band
               % amplitude =  int32([-200000, 200000,0]); %(200 mV) allows
               % for easy detection with an oscilloscope
               % duration = int64([200,200,0)];% uS
               % sideband = int32([bitsll(1, 8), bitsll(3, 8),0]);
               % StimulusActive= int32([1,1,0]) ;
               duration = uint64([duration, 20]); %in our case duration is normally [200,200]
               amplitude= int32([amplitude,0]); %in our case amplitude is for testing purposes set to [-200000,200000]
               % make it general
               IndexOfNegatives=find(amplitude<0); IndexOfPositives=find(amplitude>0); IndexOfZeros=find(amplitude==0);
               StimulusActive(IndexOfNegatives)=int32(1); StimulusActive(IndexOfPositives)=int32(1);StimulusActive(IndexOfZeros)=int32(0);
               sideband(IndexOfNegatives)=int32(bitsll(1, 8)); sideband(IndexOfPositives)=int32(bitsll(3, 8));sideband(IndexOfZeros)=int32(0);
               %% setting for the blanking
               Bit0Time=uint32(40) ;% bit0 (blanking switch) activation duration prolongation in ?s (multiples of 20)
               Bit3Time=uint32(800); %bit3 (stimulation switch) activation duration prolongation in ?s
               Bit4Time=uint32(40); %bit4 (stimulus selection switch) activation duration prolongation in ?s

               Devices.stg.SetElectrodeMode(electrode, Mcs.Usb.ElectrodeModeEnumNet.emAutomatic);
               % set all channels except the electrode of interest off
               % during stimulation
               include=find(FileInfo.Ground==0);
               for i=0:length(channelorder)-1;%59%find(channelorder==32)-1
                   if  ismember(i+1, include)
                    Devices.stg.SetElectrodeEnable( i, 0, false);
%                    
                   Devices.stg.SetEnableAmplifierProtectionSwitch( i, true);
                   Devices.stg.SetBlankingEnable( i, true);
                   end
%                   if  ismember(i+1, include)
%                     Devices.stg.SetElectrodeMode(i, Mcs.Usb.ElectrodeModeEnumNet.emManual);
%                     Devices.stg.SetElectrodeEnable( i, 0, true);
%                     Devices.stg.SetElectrodeDacMux( i,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Ground);% (electrode, index=0, dac)
%                
%                   end
               end
               Devices.stg.SetElectrodeEnable( electrode, 0, true);
               %electrodeMode=Devices.stg.GetElectrodeMode(electrode) % check electrode mode
               Devices.stg.SetElectrodeDacMux( electrode,0, Mcs.Usb.ElectrodeDacMuxEnumNet.Stg1);% (electrode, index=0, dac)

               if stimtype=='uA';
                   % use current stimulation
                   Devices.stg.SetCurrentMode();
                   %disp('currentmode');
               else
                   % use voltage stimulation
                   Devices.stg.SetVoltageMode();
                   %disp('voltagemode');
               end

               if stimtype=='uA'
                   Devices.stg.PrepareAndSendData(2*HeadStage, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_current);
                   SidebandData = Devices.stg.Stimulus.CreateSideband(StimulusActive, sideband, duration, Bit0Time, Bit3Time, Bit4Time);
                   Devices.stg.PrepareAndSendData(2*HeadStage, SidebandData.Sideband, SidebandData.Duration, Mcs.Usb.STG_DestinationEnumNet.syncoutdata);
               else
                   Devices.stg.PrepareAndSendData(2*HeadStage, NET.convertArray(amplitude, 'System.Int32'), NET.convertArray(duration, 'System.UInt64'), Mcs.Usb.STG_DestinationEnumNet.channeldata_voltage);
                   %SidebandData=Devices.stg.Stimulus.CreateSideband([1,1,0],[768,256,0],[200,200,1000],40,800,40);
                   SidebandData = Devices.stg.Stimulus.CreateSideband(StimulusActive, sideband, duration, Bit0Time, Bit3Time, Bit4Time);
                   Devices.stg.PrepareAndSendData(2*HeadStage, SidebandData.Sideband, SidebandData.Duration, Mcs.Usb.STG_DestinationEnumNet.syncoutdata);
               end

               %% connect all stimulation channels to the first trigger and repeat the
               % pulse 1 times
               % first_trigger= 0 ;
               % channelmap=255  ;
               % syncoutmap=255;
               % repeat =1;% yet another way to perform repeats (
               Devices.stg.SetupTrigger(0, uint32(255), uint32(255), uint32(1) );

               % flip the trigger
               
               Devices.stg.SendStart(uint32(1));





           else
               Msgbox('No MEA USB Device connected!', 'Error Connecting To Device', 'error');
               disp ('connection failed');
               disp (dec2hex(Devices.status));
               disp (Mcs.Usb.CMcsUsbNet.GetErrorText(Devices.status));
           end
end