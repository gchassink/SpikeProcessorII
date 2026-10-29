%% initialize_filter

% The MEA2100 amplifier with blanking circuit is a 120-channel headstage with 
% a hardware defined bandwidth. Default settings for the hardware filter will 
% be 1 Hz to 3 kHz. However, a different bandwidth can be achieved by an 
% additional software program, called ???MEA2100 Configuration???, 
% no hardware modification is necessary.
% Next to this the mcs software has additional harware filters in the
% IFB both kan be set by software. the headstage filter is for basic
% filtering (onl butterwirth) the IFB is for feedback adjustable filters
% and is complicated

% it turns out that these hardware filters sometimes go off when not using
% the MC-rack before starting the matlabsoftware
% you can use the GetFilterProperties function of the CMcsUsbDacqNet class 
% to retrieve the current filter settings. Typically, you would invoke this
% from the meaDevice object that you are using for data acquisition:
% This returns an array of CFilterPropertyNet objects that describe the
% headstage filters for the electrode data. You can read out other filters
% using other entries of the DacqGroupChannelEnumNet enum.

%% Set filters not implemented yet, please use MCS filter configuration tool
disp('initialize filter not implemented yet please use MCS filter configuration tool');
system('McsFilterConfig.lnk');%invokes an external filter settings program
% Mcs.Usb.CFilterPropertyNet.CornerFrequency=double(300)
% Mcs.Usb.CFilterPropertyNet.CornerFrequencymHz=uint32(300000)
% Mcs.Usb.CFilterPropertyNet.Order=uint32(2)
% Mcs.Usb.CFilterPropertyNet.FilterBand='Highpass'
% Mcs.Usb.CFilterPropertyNet.FilterFamily='Bessel'
% Mcs.Usb.CFilterPropertyNet.FilterType='software'
% Mcs.Usb.CFilterPropertyNet.FilterActive=1
%SetFilterParameter() [1/2] void SetFilterParameter (
% DacqGroupChannelEnumNet GroupID,
% uint32_t FilterNumber,
% CFilterCoefficientsNet^ Coefficients,
% CFilterPropertyNet^ FilterProp )
%dacq.SetFilterParameter(Mcs.Usb.DacqGroupChannelEnumNet.HeadstageElectrodeGroup, 2, Mcs.Usb.CFilterCoefficientsNet(), Mcs.Usb.CFilterPropertyNet() )

