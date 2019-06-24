function handles = osc_dbgetscoreorder(osc_message,handles)

% OSC_DBGETSCOREORDER - Return a string of all database instruments in
% orchestral order (families are separated with the symbol '-'). The
% order is read from a preference file in ~/Library/Preferences/IRCAM/Orchidee/.
% If not preference file exist, the order is computed from a set of rules,
% and a new prefernece file is written. Hence, the score order may be easily
% modified by editing manually the preference file.
%
% Usage: handles = osc_dbgetscoreorder(osc_message,handles)
%

% Build OSC messgae
message.path = '/dbscoreorder';
message.tt = 'is';
message.data{1} = osc_message.data{1};
message.data{2} = get_score_order(handles.instrument_knowledge);

% Add message to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);