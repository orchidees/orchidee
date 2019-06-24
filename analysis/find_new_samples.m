function db_s = find_new_samples(soundfiledbroot,xmldbroot,handles)

% FIND_NEW_SAMPLES - Look in soundfiledbroot for new sound files to
% analyze, i.e. sound files with no associated XML file. Expected
% sound formats are WAV or AIFF.
%
% Usage: db_s = find_new_samples(soundfiledbroot,xmldbroot,handles)
%

check_interruption();
server_says(handles,'Looking for new sound samples ...',0);

% Get current XML file names
tmp_file = tmp_file_name;
cmd = [ 'find "' xmldbroot '" -name ''*.xml'' > ' tmp_file ];
unix(cmd);
fid = fopen(tmp_file);
xml_filenames = textscan(fid,'%s','Delimiter','\n');
xml_filenames = xml_filenames{1};
fclose(fid);
unix(['rm ' tmp_file]);

check_interruption();
server_says(handles,'Looking for new sound samples ...',0.1);

% Get URIs from XML file names
xml_uris = cell(length(xml_filenames),1);
for k = 1:length(xml_filenames)
    check_interruption();
    [dir,file] = fileparts(xml_filenames{k});
    pat = '_\d\d\d\d\d\d\d\d\d\d\d\d\d\d';
    idx = regexp(file,pat);
    xml_uris{k,1} = file(1:idx-1);
end

check_interruption();
server_says(handles,'Looking for new sound samples ...',0.2);

% Get AIF new sound file names
tmp_file = tmp_file_name;
cmd = [ 'find "' soundfiledbroot '" -name ''*.aif'' > ' tmp_file ];
unix(cmd);
fid = fopen(tmp_file);
aif_filenames = textscan(fid,'%s','Delimiter','\n');
aif_filenames = aif_filenames{1};
fclose(fid);
unix(['rm ' tmp_file]);

check_interruption();
server_says(handles,'Looking for new sound samples ...',0.3);

% Get AIFF new sound file names
tmp_file = tmp_file_name;
cmd = [ 'find "' soundfiledbroot '" -name ''*.aiff'' > ' tmp_file ];
unix(cmd);
fid = fopen(tmp_file);
aiff_filenames = textscan(fid,'%s','Delimiter','\n');
aiff_filenames = aiff_filenames{1};
fclose(fid);
unix(['rm ' tmp_file]);

check_interruption();
server_says(handles,'Looking for new sound samples ...',0.4);

% Get WAV new sound file names
tmp_file = tmp_file_name;
cmd = [ 'find "' soundfiledbroot '" -name ''*.wav'' > ' tmp_file ];
unix(cmd);
fid = fopen(tmp_file);
wav_filenames = textscan(fid,'%s','Delimiter','\n');
wav_filenames = wav_filenames{1};
fclose(fid);
unix(['rm ' tmp_file]);

check_interruption();
server_says(handles,'Looking for new sound samples ...',0.5);

% Merge AIF, AIFF and WAV soundfiles
sound_file_names = [ aif_filenames ; aiff_filenames ; wav_filenames ];

% Get URIs from sound file names
dirs = cell(length(sound_file_names),1);
sound_uris = cell(length(sound_file_names),1);
sound_ext = cell(length(sound_file_names),1);
for k = 1:length(sound_file_names)
    check_interruption();
    server_says(handles,'Looking for new sound samples ...',0.5+0.3*k/length(sound_file_names));
    [dirs{k,1},sound_uris{k,1},sound_ext{k,1}] = fileparts(sound_file_names{k});
    dirs{k,1} = [ dirs{k,1} '/' ];
end

% Search sound files without XML description file
T = ~ismember(sound_uris,xml_uris);
sound_file_names = sound_file_names(T);
sound_uris = sound_uris(T);
sound_ext = sound_ext(T);
dirs = dirs(T);

% Output a DB structure compliant with Damien Tardieu's analysis
% functions.

% Write sound file root in DB struct
db_s.racine = soundfiledbroot;
if db_s.racine(1) == '~'
    db_s.racine = [ home_directory db_s.racine(2:length(db_s.racine)) ];
end
db_s.racine = [ db_s.racine '/' ];
db_s.racine = strrep(db_s.racine,'//','/');
data_s = [];

% Iterate on new sounds to analyze
for k = 1:length(sound_file_names)
    check_interruption();
    server_says(handles,'Looking for new sound samples ...',0.8+0.2*k/length(sound_file_names));
    % Write soundfile name and soundfile dir in DB struct
    sound_file_names{k} = strrep(sound_file_names{k},'//','/');
    data_s(k).file = [sound_uris{k,1} sound_ext{k,1}];
    data_s(k).dir = strrep(dirs{k},db_s.racine,'');
end
db_s.data_s = data_s;