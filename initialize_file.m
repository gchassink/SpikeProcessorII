%% FileInfo = initialize_file(Name, FileInfo)
% initiates a new data storage file
function FileInfo = initialize_file(Name, FileInfo)

    %System.lostDataCycleCount=0; %reset counter    
    time=clock;
    FileInfo.Name=Name;
    FileInfo.FileDate=[int2str(time(1)),'-',int2str(time(2)),'-',int2str(time(3))];
    FileInfo.FileStartTime=[int2str(time(4)),':',int2str(time(5)),':',int2str(time(6))];
    
    mat = matfile([Name '.mat'],'Writable',true);
    mat.Ts=double([]);
    mat.Cs=uint16([]);
    mat.Us=int16([]);
    mat.Ns=double([]);
    mat.Sr=double([]);
    mat.Tc=double([]);
    mat.FileInfo=FileInfo;

end