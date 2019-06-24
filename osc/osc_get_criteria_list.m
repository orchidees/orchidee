function handles = osc_get_criteria_list(osc_message,handles)

% OSC_GET_CRITERIA_LIST - Return the list of available optimization
% criteria
%
% Usage: handles = osc_get_criteria_list(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    error('orchidee:osc:osc_get_criteria_list:UexpectedMessage', ...
        [ 'First open a session.' ]);
end

% Get criteria list
criteria = get_criteria_list(handles.session);

% Build OSC message
message.path = '/criterialist';
message.tt = 'i';
message.data{1} = osc_message.data{1};

% Add criteria to message data
for k = 1:length(criteria)
    message.tt = [ message.tt 's' ];
    message.data{k+1} = criteria{k};
end

% Add to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);