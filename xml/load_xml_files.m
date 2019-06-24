function metadata = load_xml_files(xml_filenames,metadata_template,handles)

% LOAD_XML_FILES - Load XML sound description files and store the data in a
% structure vector. Concistency with a metadata template is preliminarly
% checked before importing.
%
% Usage: metadata = load_xml_files(xml_filenames,metadata_template)
%

metadata = [];

if nargin < 3
    handles = 1;
end

% Preallocate metadata struct array
if length(xml_filenames)
    server_says(handles,['Loading XML: ' xml_filenames{1}],0.1);
    metadata = get_xml_content(xml_filenames{1},metadata_template);
    metadata = repmat(metadata,length(xml_filenames),1);
end

% Load XML files content
for i = 2:length(xml_filenames)
    server_says(handles,['Loading XML: ' xml_filenames{i}],0.1+i/length(xml_filenames)/10*6);
    metadata(i) = get_xml_content(xml_filenames{i},metadata_template);
    % Get URI and path from XML filename
    pos_underscore = find(xml_filenames{i}=='_',1,'last');
    pos_lastslash = find(xml_filenames{i}=='/',1,'last');
    xml_filename = xml_filenames{i};
    uri = xml_filename(pos_lastslash+1:pos_underscore-1);
    path = xml_filename(1:pos_lastslash);
    % Compare URI and path to XML content
    if ~strcmp(uri,metadata(i).info.uri)
        error('orchidee:xml:load_xml_files:UnconsistentUri',[ 'URI does not correspond to filename. In : ' xml_filenames{i} '.']);
    end
    if ~strfind(metadata(i).info.dir,path)
        error('orchidee:xml:load_xml_files:UnconsistentPath',[ 'Path info does not correspond to actual path. In : ' xml_filenames{i} '.']);
    end
end
    