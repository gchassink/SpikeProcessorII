function process_incubator_tasks(nowTime)

global Devices
%disp('process_incubator_tasks(nowTime)')
if isempty(Devices.Incubator.TaskList)
    return
end

while Devices.Incubator.CurrentTaskIdx <= ...
        size(Devices.Incubator.TaskList,1)

    taskTime = ...
        Devices.Incubator.TaskList{Devices.Incubator.CurrentTaskIdx,1};

    if taskTime > nowTime
        break
    end

    taskCode = ...
        Devices.Incubator.TaskList{Devices.Incubator.CurrentTaskIdx,2};

    taskValue = ...
        Devices.Incubator.TaskList{Devices.Incubator.CurrentTaskIdx,3};

    evalIncubatorTask(taskCode,taskValue);

    Devices.Incubator.CurrentTaskIdx = ...
        Devices.Incubator.CurrentTaskIdx + 1;

end