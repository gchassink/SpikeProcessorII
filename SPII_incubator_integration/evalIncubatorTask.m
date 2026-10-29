function evalIncubatorTask(taskCode,setPoint)
%disp('evalIncubatorTask(taskCode,setPoint)')
global Devices

switch taskCode

    case 'EndOfExperiment'

        return

    case 'O2'

        setParam( ...
            setPoint,...
            'O2',...
            Devices.Incubator.AtmowebAddress);

        Devices.Incubator.CurrentOxygenTarget = ...
            setPoint;

    otherwise

        setParam( ...
            setPoint,...
            taskCode,...
            Devices.Incubator.AtmowebAddress);

end