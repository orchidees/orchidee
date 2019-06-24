function handles = osc_export_solutions_light(osc_message,handles)

% OSC_EXPORT_SOLUTION_LIGHT - Export current solution set in text file
%
% Usage: handles = osc_export_solutions_light(osc_message,handles)
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
if length(osc_message.data) == 3
    if ~ischar(osc_message.data{3})
        error('orchidee:osc:osc_export_solutions:BadArgumentType', ...
            'Map file must be a string.' );
    end
    map_file = osc_message.data{3};
else
    map_file = '';
end

% Export solution set
export_solution_set_light(handles.session,handles.instrument_knowledge,osc_message.data{2},map_file,handles);