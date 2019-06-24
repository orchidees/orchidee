function handles = osc_dbupdate(osc_message,handles)

% OSC_DBUPDATE - Update current insturment knowledge object by
% adding new XML desciption files

% Check input arguments
if ~isempty(handles.session)
    error('orchidee:osc:osc_dbupdate:ImpossibleOperation', ...
        'Close current session before updating knowledge.')
end

% Get XML files root directory
xml_db_root = osc_message.data{2};

% Update knowledge
handles.instrument_knowledge = update_knowledge(handles.instrument_knowledge,xml_db_root,handles);