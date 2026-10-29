function data = sendAtmowebMsg( ...
    getString,...
    atmowebAddress)
%disp('sendAtmowebMsg')
import matlab.net.*
import matlab.net.http.*

r = RequestMessage;

uri = URI([atmowebAddress getString]);

try

    resp = send(r,uri);

    data = jsondecode( ...
       ['{' ...
        char(resp.Body.Data(1:end-2)') ...
        '}']);

catch

    data = [];

end