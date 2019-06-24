function handles = osc_dbeasyupdate(osc_message,handles)

% OSC_DBEASYUPDATE - Auto update current insturment knowledge. Scan, analyze and import every
% directory in the 'sounds' directory of the database root dir.
% Usage: handles = osc_dbeasyupdate(osc_message,handles)
%

% Check input arguments
if ~isempty(handles.session)
    error('orchidee:osc:osc_dbeasyupdate:ImpossibleOperation', ...
        'Close current session before updating knowledge.')
end
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbeasyupdate:IncompleteOscMessage', ...
        '/dbexportmap requires 2 arguemnts.')
end
mapfile = osc_message.data{2};
if ~ischar(mapfile)
    error('orchidee:osc:osc_dbeasyupdate:BadArgumentType', ...
        'Output file name must be a string.')
end

% Get DB files root directory
db_root = osc_message.data{2};
if ~exist(db_root)
    error('orchidee:osc:osc_dbeasyupdate:NonExistingDirectory', ...
        ['''' db_root ''' does bot exist.'] );
end
db_root_sounds = [ db_root '/sounds/' ];
if ~exist(db_root_sounds), mkdir(db_root_sounds); end
db_root_xml = [ db_root '/xml/' ];
if ~exist(db_root_xml), mkdir(db_root_xml); end

% Get sound directories to be scanned
sounddirs = {};
d = dir(db_root_sounds);
for k = 1:length(d)
    if d(k).isdir
        dname = d(k).name;
        if dname(1) ~= '.'
            sounddirs = [ sounddirs ; db_root_sounds d(k).name '/' ];
        end
    end
end

% Analyze new samples
for k = 1:length(sounddirs)
    server_says(handles,[ 'Scanning ''' sounddirs{k} '''...' ],0);
    analyze_db_samples(sounddirs{k},db_root_xml,db_root_xml,handles);
end

% Import new XML files
handles.instrument_knowledge = update_knowledge(handles.instrument_knowledge,db_root_xml,handles);

% Save user knowledge
server_says(handles,[ 'Save user instrument knowledge: ' osc_message.data{2} ],0);
instrument_knowledge = handles.instrument_knowledge;
save ~/Library/Preferences/IRCAM/Orchidee/user_knowledge.mat instrument_knowledge;
server_says(handles,[ 'Save user instrument knowledge: ' osc_message.data{2} ],1);

% Export DB Map
!rm ~/Library/Preferences/IRCAM/Orchidee/dbmap
export_map(handles.instrument_knowledge, '~/Library/Preferences/IRCAM/Orchidee/dbmap', handles);