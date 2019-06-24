function handles = osc_dbmake(osc_message,handles)

% OSC_DBMAKE - Create an internal instrument knowledge object from
% a set of XML description files
%
% Usage: handles = osc_dbmake(osc_message,handles)
%

% Check that no orchestration session is currently opened
if ~isempty(handles.session)
    error('orchidee:osc:osc_dbmake:ImpossibleOperation', ...
        'Close current session before creating knowledge.')
end

% Build an empty knowledge object
instrument_knowledge = knowledge();

% Get the XML description files root directory
xml_db_root = osc_message.data{2};

% Import XML files in instrument knowledge
handles.instrument_knowledge = build_knowledge(instrument_knowledge,xml_db_root,handles);