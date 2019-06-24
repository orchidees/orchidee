function handles = osc_set_resolution(osc_message,handles)

% OSC_SET_RESOLUTION - Set the microtonic resolution of the
% orchestra (1/2 tone, 1/4 tone, 1/8 tone or 1/16 tone).
%
% Usage: handles = osc_set_resolution(osc_message,handles)
%

% Open a new session if necessary
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_set_resolution:BadArgumentNumber', ...
        'Two few arguments for /setresolution.');
end

% Set resolution
handles.session = set_orchestra(handles.session,handles.instrument_knowledge,{},osc_message.data{2});
