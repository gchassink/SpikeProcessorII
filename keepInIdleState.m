
global System Devices FileInfo

FileInfo.RecordingTime=double(0);% time expressed is amount of datapoints
Totalspikes=0;
Firstcycle=1;
if exist('Carry1','var')
   if System.Replayer==0 
    Devices.dacq.StopDacq();
   end
    clear Carry1 Carry2
end
if  isfile ('recording_on.mat')
    recordingIsOff;
end