function send_done_message(handles,messageid)

% SEND_DONE_MESSAGE - Send a message to client to indicate that an
% input instruction has been executed and terminated without any errors.
%
% Usage: send_done_message(handles,messageid)
%

% Build message structure
message.path = '/done';
message.tt = 'i';
message.data{1} = messageid;

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);