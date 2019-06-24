function handles = osc_setoutport(osc_message, handles)

% OSC_SETOUTPORT - Set a new OSC out port (useful if you wanna change your
% client, e.g. switch from MaxMSP to OopenMusic and vice versa. We have
% experienced some bugs with this function, so please use it with care.
%
% Usage: handles = osc_setoutport(osc_message, handles)
%

% Check input args
if length(osc_message.data) < 2
    error('orchidee:osc:setoutport:BadArgumentNumber', ...
        [ 'OSC port is missing.' ]);
end

% Check that OSC port is a number
if ~isnumeric(osc_message.data{2})
    error('orchidee:osc:setoutport:BadArgumentType', ...
        [ 'OSC port must be an positive integer.' ]);
end

% Check that OSC port is a positive interger
if osc_message.data{2} < 0
    error('orchidee:osc:setoutport:BadArgumentValue', ...
        [ 'OSC port must be an positive integer.' ]);
end
if osc_message.data{2} ~= floor(osc_message.data{2})
    error('orchidee:osc:setoutport:BadArgumentValue', ...
        [ 'OSC port must be an positive integer.' ]);
end

% Check that OSC port is a lower or equal to 9999
if osc_message.data{2} > 9999
    error('orchidee:osc:setoutport:BadArgumentValue', ...
        [ 'OSC port must be lower or equal than 9999.' ]);
end

% Check that OSC port is different than Orchidee's listening port
if osc_message.data{2} == handles.osc.settings.receiveport
    error('orchidee:osc:setoutport:BadArgumentValue', ...
        [ num2str(handles.osc.settings.receiveport) ' is Orchidee''s listening port.' ]);
end

% Try to open an new OSC connection
try
    new_address = osc_new_address(handles.osc.settings.ip, osc_message.data{2});
catch
    error('orchidee:osc:setoutport:UnavaiableOscPort', ...
        [ num2str(osc_message.data{2}) ' is not available.' ]);
end

% Set new port in OSC settings
%osc_free_address(handles.osc.address);
% Surprinsingly it does not crach when the old osc address is not trashed.
% Don't really understand why...
handles.osc.address = new_address;
handles.osc.settings.sendport = osc_message.data{2};