function send_version_message(handles)

% SEND_VERSION_MESSAGE - Send info on Orchidee current version
%
% Usage: send_version_message(handles)
%

% Get version info structure
v = orchidee_version();
 
% Build OSC message
message.path = '/version';
message.tt = 'ssss';
message.data{1} = v.name;
message.data{2} = v.version;
message.data{3} = v.authors;
message.data{4} = v.date;
 
% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);