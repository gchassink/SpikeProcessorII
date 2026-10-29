function callbackSetBlockSize(source,event)
    %% set sample rate
    global Devices FileInfo System
    
    switch source.Value
        case 1
            System.loopSize=1000;
        case 2
            System.loopSize=100;
        case 3
            System.loopSize=25;
        case 4
            System.loopSize=10;
        case 5
            System.loopSize=8;
    end
    if System.Replayer==0
    FileInfo.Samplerate=Devices.dacq.GetSamplerate(0);
    end
    System.blocksize=FileInfo.Samplerate*System.loopSize/1000;
    %System.timeconstant=5*1000/System.loopSize;
%     Devices.dacq.SetSelectedChannels(channelsinblock/2, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock);
%     Devices.dacq.ChannelBlock_SetCommonThreshold(System.blocksize);
%     Devices.dacq.ChannelBlock_SetCheckChecksum(uint32(checksumchannels),uint32(timestampchannels));
%     System.ChannelsAvailable=channelsinblock/2;
end