function send_ready_message(handles)

% SEND_READY_MESSAGE - Send a '/ready' message to client
%
% Usage: send_ready_message(handles)
%

% Build OSC message
message.path = '/ready';
message.tt = '';
message.data = {};

% Build OSC message
flux{1} = message;
 
% Send message
osc_send(handles.osc.address,flux);