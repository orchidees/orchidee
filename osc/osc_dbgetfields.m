function handles = osc_dbgetfields(osc_message,handles)

% OSC_DBGETFIELD - Get the list of instrument knowledge database
% fieldnames
%
% Usage: handles = osc_dbgetfields(osc_message,handles)
%

% Get databse fields
dbfields = get_fields_info(handles.instrument_knowledge,'list');

% Check if output is specified
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbgetfields:MissingOutput', ...
        [ 'Output (''message'' or filename) is missing.' ]);
end

% Check that output is a string
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_dbgetfields:BadArgumentType', ...
        [ 'Output (''message'' or filename) must be a string.' ]);
end

% If output is the 'message' keyword, send back the field list in
% the OSC message
if strcmp(osc_message.data{2},'message')

    % Build OSC message
    message.path = '/dbfields';
    message.tt = 'i';
    message.data{1} = osc_message.data{1};

    % Append BD fields to message data
    for i = 1:length(dbfields)
        message.data{i+1} = dbfields{i};
        message.tt = [ message.tt 's' ];
    end

    % Add to OSC buffer
    flux{1} = message;

    % Send message
    osc_send(handles.osc.address,flux);

else
    
    % Write DB fields in output file
    write_data_file(osc_message.data{2},dbfields,handles);
    
    % Send back the OSC message
    message.path = '/dbfields';
    message.tt = 'is';
    message.data{1} = osc_message.data{1};
    message.data{2} = osc_message.data{2};
    
    % Add to OSC buffer
    flux{1} = message;

    % Add to OSC buffer
    osc_send(handles.osc.address,flux);
    
end