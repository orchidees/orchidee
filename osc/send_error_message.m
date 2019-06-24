function send_error_message(handles)

% SEND_ERROR_MESSAGE - When an exception is raised somewhere in the
% Matlab code, return the error stack first element (last function
% call) as an error message to client.
%
% Usage: send_error_message(handles)
%

% Get last error structure
err_s = lasterror;
    
% Parse error message
pat = '\n';
pos = regexp(err_s.message,pat)+1;
if isempty(pos)
    pos = find(err_s.message=='>',1,'last')+2;
end
if isempty(pos)
    message.data{1} = err_s.message;
else
    message.data{1} = err_s.message(pos:length(err_s.message));
end
    
% Build OSC message
message.path = '/error';
message.tt = 'ssssi';
message.data{2} = 'In';
message.data{3} = err_s.stack(1).name;
message.data{4} = 'line';
message.data{5} = err_s.stack(1).line;

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);