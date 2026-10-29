%% setup_device(System,FileInfo, Devices) 
%  Detects the MEA device, connects it, and specifies options like:
%  - base filename
%  - filtersettings
%  - samplerate
%  - voltage range
%  - System.blocksize
%  - System.queuesize
%  - electrodes to ground
%  - electrode to stimulate
%  - stimulation parameters

% When using 32 bit data format, ChannelsInBlock is still the number of 16 bit channels per frame, as obtained from
% GetChannelsInBlock, while nChannels is the number of 32 bit channels to be read from the device. So when all
% channels from a device are read in 32 bit data format nChannels = ChannelsInBlock/2

% Voltage range with index '8' is equal to 9.8 Microvolts. The values per index (0-8) can be checked in the dropdown list in MC_rack.

function fig_init=SETUP_DEVICE

    global System FileInfo Devices Figures;
    System.exitSetup=0;
    assembly = NET.addAssembly([pwd '\McsUsbNet.dll']); % load .NET library from MultiChannel Systems
    FileInfo.DLLversion=char(assembly.AssemblyHandle.FullName);
    
    warning('off','MATLAB:structOnObject');% supress warnings about reading private data from an object, maybe something to repair later
    if  isfile ('recording_on.mat') % if crash is detected.... Recover from unexpected close down
        disp('Spikeprocessor recovers from crash, please wait.....') ;
        crashResponse;
        disp('recording continues');
    end
    
    FindDevices
    if Devices.devicelist.Count==0
        uiwait(msgbox('Interface board not connected,...starting in read mode'));
        [file,path]= uigetfile('C:\Users\HassinkGC\OneDrive - University of Twente\Desktop\temp\mixed_Hypoxia_001_mwd.h5', 'Select a  Hdf5 or raw*mat file');
        if contains(file, '.h5')
            System.hfd5FileName=[path file];
            System.hdf5=h5info(System.hfd5FileName);
            %result=StructFind(System, 'ChannelData')';
            %result2=['System', char(StructFind(System, '/Data/Recording_0/AnalogStream/Stream_0'))];
            temp=System.hdf5.Groups.Groups.Groups(1).Groups(1).Datasets.ChunkSize; % works for post recording conversion not for live hdf5
            System.ChannelsUsed=temp(2);
            FileInfo.adaptertype="HDF5 reader";
            System.Replayer=1;
            FileInfo.channelorder=[1:System.ChannelsUsed];
            System.rasterlayout=[1:System.ChannelsUsed];
            %System.ChannelsUsed=length(System.rasterlayout); % previously retrieved from device but now set since data2 adds another 13 channels to read
            System.ChannelsAvailable=System.ChannelsUsed;
            FileInfo.Ground(1:length(System.rasterlayout))=0;
            System.Stim(1:length(System.rasterlayout))=0;
            %System.Channelspikes=zeros(length(System.rasterlayout),1);
            System.Channelspikes=zeros(max(System.rasterlayout),1);
            System.noisevalues(1:length(System.rasterlayout),1)=50;
        else
            System.ReadRawFile=[path file];
            DirRawMatfile=dir([path 'raw-*.mat']);
            DirRawMatfile2=struct2table(DirRawMatfile);
            DirRawMatfile3=sortrows(DirRawMatfile2,'datenum', 'ascend');
            System.DirRawMatfile=table2struct(DirRawMatfile3);
            System.RawToRead=1;
            System.temp=load([path System.DirRawMatfile(System.RawToRead).name ],'Raw');
            System.rawFileBlocksize=size(System.temp.Raw,2);
            System.ChannelsUsed=size(System.temp.Raw,1);
            FileInfo.adaptertype="Raw reader";
            System.Replayer=1;
            if System.ChannelsUsed>65 %in case data is not from single well
            FileInfo.channelorder=[1:System.ChannelsUsed];
            System.rasterlayout=[1:System.ChannelsUsed];
            end
            %System.ChannelsUsed=length(System.rasterlayout); % previously retrieved from device but now set since data2 adds another 13 channels to read
            System.ChannelsAvailable=System.ChannelsUsed;
            FileInfo.Ground(1:length(System.rasterlayout))=0;
            System.Stim(1:length(System.rasterlayout))=0;
            System.Channelspikes=zeros(max(System.rasterlayout),1);
            System.noisevalues(1:length(System.rasterlayout),1)=50;
            
            System.type=0030;
        end
    else
        ConnectToDevices
    end
    draw_setup_GUI
    
    WaitForUserSettings
    if Devices.devicelist.Count~=0 
            SetAcquiredSettings

    end
    if ~isfield(FileInfo,'Incubator') 
          defaultIncubatorSchedule % load base schedule
    else
        
        Devices.Incubator=FileInfo.Incubator; %backup original schedule
    end
    if isfield(FileInfo,'Incubator') 
    record_incubator_values(0)% run once to prevent a timelag during main
    end
end




























