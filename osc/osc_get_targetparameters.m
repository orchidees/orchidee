function handles = osc_get_targetparameters(osc_message,handles)

% OSC_GET_TARGETPARAMETERS - Get target analysis parameters
%
% Usage: handles = osc_get_targetparameters(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    error('orchidee:osc:osc_get_targetparameters:UexpectedMessage', ...
        [ 'First open a session.' ]);
end

% Get analysis parameters
params = get_target_parameter(handles.session);

% Get parameter names
param_names = fieldnames(params);

% Build OSC message
message.path = '/targetparameters';
message.tt = 'i';
message.data{1} = osc_message.data{1};

% Add analysis parameters to OSC data
for k = 1:length(param_names)
    message.tt = [ message.tt 's' ];
    message.data{2*k} = param_names{k};
    if isnumeric(params.(param_names{k}))
        message.tt = [ message.tt 'f' ];
    else
        message.tt = [ message.tt 's' ];
    end
        message.data{2*k+1} = params.(param_names{k});
end

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);