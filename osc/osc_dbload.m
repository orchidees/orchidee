function handles = osc_dbload(osc_message,handles)

% OSC_DBLOAD - Load an instrument knowledge database from disk
%
% Usage: handles = osc_dbload(osc_message,handles)
%

% Check that no session is opened
if ~isempty(handles.session)
    error('orchidee:osc:osc_dbload:ImpossibleOperation', ...
        'Close current session before loading knowledge.')
end

% Check argument number
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbload:IncompleteOscMessage', ...
        '/load requires 2 arguemnts.')
end

% Load database
server_says(handles,[ 'Load user instrument knowledge: ' osc_message.data{2} ],0);
instrument_knowledge = load(osc_message.data{2});
handles.instrument_knowledge = instrument_knowledge.instrument_knowledge;
server_says(handles,[ 'Load user instrument knowledge: ' osc_message.data{2} ],1);
