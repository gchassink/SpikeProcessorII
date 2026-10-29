function ok = setParam( ...
    ParamValue,...
    taskCode,...
    atmowebAddress)
%disp('setParam')
ok = false;

switch taskCode

    case 'Temperature'
        setString = 'TempSet';

    case 'H2O'
        setString = 'HumSet';

    case 'CO2'
        setString = 'CO2Set';

    case 'O2'
        setString = 'O2Set';

    otherwise
        return

end

getStr = sprintf( ...
    '%s=%g&%s=', ...
    setString,...
    ParamValue,...
    setString);

answer = sendAtmowebMsg( ...
    getStr,...
    atmowebAddress);

if ~isempty(answer)

    if isfield(answer,setString)

        ok = true;

    end

end