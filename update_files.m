function update_files(Ts,Cs,Us,Ns,Raw)
global  Devices test  System FileInfo Figures Tmr 
% designed to work with loops of 1 second
    if floor(FileInfo.RecordingTime/double(FileInfo.Samplerate*FileInfo.filelength))==FileInfo.file_series
        % there has been a file initiated already
        Sr=write_data(Ts,Cs,Us,Ns);
        
        % Sr is used to calculate stimulus responses
        if ~isempty(Sr)
            System.Sr=[System.Sr; Sr];
        end
        % record Raw
        if (System.rawrecordlength)>0
                
            if System.rawCounter < 60 * System.rawrecordlength % in whole seconds
                
                if floor(double(System.rawCounter)/double(System.rawFileLength))==System.raw_series
                    if (~isempty(Raw))
                        if isfile ([System.rawName '.mat'])
                            System=write_raw(Raw, System);
                            
                        else
                            System=initialize_raw_file([System.rname num2str(floor(FileInfo.file_series),'%04.f') '-' num2str(floor(System.raw_series),'%02.f')], System, FileInfo);
                            System=write_raw(Raw, System);
                            
                        end
                    end
                else
                    % a new RAW file must be initiated
                    System.raw_series=floor(double(System.rawCounter)/double(System.rawFileLength));
                    System=initialize_raw_file([System.rname num2str(floor(FileInfo.file_series),'%04.f') '-' num2str(floor(System.raw_series),'%02.f')], System, FileInfo);
                    System=write_raw(Raw, System);
                    disp('new file')
                end
                System.rawCounter=System.rawCounter+1;

            end
        end
        
    else % a new REGULAR file must be intitiated
        % first write FileInfo data to old file
        mat = matfile([FileInfo.Name '.mat'],'Writable',true);
        time=clock;
        FileInfo.EndTime=[int2str(time(4)),':',int2str(time(5)),':',int2str(time(6))];
        mat.FileInfo=FileInfo; % make sure all error data etc is updated as well
        % create a new file
        
        FileInfo.file_series=floor(FileInfo.RecordingTime/double(FileInfo.Samplerate*FileInfo.filelength));
        FileInfo = initialize_file([FileInfo.fname num2str(floor(FileInfo.file_series),'%04.f')], FileInfo);
        %FileInfo.TemperatureLog=[];FileInfo.TemperatureLog(1,1)=0;FileInfo.TemperatureLog(2,1)=0;FileInfo.TemperatureLog(3,1)=0;
        % write Ts data to new file
        Sr=write_data(Ts,Cs,Us,Ns);
        if ~isempty(Sr)
            System.Sr=[System.Sr; Sr];
        end
        if (System.rawrecordlength)>0 % record raw is on
            System.rawCounter=0;System.raw_series=0;
            System=initialize_raw_file([System.rname num2str(floor(FileInfo.file_series),'%04.f') '-' num2str(floor(System.raw_series),'%02.f')], System, FileInfo);
            System=write_raw(Raw, System);
        end
        System.rawCounter=System.rawCounter+1;
    end
end