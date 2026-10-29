%% crashresponse
% attempts to recover from computer reboot
% provided only one instance of Matlab is running 
% provided MEA device is not locked up 

pause(2)

global System FileInfo exitfigure
load('recording_on.mat')

%     list_files=dir([FileInfo.fname '*']);
%     lastfile=[list_files(end).folder '\' list_files(end).name];
% 
%     load([lastfile], 'FileInfo');
%     FileInfo.CrashTime=FileInfo.RecordingTime;
    FileInfo.RestartTime=clock;
    FileInfo.RecordingTime= double(ceil(double(etime(FileInfo.RestartTime, FileInfo.StartTime)*(FileInfo.Samplerate/System.blocksize))))*double(System.blocksize);
   
    FileInfo.file_series=floor(FileInfo.RecordingTime/double(FileInfo.Samplerate*FileInfo.filelength));
    %FileInfo.file_series=FileInfo.file_series+1;
    disp(num2str(FileInfo.file_series));
    disp(num2str(FileInfo.RecordingTime));
    System.rawCounter=0;  
    if isfield(FileInfo, 'Name')
    FileInfo = initialize_file([FileInfo.fname num2str(floor(FileInfo.file_series),'%04.f') 'restarted'], FileInfo);
    end
    if isfield (System, 'rawName')
    System=initialize_raw_file([System.rname num2str(floor(FileInfo.file_series),'%04.f') '-' num2str(floor(System.raw_series),'%02.f')], System, FileInfo);
    end
disp ('in crash recovery mode');
    
    System.exitSetup=1;
    System.criticalError=0;