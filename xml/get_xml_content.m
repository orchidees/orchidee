function metadata = get_xml_content(xml_file,metadata_template)

% GET_XML_CONTENT - Load sound metadata from XML file.
% 
% Usage: metadata = get_xml_content(xml_file,metadata_template)
%

% Define maximum number of elements in the temporal evolution matrix 
MAX_EVO_ELEMENTS = 3700;

% Check input args
if ~exist(xml_file)
    error('orchidee:xml:get_xml_content:CannotOpenFile',[ xml_file ': no such file.']);
end
if ~isstruct(metadata_template)
    error('orchidee:xml:get_xml_content:BadArgumentType','Metadata template is not a structure.');
end

% Load XML file
warning off;
metadata = xml_load(xml_file);
warning on;

% Check XML file content
t = check_struct_content(metadata,metadata_template);
if ~t
    error('orchidee:xml:get_xml_content:InconsistentMetadata',[ xml_file ' does not fulfill the metadata template requirements.']);
end

% Keep only template fields
S = [];
S = add_fields(S,metadata,metadata_template);
metadata = S;

% Special exception for temporal evolution features
if isfield(metadata.features,'temporalEvolution')
    temporalEvolution = metadata.features.temporalEvolution;
    l = numel(temporalEvolution);
    if l > MAX_EVO_ELEMENTS
        error('orchidee:xml:get_xml_content:InconsistentMetadata', ...
            'Orchidee cannot handle temporal evolution matrices greater than 200x30.');
    end
    % Stores the size of the temporal evolution matrix
    metadata.features.temporalEvolutionSize = size(temporalEvolution);
    % Allocate a vector of size 1xMAX_EVO_ELEMENTS
    metadata.features.temporalEvolution = zeros(1,MAX_EVO_ELEMENTS);
    % Reshape the temporal evolution matrix into a row vector
    metadata.features.temporalEvolution(1:l) = reshape(temporalEvolution,1,[]);
end




function S = add_fields(S,data,template)

% ADD_FIELDS - Recursively add 'data' fields in S according to a 'template'
% field structure.

if isstruct(template)
    
    F = fieldnames(template);
    for k = 1:length(F)
        S.(F{k}) = [];
        S.(F{k}) = add_fields(S.(F{k}),data.(F{k}),template.(F{k}));
    end
else
    
    S = data;
    
end

