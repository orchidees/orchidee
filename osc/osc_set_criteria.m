function handles = osc_set_criteria(osc_message,handles)

% OSC_SET_CRITERIA - Define optimization current criteria
%
% Usage: handles = osc_set_criteria(osc_message,handles)
%

% Open session if necessary
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% Check input args
if length(osc_message.data) < 2
    error('orchidee:osc:osc_set_filter:BadArgumentNumber', ...
        [ 'At least one critierion is needed.' ]);
end

% Get criteria list from OSC message
criteria_list = osc_message.data(2:length(osc_message.data));

% Set criteria
handles.session = set_criteria(handles.session,criteria_list);