function [paramVal,ok] = ...
    readParam(taskCode,atmowebAddress)
%disp('readParam(taskCode,atmowebAddress)')
ok = false;
paramVal = NaN;

switch taskCode

    case 'Temperature'
        readString = 'Temp1Read';

    case 'H2O'
        readString = 'HumRead';

    case 'CO2'
        readString = 'CO2Read';

    case 'O2'
        readString = 'O2Read';

    otherwise
        return

end

answer = sendAtmowebMsg( ...
    [readString '='],...
    atmowebAddress);

if ~isempty(answer)

    if isfield(answer,readString)

        paramVal = answer.(readString);
        ok = true;

    end

end