function taskList = read_incubator_protocol(filename)

% READ_INCUBATOR_PROTOCOL
% Reads and validates an incubator protocol Excel file.
%
% Required columns:
%   Time_s
%   Parameter
%   Value

try
    T = readtable(filename);

catch ME

    error('Cannot read protocol file "%s"\n\n%s', ...
        filename, ME.message);

end

%% Check required columns

requiredCols = {'Time_s','Parameter','Value'};

missingCols = setdiff(requiredCols,...
    T.Properties.VariableNames);

if ~isempty(missingCols)

    error(['Protocol file is missing required column(s): ', ...
        strjoin(missingCols,', ')]);

end

%% Empty file

if height(T)==0

    error('Protocol file contains no protocol entries.');

end

%% Allowed parameters

allowedParameters = { ...
    'Temperature',...
    'CO2',...
    'O2',...
    'H2O',...
    'EndOfExperiment'};

%% Validate rows

nRows = height(T);

taskList = cell(nRows,3);

for row = 1:nRows

    %% Time

    curTime = T.Time_s(row);

    if ~isscalar(curTime) || isnan(curTime)

        error(['Invalid Time_s value in row ', ...
            num2str(row+1), ...
            '. Time must be numeric.']);

    end

    if curTime < 0

        error(['Negative Time_s found in row ', ...
            num2str(row+1), ...
            '. Time must be >= 0 seconds.']);

    end

    %% Parameter

    param = strtrim(char(string(T.Parameter(row))));

    if isempty(param)

        error(['Empty Parameter field in row ', ...
            num2str(row+1)]);

    end

    if ~ismember(param,allowedParameters)

        error([...
            'Unknown parameter "' param '" in row ' ...
            num2str(row+1) newline ...
            'Allowed values:' newline ...
            strjoin(allowedParameters,', ') ...
            ]);

    end

    %% Value

    if strcmp(param,'EndOfExperiment')

        value = NaN;

    else

        value = T.Value(row);

        if isempty(value) || isnan(value)

            error([...
                'Missing Value for parameter "' ...
                param ...
                '" in row ' ...
                num2str(row+1)]);

        end

    end

    taskList(row,:) = {curTime,param,value};

end

%% Sort by time

times = cell2mat(taskList(:,1));

[~,idx] = sort(times);

taskList = taskList(idx,:);

%% Check EndOfExperiment

isEOE = strcmp(taskList(:,2),'EndOfExperiment');

numEOE = sum(isEOE);

if numEOE==0

    error([ ...
        'No EndOfExperiment event found.' ...
        newline ...
        'Protocol must contain exactly one EndOfExperiment entry.']);

end

if numEOE>1

    error([ ...
        'Multiple EndOfExperiment events found.' ...
        newline ...
        'Only one EndOfExperiment entry is allowed.']);

end

if ~isEOE{end}

    error([ ...
        'EndOfExperiment must be the final event ' ...
        'in the protocol.']);

end

%% Check value ranges

for row = 1:size(taskList,1)

    param = taskList{row,2};
    value = taskList{row,3};

    switch param

        case 'Temperature'

            if value < 0 || value > 70

                error(['Temperature out of range in row ', ...
                    num2str(row), ...
                    '. Allowed range: 0-70 °C']);

            end

        case 'CO2'

            if value < 0 || value > 100

                error(['CO2 out of range in row ', ...
                    num2str(row), ...
                    '. Allowed range: 0-100 %%']);

            end

        case 'O2'

            if value < 0 || value > 20

                error(['O2 out of range in row ', ...
                    num2str(row), ...
                    '. Allowed range: 0-20 %%']);

            end

        case 'H2O'

            if value < 0 || value > 90

                error(['Humidity out of range in row ', ...
                    num2str(row), ...
                    '. Allowed range: 0-90 %%']);

            end

    end

end

%% Success message

fprintf('\n');
fprintf('Protocol loaded successfully\n');
fprintf('Events: %d\n',size(taskList,1));
fprintf('Duration: %.1f hours\n', ...
    taskList{end,1}/3600);
fprintf('\n');

end