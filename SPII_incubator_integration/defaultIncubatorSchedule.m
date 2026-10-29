global Devices FileInfo

if Devices.Incubator.Enabled

% Devices.Incubator.TaskList = {
%      0,'Temperature',37
%      0,'CO2',5
%      0,'O2',20
%  10,'O2',15
%   20,'Temperature',36
%   30,'O2',20
%   40,'O2',15
%   50,'Temperature',36
%   60,'O2',20
%   120,'EndOfExperiment',NaN
% };



Devices.Incubator.TaskList = ...
    read_incubator_protocol( ...
    'IncubatorProtocolTemplate_WithFormulas.xlsx');
disp('incubator schedule loaded');

%disp(num2str(Devices.Incubator.TaskList));




%% Extract schedule
taskList = Devices.Incubator.TaskList;

% Experiment end time
endIdx = strcmp(taskList(:,2),'EndOfExperiment');
tEnd = taskList{endIdx,1}/3600;

% Parameters present in schedule
allPar = unique(taskList(~endIdx,2));

%% Create figure
hFig = figure('Name','Incubator Schedule',...
              'NumberTitle','off');

for p = 1:numel(allPar)

    param = allPar{p};

    % Rows belonging to this parameter
    idx = strcmp(taskList(:,2),param);

    t = cell2mat(taskList(idx,1))/3600;
    v = cell2mat(taskList(idx,3));

    % Extend to experiment end
    t = [t; tEnd];
    v = [v; v(end)];

    subplot(numel(allPar),1,p)
    stairs(t,v,'LineWidth',2)
    grid on
    ylabel(param)

    if p == 1
        title('Incubator Parameter Schedule')
    end

    if p == numel(allPar)
        xlabel('Time (hours)')
    end
end

%% Ask for approval
reply = questdlg( ...
    'Is the displayed schedule correct?', ...
    'Schedule Verification', ...
    'OK','Cancel','OK');

if strcmp(reply,'OK')

    % Filename can be provided later in your script
    saveName = [FileInfo.fname '-Incubator_schedule'];   % replace later

    exportgraphics(hFig,[saveName '.png'],...
        'Resolution',300);

    disp(['Figure saved as ' saveName '.png']);

    FileInfo.Incubator=Devices.Incubator; % to backup Setting in case of crash

else

    disp('Schedule rejected, figure not saved.');

end

%% Close figure and continue
close(hFig);

disp('Continuing experiment setup...');
else

    warning(['Protocol file ignored because ' ...
             'no incubator is connected.']);

    Devices.Incubator.TaskList = {};

end