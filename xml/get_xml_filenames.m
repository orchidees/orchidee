function xml_filenames = get_xml_filenames(xml_db_root,starting_date,uris,handles)

% GET_XML_FILENAMES - Get the XML files to actually import in order to
% update the metadata. Only the files generated after the starting date or
% not already in the uri list are imported. 
%
% Usage: xml_filenames = get_xml_filenames(xml_db_root,<starting_date>,<uris>,<handles>)
%

% Handle args and assign default values
if nargin < 4
    handles = [];
end
if nargin < 3
    uris = {};
end
if nargin < 2
    starting_date = 0;
end
if ischar(starting_date)
    starting_date = str2double(starting_date);
end

% Check that xml_db_root exists
if ~exist(xml_db_root)
    error('orchidee:xml:get_xml_filenames:NonExistingDirectory', ...
        [ xml_db_root ': no such directory.']);
end

% Get XML file names
tmp_file = tmp_file_name;
cmd = [ 'find "' xml_db_root '" -name ''*.xml'' > ' tmp_file ];
unix(cmd);
fid = fopen(tmp_file);
xml_filenames = textscan(fid,'%s','Delimiter','\n');
xml_filenames = xml_filenames{1};
fclose(fid);
unix(['rm ' tmp_file]);

% Get URIs from XML file names
new_uris = cell(length(xml_filenames),1);
for i = 1:length(xml_filenames)
    server_says(handles,'Get XML file list ...',i/length(xml_filenames)/20);
    this_filename = xml_filenames{i};
    pos_underscore = find(xml_filenames{i}=='_',1,'last');
    pos_lastslash = find(xml_filenames{i}=='/',1,'last');
    new_uris{i} = this_filename(pos_lastslash+1:pos_underscore-1);       
end

% Mark the new URIs as to be imported
import_flag = ~ismember(new_uris,uris);

% Mark the old URIs with for which the associated XML file as been
% updated recently to be imported
for i = 1:length(xml_filenames)
    server_says(handles,'Get XML file list ...',0.05+i/length(xml_filenames)/20);
    this_filename = xml_filenames{i};
    pos_underscore = find(xml_filenames{i}=='_',1,'last');
    xml_date_str = this_filename(pos_underscore+1:pos_underscore+14);
    if starting_date <= str2double(xml_date_str)
        import_flag(i) = 1;
    end
end

% Return the XML files to import as a cell array of strings
xml_filenames = xml_filenames(find(import_flag));