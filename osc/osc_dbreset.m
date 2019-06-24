function handles = osc_dbreset(osc_message,handles)

% OSC_DBRESET - Reset knowledge instance to default knowledge
%
% Usage: handles = osc_dbreset(osc_message,handles)
%

% Check that current session is closed
if ~isempty(handles.session)
    error('orchidee:osc:osc_dbreset:ImpossibleOperation', ...
        'Close current session before loading knowledge.')
end

% Load default knowledge
server_says(handles,'Load default instrument knowledge',0);
default_knowledge = load('default_knowledge.mat');
handles.instrument_knowledge = default_knowledge.instrument_knowledge;
server_says(handles,'Load default instrument knowledge',1);

% Export DB Map
!rm ~/Library/Preferences/IRCAM/Orchidee/dbmap
export_map(handles.instrument_knowledge, '~/Library/Preferences/IRCAM/Orchidee/dbmap', handles);

% Clear scoreorder preference file
!rm ~/Library/Preferences/IRCAM/Orchidee/scoreorder*