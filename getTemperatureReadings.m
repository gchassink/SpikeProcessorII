%% getTemperatureReadings
TemperatureLog(1,1)=double(0); 
TemperatureLog(1,2)=double(0);
TemperatureLog(1,3)=double(0);  
if isfield (Devices, 'tcxStatus') % internal temp controler
    TemperatureLog(1,1)=double(Devices.tcx.GetValue(uint32(0)))/10;
end       
if isfield (Devices, 'TC02Status')  % external temperature controler
     TemperatureLog(1,1)=double(Devices.TC02.GetHeaterTemp(0))/100; % convert to degrees C
     TemperatureLog(1,2)=double(Devices.TC02.GetThermocoupleTempAbs(0))/100;  
     TemperatureLog(1,3)=double(Devices.TC02.GetThermocoupleTempAbs(1))/100; 
end
FileInfo.TemperatureLog=[FileInfo.TemperatureLog ;TemperatureLog];

