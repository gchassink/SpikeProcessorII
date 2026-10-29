function initialize_incubator()

global Devices

Devices.Incubator = struct;

Devices.Incubator.Enabled = false;

Devices.Incubator.AtmowebAddress = ...
    'http://169.254.106.221/atmoweb?'; %top incubator

Devices.Incubator.ValveAddress = ...
    'http://169.254.106.200/io.cgi?';

Devices.Incubator.RelayNum = '1'; % top incubator

disp('Checking incubator connection...')

try

    answer = sendAtmowebMsg( ...
        'Temp1Read=', ...
        Devices.Incubator.AtmowebAddress);

    if isempty(answer)

        warning('No incubator detected.');

    else

        Devices.Incubator.Enabled = true;

        disp('Incubator connected.');

    end

catch

    warning('Unable to connect to incubator.');

end

Devices.Incubator.UpdateInterval = 5;      % seconds
Devices.Incubator.LastUpdateTime = -Inf;

Devices.Incubator.CurrentTaskIdx = 1;
Devices.Incubator.CurrentOxygenTarget = NaN;

Devices.Incubator.OxygenMax = 20;
Devices.Incubator.MarginPercentage = 1;
Devices.Incubator.OpenTime = 2;

Devices.Incubator.TaskList = {};

Devices.Incubator.Log.Time = [];
Devices.Incubator.Log.Temperature = [];
Devices.Incubator.Log.Humidity = [];
Devices.Incubator.Log.CO2 = [];
Devices.Incubator.Log.O2 = [];


