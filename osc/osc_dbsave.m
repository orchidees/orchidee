function handles = osc_dbsave(osc_message,handles)

% OSC_DBSAVE - Save an insturment knowledge object in an external
% mat file.
%
% Usage: handles = osc_dbsave(osc_message,handles)
%

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbsave:IncompleteOscMessage', ...
        '/dbsave requires 2 arguemnts.')
end

% Save knowledge object on disk
server_says(handles,[ 'Save user instrument knowledge: ' osc_message.data{2} ],0);
instrument_knowledge = handles.instrument_knowledge;
cmd = [ 'save ' osc_message.data{2} ' instrument_knowledge' ];
eval(cmd);
server_says(handles,[ 'Save user instrument knowledge: ' osc_message.data{2} ],1);