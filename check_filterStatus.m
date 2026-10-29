%% check filter status:
global System FileInfo Devices Figures;
    HeadstageFilters = Devices.dacq.GetFilterProperties(Mcs.Usb.DacqGroupChannelEnumNet.HeadstageElectrodeGroup);
    BaseFilter=structfun(@string,struct(HeadstageFilters(1))); % Read object into struct. this issues a warning about private data, but since we only extract data from the object and not pass to, it is not a problem (so warning is suppressed)
    HighpassFilter=structfun(@string,struct(HeadstageFilters(2))); % Read object into struct.
    LowpassFilter=structfun(@string,struct(HeadstageFilters(3))); % Read object into struct.
    FileInfo.Filters=cellstr([BaseFilter, HighpassFilter, LowpassFilter]);
    System.FilterCharacteristics={'FilterActive', 'FilterType', 'FilterFamily', 'FilterBand', 'Order', 'CornerFrequency', 'CornerFrequencymHz'};
    System.filterTypes={'BaseFilter', 'HighpassFilter', 'LowpassFilter'};
    uitable('Data', FileInfo.Filters(1:6,:), ...
        'RowName', System.FilterCharacteristics(1:6),...
        'ColumnName', System.filterTypes,...
        'Position', [20 20 397 130]);