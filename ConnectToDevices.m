global System FileInfo Devices Figures;
for DeviceInstance=1: Devices.devicelist.Count; % check if more than one usb connected
    probe=Devices.devicelist.GetUsbListEntry(DeviceInstance-1);
    DeviceName(DeviceInstance)=cellfun(@string,{probe.DeviceName});
end
if DeviceName=="Multiwell-MEA"
    Devices.dacq=Mcs.Usb.CMultiwellDeviceNet(); % swith dacq to multiwell
    for DeviceInstance=1: Devices.devicelist.Count; % Re-check order of usb connections
        probe=Devices.devicelist.GetUsbListEntry(DeviceInstance-1);
        DeviceName(DeviceInstance)=cellfun(@string,{probe.DeviceName});
    end
end
headstage=find(DeviceName=="MEA2100-Lite" | DeviceName=="Multiwell-MEA")-1;
TC02=find(DeviceName=="TC02")-1;
Devices.status = Devices.dacq.Connect(Devices.devicelist.GetUsbListEntry(headstage));% connect to data acquisition of device
if Devices.status~=0
    disp(['An error has occurred:'  string(Mcs.Usb.CMcsUsbNet.GetErrorText(Devices.status))])
    %disp_error(Devices.status,"critical error!")
    Devices.dacq.Disconnect();

    Devices.status = Devices.dacq.Connect(Devices.devicelist.GetUsbListEntry(headstage));
    if Devices.status~=0
        System.exitSetup = 1;
        System.exit = 1;
    end
    %disp (Mcs.Usb.CMcsUsbNet.GetErrorText(Devices.status))
end
%Devices.stgStatus=Devices.stg.Connect(Devices.devicelist.GetUsbListEntry(0));% connect to internal stimulator of device
Devices.stgStatus=Devices.stg.Connect(Devices.devicelist.GetUsbListEntry(headstage),0);% connect to internal stimulator of device
FileInfo.adaptertype=cellfun(@string,{Devices.dacq.GetHeadstageID(0)});
if FileInfo.adaptertype=="DeviceHasNoHeadstage"
    logError(FileInfo.adaptertype);

end

if FileInfo.adaptertype=="Multiwell" % start temperature controler as well
    % Devices.multiwellStatus=Devices.multiwell.Connect(Devices.devicelist.GetUsbListEntry(0));
    % platetype=Devices.multiwell.GetPlateType()
    Devices.tcxStatus=Devices.tcx.Connect(Devices.devicelist.GetUsbListEntry(headstage),1);
    Devices.tcx.GetErrorText(Devices.tcxStatus)
    Devices.dacq.GetPlateClampState(headstage)
    Devices.dacq.GetPlateType(headstage)
    Devices.dacq.SetPlateType(headstage, Mcs.Usb.MultiwellPlateTypeEnumNet.Plate_24W300_30GBB)
    Devices.dacq.GetPlateType(headstage)
    %Devices.dacq.ClosePlateClamp()
    %Devices.dacq.GetPlateType(headstage)

end
    if ~isempty(TC02) % start temperature controler as well
        Devices.TC02=Mcs.Usb.CTcxDeviceNet();
        Devices.TC02Status=Devices.TC02.Connect(Devices.devicelist.GetUsbListEntry(TC02),1);
        Devices.TC02.GetErrorText(Devices.TC02Status)
        Devices.TC02.GetBoardTemp()
    end
    if     isfield (Devices, 'tcxStatus')  && Devices.tcxStatus==0
        Devices.tcx.GetValue(uint32(0)) % get current temperature
        Devices.tcx.SetSetpoint(uint32(0),int32(FileInfo.SetTemperature)); %set temperature
        Devices.tcx.GetSetpoint(uint32(0)) % get current set temperature
        Devices.tcx.SetOnOff(uint32(0), true); % turn on temperature controller
    end


%end

if Devices.stgStatus~=0
    Reason='Stg not ready? Possible reason: other (MCS) software connected to device. Please close all conflicting software and start again.';
    string(Mcs.Usb.CMcsUsbNet.GetErrorText(Devices.stgStatus))
    %disp_error(Devices.stgStatus,Reason)
    System.exitSetup = 1;
    System.exit = 1;
else
    Devices.dacq.StopDacq(0); % if software hat not stopped sampling correctly before
        % Devices.scu = Mcs.Usb.CSCUFunctionNet(Devices.dacq); % for use with a Signal Collector Unit (SCU)
        % dacqLegacy=Devices.scu.IsInDacqLegacyMode();
        % Devices.scu.SetDacqLegacyMode(false);
    Devices.dacq.SetSamplerate(FileInfo.Samplerate, 1, 0); % sample rate, oversample, virtual device
    Devices.dacq.SetDataMode(Mcs.Usb.DataModeEnumNet.Signed_32bit , 0); %MCS uses signed 32bit
    
    
    %% all commented functions below are not working completely in dll version 5.1.32.0, they should be in future versions%%
    % Devices.dacq.SetVoltageRangeByIndex(System.RangeIndex,0);
    % Devices.dacq.GetVoltageRangeIndex(0) % does not affect 32bit reading of ringbuffer
    [ status, resHS, resHSUnit]=Devices.dacq.GetResolutionPerDigit(0, Mcs.Usb.DacqGroupChannelEnumNet.HeadstageElectrodeGroup); % is the one that correctly return resolution
    % resolutionHS = double(resHS) * power(double(10), -double(resHSUnit));
    % [status, resIFBADC, resIFBADCUnit]=Devices.dacq.GetResolutionPerDigit(0, Mcs.Usb.DacqGroupChannelEnumNet.InterfaceADCGroup);
    % resolutionIFBADC = double(resIFBADC) * power(double(10), -double(resIFBADCUnit));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if FileInfo.adaptertype=="Multiwell"
        FileInfo.channelorder=[1:289];
        System.rasterlayout=[1:289];
        System.ChannelsUsed=length(System.rasterlayout)-1; % previously retrieved from device but now set since data2 adds another 13 channels to read
        System.WellSize=12;
        FileInfo.Ground(1:length(System.rasterlayout)-1)=0;
        System.Stim(1:length(System.rasterlayout)-1)=0;
        System.Channelspikes=zeros(length(System.rasterlayout)-1,1);
        System.noisevalues(1:length(System.rasterlayout)-1,1)=50;
    end
     Devices.dacq.SetNumberOfAnalogChannels(System.ChannelsUsed, 0, 0, 8, 0);
   
   
    % number of analog channels is hardcoded here which might be a risk when
    % trying to use this sofware with other device later on!
    % Devices.dacq.EnableDigitalIn(true , 0);
   

      Devices.dacq.EnableDigitalIn(Mcs.Usb.DigitalDatastreamEnableEnumNet.DigitalIn , 0);
      Devices.dacq.EnableDigitalIn( Mcs.Usb.DigitalDatastreamEnableEnumNet.DigitalOut , 0);%DigOutStim DigitalOut
     if FileInfo.adaptertype~="Multiwell"
         
         Devices.dacq.EnableDigitalIn( Mcs.Usb.DigitalDatastreamEnableEnumNet.Hs1SidebandLow , 0);
         Devices.dacq.EnableDigitalIn(Mcs.Usb.DigitalDatastreamEnableEnumNet.Hs1SidebandHigh , 0);
     else
        disp('Multiwell')
         %Devices.dacq.EnableDigitalIn( Mcs.Usb.DigitalDatastreamEnableEnumNet.Hs1Digital , 0);
          % Devices.dacq.EnableDigitalIn( Mcs.Usb.DigitalDatastreamEnableEnumNet.Hs1SidebandLow , 0);
          % Devices.dacq.EnableDigitalIn(Mcs.Usb.DigitalDatastreamEnableEnumNet.Hs1SidebandHigh , 0);
     end
     Devices.dacq.EnableChecksum(true, 0);
 
     [analogchannels, digitalchannels, checksumchannels, timestampchannels, channelsinblock] = Devices.dacq.GetChannelLayout(0);
     System.ChannelsAvailable=channelsinblock/2;
     
     disp(['analogchannels; ' num2str(analogchannels)]);
     disp(['digitalchannels; ' num2str(digitalchannels)]);
     disp(['checksumchannels; ' num2str(checksumchannels)]);
     disp(['timestampchannels; ' num2str(timestampchannels)]);
     disp(['channelsinblock; ' num2str(channelsinblock)]);
     disp(['additionalchannels; ' num2str(System.ChannelsAvailable-System.ChannelsUsed)]);
     
        % When using 32 bit data format, ChannelsInBlock is still the number of 16 bit channels per frame,
        % as obtained from GetChannelsInBlock, while nChannels is the number of 32 bit channels to be read from the device.
        % So when all channels from a device are read in 32 bit data format nChannels = ChannelsInBlock/2
        
    
end