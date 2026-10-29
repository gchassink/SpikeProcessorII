%% mea_cleanup(device)
% stops all processes on the mea device and disconnects from it to make it 
% available again for another instance of this or other software
function mea_cleanup(Devices)
%global Devices FileInfo
%Close connection with device when interface is closed or crashes.
    Devices.dacq.StopDacq();
    Devices.stg.SendStop(uint32(1)); 
    Devices.stg.Disconnect();
    Devices.dacq.Disconnect();
    if isfield (Devices, 'tcxStatus')
        %Devices.tcx.SetOnOff(uint32(0), true)
        Devices.tcx.Disconnect();
    end
    if isfield (Devices, 'TC02Status')
        %Devices.TC02.SetOnOff(uint32(0), true)
        Devices.TC02.Disconnect();
    end
    clear Devices;
end