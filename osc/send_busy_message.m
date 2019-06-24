function send_busy_message(handles,progress,message_str)

% SEND_BUSY_MESSAGE - Send busy message to client, eventually with
% a text and a float number (between 0 and 1), progress bar
%
% Usage: send_busy_message(handles,<progress>,<message_str>)
% 

% Build OSC message
message.path = '/busy';
message.tt = '';
message.data = {};

% If provided, add progress ratio to busy message
if nargin >= 2
    message.tt = 'f';
    message.data{1} = progress;
end

% If provided, add progress text to busy message
if nargin == 3
    message.tt = 'fs';
    message.data{2} = message_str;
end

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);