function handles = osc_dbquery(osc_message,handles)

% OSC_DBQUERY - Instrument knowledge database query
%
% Usage: handles = osc_dbquery(osc_message,handles)
%

% Check input arguments
if length(osc_message.data) < 4
    error('orchidee:osc:osc_dbgetfieldvalues:IncompleteOscMessage', ...
        'At least 4 argument required for /dbquery.');
end

% get query args from OSC message
query_args = osc_message.data(3:length(osc_message.data));

% Query database
idx = query(handles.instrument_knowledge,query_args);

% Write query output in text file
write_index_file(osc_message.data{2},idx,handles);

% Build response OSC message
message.path = '/dbquery';
message.tt = 'is';
message.data{1} = osc_message.data{1};
message.data{2} = osc_message.data{2};

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);