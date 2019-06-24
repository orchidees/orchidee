function handles = osc_orchestrate(osc_message,handles)

% OSC_ORCHESTRATE - Run the orchestration algorithm
%
% Usage: handles = osc_orchestrate(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    error('orchidee:osc:osc_get_criteria_list:UexpectedMessage', ...
        [ 'First open a session.' ]);
end

% Run the orchestration algorithm
handles.session = orchestrate(handles.session,handles.instrument_knowledge,handles);