function handles = osc_new_session(osc_message,handles)

% OSC_NEW_SESSION - Open a new orchestration session
%
% Usage: handles = osc_new_session(osc_message,handles)
%

% Open new session
server_says(handles,'Open new session ...',0);
handles.session = session(handles.instrument_knowledge);
server_says(handles,'Open new session ...',1);

% Reset target parameters in client interface
handles = osc_get_targetparameters(osc_message,handles);