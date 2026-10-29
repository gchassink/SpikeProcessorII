function logError(msg)
    global System FileInfo
    System.logEntryCounter=System.logEntryCounter+1;
    FileInfo.log{System.logEntryCounter,2}=msg;
    FileInfo.log{System.logEntryCounter,1}=FileInfo.RecordingTime;
    fprintf(2,[ num2str(FileInfo.log{System.logEntryCounter,1}) '--']);
    fprintf(2,char(FileInfo.log{System.logEntryCounter,2}));
    fprintf(2,'\n');
    % make sure that latest logs are written to disk before critical error
    % comment out below to make writing the error not a bottleneck
%     if isfield(FileInfo, 'Name')
%     mat = matfile(FileInfo.Name,'Writable',true); 
%     mat.FileInfo=FileInfo;
%     end
end