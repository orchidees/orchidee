function handles = osc_set_targetparameters(osc_message,handles)

% OSC_SET_TARGETPARAMETERS - Set target analysis parameters
%
% Usage: handles = osc_set_targetparameters(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% 
if length(osc_message.data) < 3
    error('orchidee:osc:osc_set_targetparameters:BadArgumentNumber', ...
        'Two few arguments for /settargetparameters.');
end

% Get parameter/value list from OSC message
true_mess = osc_message.data(2:length(osc_message.data));

% Check that parameter/value list is valid
if mod(length(true_mess),2)
    error('orchidee:osc:osc_set_targetparameters:BadArgumentNumber', ...
        '/settargetparameters expects a even number of arguments.');
end

% Iterate on list elements and set target parameters
for k = 1:length(true_mess)/2 
    handles.session = set_target_parameter(handles.session,true_mess{2*k-1},true_mess{2*k});
end