global System FileInfo Devices Figures;

   if Devices.devicelist.Count~=0 
       update_groundStatus
   end
    

    while System.exitSetup==0
    pause(1); % Necessary for Figure update
    if Devices.devicelist.Count~=0 
         check_filterStatus
    else
        resHSUnit=16; % assuming HDF5 data are recorded with the same resolution
    end
    

    %% check setup settings:
    

    FileInfo.ResolutionPerDigit=1/double(resHSUnit); % in uV/digit
    FileInfo.VoltageRange=FileInfo.ResolutionPerDigit*32876; % in uV (checked)
%     if isfield(FileInfo, 'Filters') && str2double(FileInfo.Filters(6,2))<=1 
%         System.rawFileLength=floor((1500000*60/(System.ChannelsUsed*2))/FileInfo.Samplerate);
%         System.type=0010;% change from signed int16 to single
%         
%     else
% 
%         System.rawFileLength=floor((1500000*60/System.ChannelsUsed)/FileInfo.Samplerate);
%     end
    
    % 1000Hz will produce more, but smaller files. In case one gets
    % corrupted not much measurement time is lost.
    if FileInfo.Samplerate==1000
    System.rawBlockSize=150000;%maximum length in datapoints of each rawchannelas saved to file, default=1500000
    else
    System.rawBlockSize=1500000;%maximum length in datapoints of each rawchannelas saved to file, default=1500000
    end    
    
    if isfield(FileInfo,'Filters') && str2double(FileInfo.Filters(6,2))<=1
        
        System.rawFileLength=floor((System.rawBlockSize*60/System.ChannelsUsed)/FileInfo.Samplerate);
        System.type=0010;% change from signed int16 to single
        
    else

        System.rawFileLength=floor((System.rawBlockSize*60/(System.ChannelsUsed*2))/FileInfo.Samplerate);
        System.type=0030;% change from signed int16 to single
    end

   
    MEA_setup=cellstr([FileInfo.adaptertype;...
        extractBetween(FileInfo.DLLversion,"Version=", ","); ...
        [FileInfo.Samplerate; ...
        System.loopSize; ...
        (double(FileInfo.VoltageRange)/double(1000)); ...
        (double(FileInfo.VoltageRange) / double(32768)); ...
        FileInfo.filelength; ...
        System.rawFileLength]]);
    data = [Setup_fields(:),MEA_setup(:)];
    
    Setup_table.Data= data;
    


    %Setup_table.Data=cellstr([FileInfo.adaptertype; extractBetween(FileInfo.DLLversion,"Version=", ","); num2cell([FileInfo.Samplerate; System.loopSize; (FileInfo.VoltageRange); (double(FileInfo.ResolutionPerDigit) *1000); FileInfo.filelength; System.rawFileLength])]);

    %% check File settings:
    File_table.Data=cellstr([string(FileInfo.fname); string(System.rname)]);% ; num2cell([FileInfo.filelength; System.rawFileLength ]) ]);

    %% update Stimulation amplitudes
    if System.StimReset==0
        System.StimAmplitude=StimTable.Data;
    else
        StimTable.Data=System.StimAmplitude;
        System.StimReset=0;
    end

    if System.ground_stim_toggle== 1
      set( findobj(fig_init.Children,'tag', 'ground_stim_toggle'),'String',['Stimulation']);
    else
      set( findobj(fig_init.Children,'tag', 'ground_stim_toggle'),'String',['Ground']);
    end
    
    

end