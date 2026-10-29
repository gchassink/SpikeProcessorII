function update_incubator()
%disp('update_incubator()')
global Devices FileInfo

if ~isfield(Devices.Incubator,'Enabled')
    return
end

if ~Devices.Incubator.Enabled
    return
end

nowTime = ...
    double(FileInfo.RecordingTime) / ...
    double(FileInfo.Samplerate);

% FileInfo.RecordingTime=FileInfo.RecordingTime+1;% for debugging only!!
% nowTime=FileInfo.RecordingTime;
if nowTime - Devices.Incubator.LastUpdateTime < ...
        Devices.Incubator.UpdateInterval

    return
end
tic
Devices.Incubator.LastUpdateTime = nowTime;

process_incubator_tasks(nowTime);

record_incubator_values(nowTime);

check_oxygen_control();
FileInfo.IncubatorLog = Devices.Incubator.Log;
FileInfo.incToc(end+1)=toc;