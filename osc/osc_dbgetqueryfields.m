function handles = osc_dbgetqueryfields(osc_message,handles)

% OSC_DBGETFIELDS - Return queryable fields of instrument knowledge
% database
%
% Usage: handles = osc_dbgetqueryfields(osc_message,handles)
%

% Get DB query able fields
dbfields = get_fields_info(handles.instrument_knowledge,'list');
queryable = get_fields_info(handles.instrument_knowledge,'query');
queryfields = dbfields(find(queryable));
[t, idx] = ismember('dir', queryfields);
if t
    queryfields = [ queryfields(1:idx-1) queryfields(idx+1:length(queryfields)) ];
end


% Check if output is specified
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbgetqueryfields:MissingOutput', ...
        [ 'Output (''message'' or filename) is missing.' ]);
end

% Check that output is a string
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_dbgetqueryfields:BadArgumentType', ...
        [ 'Output (''message'' or filename) must be a string.' ]);
end

% If output is the 'message' keyword, send back the field list in
% the OSC message
if strcmp(osc_message.data{2},'message')

    % Build OSC message
    message.path = '/dbqueryfields';
    message.tt = 'i';
    message.data{1} = osc_message.data{1};

    % Append BD fields to message data
    for i = 1:length(queryfields)
        message.data{i+1} = queryfields{i};
        message.tt = [ message.tt 's' ];
    end

    % Add to OSC buffer
    flux{1} = message;

    % Send message
    osc_send(handles.osc.address,flux);

else
    
    % Write DB fields in output file
    write_data_file(osc_message.data{2},queryfields,handles);
    
    % Send back the OSC message
    message.path = '/dbqueryfields';
    message.tt = 'is';
    message.data{1} = osc_message.data{1};
    message.data{2} = osc_message.data{2};
    
    % Add to OSC buffer
    flux{1} = message;

    % Send message
    osc_send(handles.osc.address,flux);
    
end