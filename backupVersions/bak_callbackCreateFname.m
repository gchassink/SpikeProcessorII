function callbackCreateFname(source,event)
    %% callbackCreateFname(source,event)
    % set filename and check it
    global System FileInfo
    [file2,path]= uiputfile('MEA-XXXX-');
    file1=split(file2,'.');
    file=file1{1};
    FileInfo.fname=[path file];
    System.rname=[path 'raw-' file];
    
    disp(FileInfo.fname);
  
    checkfile=dir([path '*' '.mat']);
    if size(checkfile,1)>0
        for i=1:size(checkfile,1)
            str{i}=checkfile(i).name;
        end
        
        pattern=regexptranslate('wildcard', [file '*.mat'] );
        matches=regexp(str, pattern);
        if length(find(cell2mat(matches)))>=1
            msgbox('File already exists, please choose another filename');
            set (source,'String','Filename');
        end
    end
    function callbackCreateFname(source,event)
    %% callbackCreateFname(source,event)
    global System FileInfo

    [file2,path] = uiputfile('MEA-XXXX-');

    if isequal(file2,0)
        return;   % User cancelled
    end

    %% Check for network location
    isNetwork = startsWith(path,'\\');   % UNC path

    % Optional: detect mapped network drives
    if ~isNetwork && ispc
        [~,netUse] = system('net use');
        if contains(netUse, upper(path(1:2)))
            isNetwork = true;
        end
    end

    if isNetwork
        choice = questdlg( ...
            ['The selected folder appears to be a network location.' newline ...
             'Writing measurement data to a network drive may be too slow.' newline ...
             'Do you want to continue?'], ...
             'Network Drive Warning', ...
             'Continue','Choose Another Folder','Choose Another Folder');

        if strcmp(choice,'Choose Another Folder')
            return;
        end
    end

    %% Check available disk space
    minFreeGB = 10;

    try
        if ispc
            driveInfo = System.IO.DriveInfo(path(1:2));
            freeGB = double(driveInfo.AvailableFreeSpace)/1024^3;
        else
            jFile = java.io.File(path);
            freeGB = double(jFile.getFreeSpace())/1024^3;
        end

        if freeGB < minFreeGB
            choice = questdlg( ...
                sprintf(['Only %.1f GB of free space is available.\n' ...
                         'At least %.1f GB is recommended.\n' ...
                         'Do you want to continue?'], ...
                         freeGB,minFreeGB), ...
                'Low Disk Space', ...
                'Continue','Choose Another Folder','Choose Another Folder');

            if strcmp(choice,'Choose Another Folder')
                return;
            end
        end

    catch ME
        warning('Unable to determine free disk space: %s',ME.message);
    end

    %% Existing code
    file1 = split(file2,'.');
    file  = file1{1};

    FileInfo.fname = [path file];
    System.rname   = [path 'raw-' file];

    disp(FileInfo.fname);

    checkfile = dir(fullfile(path,'*.mat'));

    if ~isempty(checkfile)

        str = {checkfile.name};

        pattern = regexptranslate('wildcard',[file '*.mat']);
        matches = regexp(str,pattern);

        if nnz(~cellfun(@isempty,matches)) >= 1
            msgbox('File already exists, please choose another filename');
            set(source,'String','Filename');
            return;
        end
    end

    update_filetable
end
``
     update_filetable
end