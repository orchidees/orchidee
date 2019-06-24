function handles = osc_dbexportmap(osc_message,handles)

% OSC_DBEXPORTMAP - Export basic information about the knowledge
% database items in a text file.
%
% Usage: handles = osc_dbexportmap(osc_message,handles)
%

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbexportmap:IncompleteOscMessage', ...
        '/dbexportmap requires 2 arguemnts.')
end
mapfile = osc_message.data{2};
if ~ischar(mapfile)
    error('orchidee:osc:osc_dbexportmap:BadArgumentType', ...
        'Output file name must be a string.')
end

export_map(handles.instrument_knowledge,mapfile,handles);