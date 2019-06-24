function send_quit_message(handles)

% SEND_QUIT_MESSAGE - Send a '/quit' message to client. This is the
% last message sent by Orchidee server befoire it quits.
%
% Usage: send_quit_message(handles)
%

% Build OSC message
message.path = '/quit';
message.tt = '';
message.data = {};
 
% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);