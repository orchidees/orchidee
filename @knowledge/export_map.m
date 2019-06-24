function [] = export_map(knowledge_instance,mapfile,handles)

% EXPORT_MAP - Write in a text file basic information about the
% knowledge database items: URIs, indices, paths, loudness factors,
% instruments, notes and playing styles. The DB map file can be
% used to avoid multiple queries in a client interface.
%
% Usage: [] = export_map(knowledge_instance,mapfile,handles)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Open export file
if mapfile(1) == '~'
    mapfile = [ home_directory mapfile(2:length(mapfile)) ];
end

fid = fopen(mapfile,'w');
if fid == -1
    error('orchidee:knowledge:export_map:CannotOpenFile', ...
        [ 'Cannot open ''' mapfile '''.' ] );
end

% Collect data to export
uris = knowledge_instance.database_contents.uri;
dbnames = knowledge_instance.database_contents.dbname.values( ...
    knowledge_instance.database_contents.dbname.data);
lfacts = knowledge_instance.database_contents.loudnessFactor;
playstyles = knowledge_instance.database_contents.playingStyle.values( ...
    knowledge_instance.database_contents.playingStyle.data);
notes = knowledge_instance.database_contents.note.values( ...
    knowledge_instance.database_contents.note.data);
dirs = knowledge_instance.database_contents.dir.values( ...
    knowledge_instance.database_contents.dir.data);
files = knowledge_instance.database_contents.file;
insts = knowledge_instance.database_contents.instrument.values( ...
    knowledge_instance.database_contents.instrument.data);

% Export data
for i = 1:length(uris)
    if ~mod(i,10)
        server_says(handles,'Creating DB map ...',i/length(uris));
    end
    str = [ uris{i} ' ' num2str(i) ' ' dbnames{i} dirs{i} files{i} ...
        ' ' num2str(lfacts(i)) ' ' insts{i} ' ' notes{i} ' ' playstyles{i} ];
    fprintf(fid,'%s\n',str);
end

% Close export file
fclose(fid);