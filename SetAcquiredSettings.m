global System FileInfo Devices Figures;
%% check for channels to stimulate
    totalstim=length(find(System.Stim==1)); %Nr of electrodes to be stimulated
    System.StimAmplitude(System.StimAmplitude==0)=[];
    if length(find(System.Stim==1))>0
        
        FileInfo.StimOrder=random_stimulation(System, FileInfo);
    end
%% program dacq with final settings
% Devices.dacq.SetSelectedChannels(System.ChannelsAvailable, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock);
% Devices.dacq.SetSelectedData(System.ChannelsAvailable, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock); % for use with ChannelBlock_ReadAsFrameArrayI32
% %Devices.dacq.SetSelectedData(channelsinblock, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock/2); % for use with ChannelBlock_ReadAsFrameArrayI32
% Devices.dacq.ChannelBlock_SetCommonThreshold(System.blocksize);
% Devices.dacq.ChannelBlock_SetCheckChecksum(uint32(checksumchannels),uint32(timestampchannels));
Devices.dacq.SetSelectedChannels(System.ChannelsAvailable, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock);
Devices.dacq.SetSelectedData(System.ChannelsAvailable, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock); % for use with ChannelBlock_ReadAsFrameArrayI32
Devices.dacq.ChannelBlock_SetCommonThreshold(System.blocksize);
Devices.dacq.ChannelBlock_SetCheckChecksum(uint32(checksumchannels),uint32(timestampchannels));
