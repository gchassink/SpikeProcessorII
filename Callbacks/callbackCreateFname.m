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
    jFile = java.io.File(path);
    freeGB = double(jFile.getFreeSpace()) / 1024^3;

    if freeGB < 10
        msgbox(sprintf('Only %.1f GB free disk space available.', freeGB), ...
               'Low Disk Space');
    end

catch ME
    fprintf('Could not determine free disk space:\n%s\n', ME.message);
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
