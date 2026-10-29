%% update_filetable
%  updates file information table in setup screen
function update_filetable(fig_init)
    global  System FileInfo 
    if FileInfo.adaptertype=="Mea2100" %length(FileInfo.channelorder)<70
        XScale=1;YScale=1;
   else
        XScale=1450/1300;YScale=600/500;
   end
%XScale=1600/1300;YScale=600/500;
    File_settings=cellstr([string(FileInfo.fname); string(System.rname)]);% ; num2cell([FileInfo.filelength; System.rawFileLength ]) ]);
    File_fields={'Filename', 'Filename rawstream'};%, 'filelength (s)', 'filelength rawstream (s)'};
    File_table=uitable('Data', File_settings, 'RowName' ,File_fields, 'ColumnName', 'File settings','ColumnWidth', {500},'Position', [20 YScale*(399) 700 58]);
end