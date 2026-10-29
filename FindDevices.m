global System FileInfo Devices Figures;
%Devices.devicelist = Mcs.Usb.CMcsUsbListNet(Mcs.Usb.DeviceEnumNet.MCS_DEVICE_USB);
%Devices.dacq=Devices.devicelist.GetUsbListEntry(0);

%if Devices.dacq==[]
Devices.dacq= Mcs.Usb.CMeaUSBDeviceNet();
Devices.stg=Mcs.Usb.CStg200xDownloadNet();
Devices.tcx=Mcs.Usb.CTcxDeviceNet();%deze moet pas later bij mea2100
%Devices.multiwell=Mcs.Usb.CMultiwellDeviceNet();
%Devices.dacq=Mcs.Usb.CMultiwellDeviceNet();
Devices.devicelist = Mcs.Usb.CMcsUsbListNet(Mcs.Usb.DeviceEnumNet.MCS_DEVICE_USB);
%end
initialize_incubator() % connect to an incubator if present
