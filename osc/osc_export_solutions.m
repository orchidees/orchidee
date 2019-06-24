function handles = osc_export_solutions(osc_message,handles)

% OSC_EXPORT_SOLUTION - Export current solution set in text file
%
% Usage: handles = osc_export_solutions(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    error('orchidee:osc:osc_get_attribute_domain:UexpectedMessage', ...
        [ 'First open a session.' ]);
end

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_export_solutions:IncompleteOscMessage', ...
        'Export file is missing.');
end
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_export_solutions:BadArgumentType', ...
        'Export file must be a string.' );
end

% Export solution set
export_solution_set(handles.session,handles.instrument_knowledge,osc_message.data{2},handles);