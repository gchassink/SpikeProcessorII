function data = acquire_data(dacq,blocksize,channels)

    %% acquire_data(dacq,blocksize,channels)
    % aquire data from the connected dacq in blocks.
    % Device = Device ID
    % Blocksize = amount of samples per channel in a block
    % Channels = amount of channels used
global FileInfo System
if FileInfo.adaptertype=="HDF5 reader"
    start = double([FileInfo.RecordingTime 1]); %channel column
    count = double([blocksize channels]); %duration Let op! blocksize
   %System.hfd5FileName
    data = h5read(System.hfd5FileName, "/Data/Recording_0/AnalogStream/Stream_0/ChannelData", start , count)';
    %              S:\DATA\Data_Tomas_Vrielink\Ruwe_data_multiwell_experimenten\tomas_16_may_MEAwellplate\hdf5\mixed_Hypoxia__hyperglycemia_001_mwd.h5


elseif FileInfo.adaptertype=="Raw reader" 
    if blocksize==(6/1000)*FileInfo.Samplerate % detect whether this is the first chunck of datastream if so, replace it with zeros and leave the recoring time on zero afterwards
        %FileInfo.RecordingTime=FileInfo.RecordingTime-double(blocksize);
        datablock=blocksize;
        data = System.temp.Raw(: , (datablock-blocksize)+1:datablock);
        %data=zeros(size(System.temp.Raw));
        
    else
    %datablock = double((FileInfo.RecordingTime)-(((System.RawToRead-1)*System.rawFileBlocksize)-blocksize));
    datablock = double((FileInfo.RecordingTime)-((System.RawToRead-1)*System.rawFileBlocksize));
    %if datablock<blocksize  datablock=blocksize; end; % compensate for first block 
    %datablock
    
    data = System.temp.Raw(: , (datablock-blocksize)+1:datablock);
    end
else
    
    

    framesready=zeros(channels,1);
    %data=zeros(channels,blocksize,'uint16'); %Preallocate, -4 since 64 channels are available but 4 are analog, not used for now
    %data=zeros(channels,blocksize,'int32');
    loop=1;FR=[];
    number = dacq.ChannelBlock_AvailFrames(0);
    while number < blocksize % 'wait' function to prevent reading from buffer before ther is at least a block size of data available
        number = dacq.ChannelBlock_AvailFrames(0);
        loop=loop+1;

    end
    %tic
    [frames, ~] = dacq.ChannelBlock_ReadAsFrameArrayI32(0, blocksize);
    % handle Handle of the FIFO queue. Zero when the SetSelectedData call was used.
    % 0 - 59: Elektrode Channels
    % 60 - 67 IFB Analog IFB channels
    % 68 Digital In/Out
    % 69 - 74 Sideband channels
    % 75 - 76 Checksum channels
   
    data=int32(frames).';
    size(data)
%     digital = data(137:142,:);   % after analog channels
% 
% for ch = 1:6
%     fprintf('Digital %d: min=%d max=%d\n', ...
%         ch, min(digital(ch,:)), max(digital(ch,:)));
% end
    %a=toc;
    %data=data1';
    %b=toc;
    %100*((b-a)/b)
end


end