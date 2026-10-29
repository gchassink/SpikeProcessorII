function record_incubator_values(nowTime)

global Devices
%disp('record_incubator_values(nowTime)')
[temp,ok1] = readParam( ...
    'Temperature', ...
    Devices.Incubator.AtmowebAddress);

[hum,ok2] = readParam( ...
    'H2O', ...
    Devices.Incubator.AtmowebAddress);

[co2,ok3] = readParam( ...
    'CO2', ...
    Devices.Incubator.AtmowebAddress);

[o2,ok4] = readParam( ...
    'O2', ...
    Devices.Incubator.AtmowebAddress);

if ~(ok1 && ok2 && ok3 && ok4)
    return
end

Devices.Incubator.Log.Time(end+1) = nowTime;

Devices.Incubator.Log.Temperature(end+1) = temp;

Devices.Incubator.Log.Humidity(end+1) = hum;

Devices.Incubator.Log.CO2(end+1) = co2;

Devices.Incubator.Log.O2(end+1) = o2;