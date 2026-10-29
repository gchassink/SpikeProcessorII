% reads the data using aquiredata and produces several different data formats
global Devices System FileInfo Figures
if FileInfo.adaptertype=="Raw reader"
    % load a new temp datastream if recordingtime> datastream
    %if mod(FileInfo.RecordingTime,System.rawFileBlocksize)==0 && FileInfo.RecordingTime>(System.rawFileBlocksize* System.RawToRead)
    %disp(num2str(FileInfo.RecordingTime));

    if FileInfo.RecordingTime>(System.rawFileBlocksize* System.RawToRead)
        System.RawToRead=System.RawToRead+1;
        if System.RawToRead<=size(System.DirRawMatfile,1)
            System.temp=load([System.DirRawMatfile(System.RawToRead).folder '\' System.DirRawMatfile(System.RawToRead).name ],'Raw');
        else
            disp('Finished reading'); % de lijst met Raw bestanden is ingelezen
            System.exit=1;
        end

    end
end

if Firstcycle==1 %first cycle
    %% adding a few ms of the previous read will ensure that if an Action Potential is recorded
    %  in the first bin of the read that it actually can be read
    if isfield(FileInfo, 'RestartTime') %there has been a crash
        % if isfield(FileInfo, 'CrashTime') %there has been a crash
        %
        set( findobj(Figures.fig.Children,'Tag','Dacqbtn'),'String','Stop Dacq','Max',1);
        set( findobj(Figures.fig.Children,'Tag','Recbtn'),'String','Recovered Recording','Max',2,'BackgroundColor','red');
    end
    if FileInfo.adaptertype=="Raw reader" && FileInfo.fname~=""
        btn = findobj(Figures.fig.Children,'Tag','Recbtn');
        btn.Value = 3;  % start recording
        callbackStartRecording(btn,[]);

    end
    if System.Replayer==0
        Devices.dacq.StartDacq();
        disp('DAq started');
    else
        %             System.ChannelsAvailable=288;

        %FileInfo.RecordingTime=double(System.blocksize);
        %FileInfo.RecordingTime=1;
    end

    acquiredData=acquire_data(Devices.dacq,(-Usrange(1)+Usrange(2))*FileInfo.Samplerate,System.ChannelsAvailable);% Let op! andere blocksize ivm eerste ronde
    Raw1 =single(acquiredData(1:System.ChannelsUsed,:));% raw data as read from device
    Raw2 =int32(acquiredData(System.ChannelsUsed+1:end,:)); % additional data streams e.g. sideband data etc
    Carry1=(double(Raw1) * FileInfo.ResolutionPerDigit);% *(System.Maxrange/32768) ;
    Carry2=Raw2  ;% sideband data etc
    Firstcycle=0;
    %FileInfo.RecordingTime=double(FileInfo.Samplerate);
    %        RawBuffered= Raw1;
    %        Raw2Buffered=Raw2;
    %         RawBuffered=[RawBuffered, Raw1];
    %         Raw2Buffered=[Raw2Buffered,Raw2];
end
%% check device buffer level
if System.Replayer==0 % system is live
    remainingframes=Devices.dacq.ChannelBlock_AvailFrames(0); % see how much data is left in the buffer of the device
else
    remainingframes=1; % system reads off line
end
freeRingBuffer=100-(100*double(remainingframes)/double(System.queuesize));
latency=double(remainingframes)/double(FileInfo.Samplerate)*1000;
%set( findobj(Figures.fig.Children,'Tag','framesinbuf'),'String',['Buffer : ' num2str(freeRingBuffer) ' % free' ]);

%% process per loop data
acquiredData=acquire_data(Devices.dacq,System.blocksize,System.ChannelsAvailable);

%raw needs 16-bit signed integers (+4 extra (analog?) channels)
Raw1 =single(acquiredData(1:System.ChannelsUsed,:));% raw data as read from device
Raw2 =int32(acquiredData(System.ChannelsUsed+1:end,:)); % additional data streams e.g. sideband data etc
%     %%% LET OP copie van stimulatie kanaal
%         Raw1(2,:)=single(Raw2(9,:))+100;
%     %%% alleen voor debugging?
Data1=[double(Carry1), double(Raw1) * FileInfo.ResolutionPerDigit];
% reformat data to convert to uV and add last 6 ms (length spikewindow) from previous loop
Data2=[Carry2, Raw2];

% store last 6 ms to use in next loop. (
Carry1=Data1(:,(size(Data1,2)-(-Usrange(1)+Usrange(2))*FileInfo.Samplerate)+1:size(Data1,2));
Carry2=Data2(:,(size(Data2,2)-(-Usrange(1)+Usrange(2))*FileInfo.Samplerate)+1:size(Data2,2));

%Carry1=Data1(:,(System.blocksize-(-Usrange(1)+Usrange(2))*FileInfo.Samplerate)+1:System.blocksize);
%Carry2=Data2(:,(System.blocksize-(-Usrange(1)+Usrange(2))*FileInfo.Samplerate)+1:System.blocksize);

%% buffer 1 sec length worth of data for display and save

RawBuffered(1:System.ChannelsUsed,((loopStep-1)*System.blocksize)+1:loopStep*System.blocksize)= Raw1;
Raw2Buffered(1:(System.ChannelsAvailable-System.ChannelsUsed),((loopStep-1)*System.blocksize)+1:loopStep*System.blocksize)= Raw2;

%RawBuffered=[RawBuffered,Raw1];
%Raw2Buffered=[Raw2Buffered,Raw2];


%% check fore device errors
if System.Replayer==0
    [ErrorStatus,Message,Info] = Devices.dacq.GetErrorMessage();
end

