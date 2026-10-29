function sendValveMsg( ...
    command,...
    timeSquare,...
    valveAddress,...
    relayNum)
%disp('sendValveMsg')
import matlab.net.*
import matlab.net.http.*

switch command

    case 'square'

        getString = sprintf( ...
            'DOA%s=%d', ...
            relayNum,...
            round(timeSquare*10));

    otherwise

       return

end

r = RequestMessage;

uri = URI([valveAddress getString]);

try

    send(r,uri);

catch

end