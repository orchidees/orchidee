function analyze_db_samples(soundfiledbroot,xmldbroot,xmlexportdir,handles)

% ANALYSE_DB_SAMPLES - Look for sounds in 'soundfiledbroot' that do
% not have an associated XML description file in 'xmldbroot', perform analysis
% and write XML description files in 'xmlexportdir'.
%
% Usage: analyze_db_samples(soundfiledbroot,xmldbroot,xmlexportdir,<handles>)
%

% Assign DB source to 'User'
dbsource = 'User';

% Get DB name from DB root directory
l = length(soundfiledbroot);
if soundfiledbroot(l)=='/'
    dbname = soundfiledbroot(1:l-1);
    slash = max(find(dbname=='/'));
    dbname = dbname(slash+1:length(dbname));
end

% Check if in server mode
if nargin < 4
    handles = [];
end

% Check validity of 'soundfiledbroot'
if ~exist(soundfiledbroot,'dir')
    error('orchidee:analysis:analyze_db_samples:NonExistingDirectory', ...
        [ '''' soundfiledbroot ''': no such directory.']);
end

% Check validity of 'xmldbroot'
if ~exist(xmldbroot,'dir')
    error('orchidee:analysis:analyze_db_samples:NonExistingDirectory', ...
        [ '''' xmldbroot ''': no such directory.']);
end

% Create export dir if it does not exist
if ~exist(xmlexportdir,'dir')
    mkdir(xmlexportdir);
end

% Re-format export dir name
if xmlexportdir(1) == '~'
    xmlexportdir = [ home_directory xmlexportdir(2:length(xmlexportdir)) ];
end
xmlexportdir = [ xmlexportdir '/' ];
xmlexportdir = strrep(xmlexportdir,'//','/');

% Scan 'soundfiledbroot' dir and analyze new sound files
db_s = FnewDB(soundfiledbroot,xmldbroot,handles);

if ~isempty(db_s.data_s)
    % Iterate on DB elements
    for k = 1:length(db_s.data_s);
        % Write XML description file
        check_interruption();
        server_says(handles,'Writing XML description files ...',k/length(db_s.data_s));
        write_xml_description_file(xmlexportdir,dbname,dbsource,db_s.data_s(k));
    end
else
    % if nothing to analyze, say it!
    server_says(handles,'Nothing to do!',1);

end

clear Fsdif_read_handler;