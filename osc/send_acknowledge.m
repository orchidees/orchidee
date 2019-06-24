function send_acknowledge(handles,messageid)

% SEND_ACKNOLEDGE - Send a message to client that acknowledge the
% reception of an incoming OSC message (containing a identifyer)
%
% Usage: send_acknowledge(handles,messageid)
%

% Build message structure
message.path = '/acknowledge';
message.tt = 'i';
message.data{1} = messageid;

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);

% Remove eventual old interrupt file
if exist('/tmp/orchideeinterrupt','file')
    !rm /tmp/orchideeinterrupt
end