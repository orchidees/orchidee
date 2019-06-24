function server_says(handles,message,progress)

% SERVER_SAYS - Display information about a running process in the
% Matlab shell or send a busy OSC message.
%
% Usage: server_says(handles,message,<progress>)
%

% Assign default value for optional arg
if nargin < 3
    progress = 0;
end

if isfield(handles,'osc');
    % If in server mode, send a busy OSC message
    send_busy_message(handles,progress,message)
else
    % Else display message in shell
    disp(message);
end