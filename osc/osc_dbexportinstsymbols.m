function handles = osc_dbexportinstsymbols(osc_message,handles)

% OSC_DBEXPORTINSTSYMBOLS - Export in a text file the symbols, folders and
% families of the instruments in the database.
%
% Usage: handles = osc_dbexportinstsymbols(osc_message,handles)
%

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbexportinstsymbols:IncompleteOscMessage', ...
        '/dbexportinstsymbols requires 2 arguemnts.')
end

symbolfile = osc_message.data{2};

if ~ischar(symbolfile)
    error('orchidee:osc:osc_dbexportinstsymbols:BadArgumentType', ...
        'Output file name must be a string.')
end

% export file
export_instrument_symbol_info(handles.instrument_knowledge, symbolfile, handles);