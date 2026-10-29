
%% initialize variables
global  test  System FileInfo  ; 


FileInfo.Matlab=sscanf(version('-release'),'%d');
System.hfd5FileName="C:\DATA\temp\mixed_Hypoxia_001_mwd.h5";
% per cycle local variables:

    System.rasterlayout=[12:17,21:28,31:38,41:48,51:58,61:68,71:78,82:87,88];% default layout of a 60 channel MEA + a channel to store stimulations
    System.Replayer=0; % too allow to use the script as hdf5 reader as well certain functions must eb dissabled every cycle
    rmsmatr=[];% noise matrix
    Firstcycle=1; % to make sure special treatment of first cycle
    totalspikes=0; % clear total spikes
    System.Channelspikes=zeros(max(System.rasterlayout),1);
    System.noisevalues(1:length(System.rasterlayout)-1,1)=50; % set base noise values
    Waves=[]; % stores waveshapes
    Ras=[]; % stores raster plots
    burstIndex=[];%stores Burstlevels
    meanSr=[]; % stores Stimulus response curves
    Raw=[];% stores raw data from Dacq
    AWFR(1, 1:24)=zeros(1,24);
    System.exit=0; % 1 when exit sequence needs to be executed
    System.criticalError=0;%  1 when encountering a unsolvable error
    Usrange=[-0.002,0.004]; %The window of data that is saved with each spike (in seconds)
    System.max_noise_estimation_entries=40;
    System.min_threshold_multiplier=-20.0;
    FileInfo.channelorder=[47,48,46,45,38,37,28,36,27,17,26,16,35,25,15,14,24,34,13,23,12,22,33,21,32,31,44,43,41,42,52,51,53,54,61,62,71,63,72,82,73,83,64,74,84,85,75,65,86,76,87,77,66,78,67,68,55,56,58,57,88];
        % channelorder= physical order of contacts on the MEA, starting in the
        % middle of the lower end of the MEA following clockwise. for multiwell
        % it start upper left clockwise per well
       
    System.logEntryCounter=1;% log counter track of lost spike detect cycles per recorded file
    FileInfo.log{System.logEntryCounter,2}='log entries';
    FileInfo.log{System.logEntryCounter,1}='recording time in samples';

% Default variables as set in the setup screen

    % Default device variables:
    System.queuesize=int32(100000);   %Maximum frames in queue, the queue is emptied when the amount of frames in it exceeds this number.
    System.Gain=int32(0); % upon read should be 5000 always fixed
    System.ChannelsUsed=length(System.rasterlayout)-1; % previously retrieved from device but now set since data2 adds another 13 channels to read
    FileInfo.SetTemperature=370; % for Multiwell temp
    FileInfo.Samplerate=int32(25000);   %Samplerate in Hz
    System.loopSize=100;% in ms
    System.blocksize=FileInfo.Samplerate*System.loopSize/1000; % in data points, size of te blocks of data; used to be 25000 but its more convinient to keep it 1 second worth of data
    FileInfo.adaptertype="--";% will disp;lay devicetype when connected
    %%%%% this does not work yet in DLL 5.1.32.0 --> always 9.8 mV ==> range -2000 : 2000 uV (gain 5) %%%%%
    System.Range=[2500, 1250, 625, 312.5, 156.3, 78.1, 39.1, 19.5, 9.765];% +- max voltage range
    System.RangeIndex=int32(8);%index of voltage used (default 8)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    FileInfo.VoltageRange=int32(1000*System.Range(System.RangeIndex+1));

    % record data file related variables: see writedata for help
    FileInfo.file_series=0; % sequence number of fileseries
    FileInfo.filelength=int32(3600); % file length in seconds default 3600
    FileInfo.RecordingTime=double(0); % in multiples of samplerate
    FileInfo.fname="";file="";path=""; % filename info

    % default Raw File related variables: see write_raw for help
    System.rawrecordlength=double(0); % min/hour','10 min/hour'
    System.rawBlockSize=1500000;%maximum length in datapoints of each rawchannelas saved to file, default=1500000
    System.rawFileLength=double(floor((System.rawBlockSize*60/System.ChannelsUsed)/double(FileInfo.Samplerate)));% in seconds (max 62 for matfile v-4) should stay 60 for 25000 Hz for this file format
    System.type=0030;% 'integer*4' signed int16
    System.imagf = 0; % The imaginary flag is an integer whose value is either 0 or 1. If 1, then the matrix has an imaginary part. If 0, there is only real data.)
    System.namlen= length(getVarName(Raw))+1;
    System.var=[ 'Raw' char(0) ];%char(0)getVarName(Us)
    System.raw_series=0;% sequence number of raw file belonging to a certain file_series number
    System.rawCounter=double(0);% counter to keep track of rawsize (should not exceed 60 seconds)
    System.rname=""; %rawfile basename
    
    % Grounding panel:
    FileInfo.Ground(1:length(System.rasterlayout))=0; % logical index of electrodes that are ground
    System.GroundAllElectrodes=0;
    
    % Stimulation panel:
    System.ground_stim_toggle= 0; % stores the function of the electrode buttons ; ground or stimulation
    System.stimlistlength=0; % stores the position in a stimulationlist
    System.Stim(1:length(System.rasterlayout))=0; % logical index of electrodes that are stimulated
    System.StimAllElectrodes=0;% logical to see if all electrodes should be stimulated
    System.StimFrequency=0.1; %Hz, default value
    System.StimDelay=10; % stimulus start delay in seconds (default)
    System.SuperDelay=10; % interstimulus super delay in seconds (default)
    System.StimType='uA'; % uA or uV
    System.StimAmplitude=int32([-8, 8; -12, 12; -24, 24; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0; 0, 0]); % nA or uV % wel erg gevoelige
    System.StimDuration=int32([200, 200]); % us
    System.StimRepeats=100; % default nr of stimulations per stim period
    System.SuperRepeats=1; % nr of stim periods
    System.StimReset=0;
    System.StimIndex=1; % index of System.stimorder (to be set elsewhere)
    System.LastStim=0; % flag to indicat if a stimulation is running
    System.ThisStim=0; System.FirstStim=0; 
        % relative time of first stimulation in order to give live feedback of stimulation precisission. 
        % NOT used to create ultimate stimulation timestamps
    System.Sr=int16([]); % stimulus responses data  Past Niet Goed in Structuur
    System.edges=((-500/1000)*FileInfo.Samplerate : (5/1000)*FileInfo.Samplerate  :(500/1000)*FileInfo.Samplerate); 
        %bins for stimulus responses 
    
% Default variables as set in main interface
    test=0; % the status of the test button for experimental software
    FileInfo.testButtonWasPressed=0;
    System.dacqstatus=1; %  status of the software: 
            %1 = not running, not recoring
            %2 = running, not recording
            %3 = running, recording
    System.channeldisp=21; %channel to display. default is 12(21)
    System.last_channel=0; % to keep track of the previously selected channel (to reset colors etc)
    FileInfo.NoiseAdaptability=30; % speed of noise ability high fast, low is slow
    FileInfo.threshold_multiplier=-6.5;% set treshold for spike detection as a multiple of RMS noise.
    FileInfo.detectionType=1;% set detectiontype 1=negative only, 0 = default
    System.plottype=4; % basic plot type, 1-6 (no, raster,waveshapes, rawdata, stimulusresponses, additional channel data
    System.indicatorSet=[1,1,1];% flag to set what is is shown


   

