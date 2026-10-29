%% disp_error(status)
%  Display the error code corresponding to the status code

function disp_error(status, Reason)

    msgbox (['An error has occurred:' ...
                string(Mcs.Usb.CMcsUsbNet.GetErrorText(status)) ...
        Reason]);
    uiwait
end