function taskList = read_incubator_protocol(filename)

fprintf('Loading protocol: %s\n',filename);

%% Read table

try
    T = readtable(filename);

catch ME
    error('Unable to read protocol file:\n%s',ME.message);
end

%% Required columns

requiredColumns = { ...
    'TimeValue',...
    'Unit',...
    'Parameter',...
    'Value'};

missingColumns = ...
    setdiff(requiredColumns,...
    T.Properties.VariableNames);

if ~isempty(missingColumns)

    error( ...
        'Missing column(s): %s',...
        strjoin(missingColumns,', '));

end

%% Empty protocol

if height(T)==0

    error('Protocol contains no rows.');

end

%% Definitions

allowedUnits = { ...
    'sec',...
    'min',...
    'hour'};

allowedParameters = { ...
    'Temperature',...
    'CO2',...
    'O2',...
    'H2O',...
    'EndOfExperiment'};

%% Create output

taskList = cell(height(T),3);

%% Validation loop

for row = 1:height(T)

    %% Time

    timeValue = T.TimeValue(row);

    if ~isnumeric(timeValue) || isnan(timeValue)

        error( ...
            'Row %d: TimeValue must be numeric.',...
            row+1);

    end

    if timeValue < 0

        error( ...
            'Row %d: TimeValue must be >= 0.',...
            row+1);

    end

    %% Unit

    unit = strtrim( ...
        char(string(T.Unit(row))));

    if ~ismember(unit,allowedUnits)

        error([ ...
            'Row ' num2str(row+1) ...
            ': invalid Unit "' unit '".' newline ...
            'Allowed units: sec, min, hour']);

    end

    %% Convert to seconds

    switch unit

        case 'sec'
            executionTime = timeValue;

        case 'min'
            executionTime = timeValue*60;

        case 'hour'
            executionTime = timeValue*3600;

    end

    %% Parameter

    parameter = ...
        strtrim(char(string(T.Parameter(row))));

    if ~ismember(parameter,allowedParameters)

        error([ ...
            'Row ' num2str(row+1) ...
            ': invalid Parameter "' ...
            parameter '"' newline ...
            'Allowed parameters: ' ...
            strjoin(allowedParameters,', ')]);

    end

    %% Value

    value = T.Value(row);

    if strcmp(parameter,'EndOfExperiment')

        value = NaN;

    else

        if isempty(value) || isnan(value)

            error( ...
                'Row %d: missing Value.',...
                row+1);

        end

    end

    %% Range checks

    switch parameter

        case 'Temperature'

            if value < 0 || value > 70

                error( ...
                    'Row %d: Temperature %.2f outside range 0-70°C.',...
                    row+1,value);

            end

        case 'CO2'

            if value < 0 || value > 100

                error( ...
                    'Row %d: CO2 %.2f outside range 0-100%%.',...
                    row+1,value);

            end

        case 'O2'

            if value < 0 || value > 20

                error( ...
                    'Row %d: O2 %.2f outside range 0-20%%.',...
                    row+1,value);

            end

        case 'H2O'

            if value < 0 || value > 100

                error( ...
                    'Row %d: H2O %.2f outside range 0-100%%.',...
                    row+1,value);

            end

    end

    taskList(row,:) = ...
        {executionTime,parameter,value};

end

%% Check time ordering

times = cell2mat(taskList(:,1));

if any(diff(times)<0)

    idx = find(diff(times)<0,1);

    error([ ...
        'Protocol time order error.' newline ...
        'Row ' num2str(idx+2) ...
        ' occurs before row ' ...
        num2str(idx+1)]);

end

%% EndOfExperiment checks

isEOE = strcmp(taskList(:,2),...
    'EndOfExperiment');

if sum(isEOE)==0

    error([ ...
        'No EndOfExperiment found.' newline ...
        'Exactly one EndOfExperiment row is required.']);

end

if sum(isEOE)>1

    error( ...
        'Multiple EndOfExperiment rows found.');

end

EOErow = find(isEOE);

if EOErow ~= size(taskList,1)

    error([ ...
        'EndOfExperiment must be the last row ' ...
        'in the protocol.']);

end

%% Summary

fprintf('\n');
fprintf('Protocol loaded successfully.\n');
fprintf('Number of events : %d\n',size(taskList,1));
fprintf('Duration         : %.2f hours\n', ...
    times(end)/3600);
fprintf('\n');

end