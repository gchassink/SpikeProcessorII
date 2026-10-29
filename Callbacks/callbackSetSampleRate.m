function callbackSetBlockSize(source,event)
    %% set sample rate
    global Devices FileInfo System
    switch source.Value
        case 1
            FileInfo.Samplerate=25000;
        case 2
            FileInfo.Samplerate=16000;
        case 3
            FileInfo.Samplerate=10000;
        case 4
            FileInfo.Samplerate=2000;
    end
    if System.Replayer==0
    Devices.dacq.SetSamplerate(FileInfo.Samplerate, 1, 0);
    FileInfo.Samplerate=Devices.dacq.GetSamplerate(0);
    end

    if FileInfo.Samplerate==1000
    System.rawBlockSize=150000;%maximum length in datapoints of each rawchannelas saved to file, default=1500000
    else
    System.rawBlockSize=1500000;%maximum length in datapoints of each rawchannelas saved to file, default=1500000
    end    

    if System.type==10
        System.rawFileLength=floor((System.rawBlockSize*60/(System.ChannelsUsed*2))/FileInfo.Samplerate);
    else
        System.rawFileLength=floor((System.rawBlockSize*60/System.ChannelsUsed)/FileInfo.Samplerate);
    end
    System.blocksize=FileInfo.Samplerate*System.loopSize/1000;
%     Devices.dacq.SetSelectedChannels(channelsinblock/2, System.queuesize, System.blocksize, Mcs.Usb.SampleSizeNet.SampleSize32Signed, channelsinblock);
%     Devices.dacq.ChannelBlock_SetCommonThreshold(System.blocksize);
%     Devices.dacq.ChannelBlock_SetCheckChecksum(uint32(checksumchannels),uint32(timestampchannels));
%     System.ChannelsAvailable=channelsinblock/2;
end