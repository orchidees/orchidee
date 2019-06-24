function knowledge_instance = build_knowledge(knowledge_instance,metadata,handles)

% BUILD_KNOWLEDGE - Build knowledge object from metadata structure or XML
% root directory.
%
% Usage: knowledge_instance = build_knowledge(knowledge_instance,metadata,<handles>)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT: EXPLICITLY EXPORT NEW DBMAP AFTER BUILDING KNOWLEDGE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if in server mode
if nargin < 3
    handles = [];
end

% If metadata is a char, take it for the XML root dir.
if ischar(metadata)
    server_says(handles,'Get XML file list ...',0);
    % Get XML filenames
    xml_filenames = get_xml_filenames(metadata,0,{},handles);
    % Load XML template (stored as a MAT file)
    metadata_template = load('metadata_template.mat');
    metadata_template = metadata_template.metadata_template;
    % Load XML data as a struct array
    metadata = load_xml_files(xml_filenames,metadata_template,handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Expected info fields in metadata - And what do to with them %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_info_fields = { 'uri' 'file' 'dir' 'dbname' 'source' ...          %
    'pitchCheck' 'loudnessFactor'};                                        %
queryable = [ 0 0 1 1 1 1 0 ];                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill database description field %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cell array containing the database field names:
knowledge_instance.database_description.fields = {};
% Cell array containing the database field types
% ('I'='info', 'A'='attribute', 'F'='feature'):
knowledge_instance.database_description.types = {};
% Cell array containing the database field query flags:
% (1='queryable', 0='non-queryable')
knowledge_instance.database_description.queryable = [];

%%%%% Add info data %%%%%
info_fields = fieldnames(metadata(1).info);
for k = 1:length(info_fields)
    % Check this info field is expected
    [T,I] = ismember(info_fields{k},expected_info_fields);
    if ~T
        error('orchidee:knowledge:build_knowledge:UnknownInfoField', ...
            [ 'Don''t know what to do with info field ''' info_fields{k} '''.' ]);
    else
        % Add field name
        knowledge_instance.database_description.fields = [ ...
            knowledge_instance.database_description.fields info_fields{k} ];
        % Add field type ('I')
        knowledge_instance.database_description.types = [ ...
            knowledge_instance.database_description.types 'I' ];
        % Add field queryable flag
        knowledge_instance.database_description.queryable = [ ...
            knowledge_instance.database_description.queryable queryable(I) ];
    end
end

%%%%% Add attribute data %%%%%
attribute_fields = fieldnames(metadata(1).attributes);
for k = 1:length(attribute_fields)
    % Add field name
    knowledge_instance.database_description.fields = [ ...
        knowledge_instance.database_description.fields attribute_fields{k} ];
    % Add field type ('A')
    knowledge_instance.database_description.types = [ ...
        knowledge_instance.database_description.types 'A' ];
    % Add field queryable flag
    knowledge_instance.database_description.queryable = [ ...
        knowledge_instance.database_description.queryable 1 ];
end

%%%%% Add feature data %%%%%
feature_fields = fieldnames(metadata(1).features);
for k = 1:length(feature_fields)
    % Add field name
    knowledge_instance.database_description.fields = [ ...
        knowledge_instance.database_description.fields feature_fields{k} ];
    % Add field type ('F')
    knowledge_instance.database_description.types = [ ...
        knowledge_instance.database_description.types 'F' ];
     % Add field queryable flag
    knowledge_instance.database_description.queryable = [ ...
        knowledge_instance.database_description.queryable 0 ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill database contents field %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Allocate memory for content objects %%%%%

server_says(handles,'Allocate memory ...',0.7);

% Take first element of metadata as a description template and convert it
% into a flat structure (easier to iterate on fields).
flat_template = flatten_structure(metadata(1));
% It is assume here that any given single field content has the same size
% for each element of metadata. The metadata template contains specify the
% expected type of each field but does not contain any size information.
% This is why metadata(1) is taken as a template instead of
% metadata_template.

% Get number of items to add in the database
nitems = length(metadata);

for k = 1:length(knowledge_instance.database_description.fields)

    this_field = knowledge_instance.database_description.fields{k};
    
    % Check hat field content is not a matrix (only scalar and vector descriptors
    % are supported)
    if min(size(flat_template.(this_field))) > 1
        error('orchidee:knowledge:build_knowledge:BadDescriptorValue', ...
            [ '''' this_field ''': Matrix descriptors are not supported.' ]);
    else
        % Get descriptor dimension
        if ischar(flat_template.(this_field))
            dim = 1;
        else
            dim = length(flat_template.(this_field));
        end
    end
    
    if knowledge_instance.database_description.queryable(k)
        % If current field is queryable, allocate a structure that allows
        % queries: 'values" contains all the possible field values (without
        % any redundancy) and 'data' is an index vector refering to
        % 'values'.
        % Note that 'data' is first a copy of the raw metadata field, and
        % will be converted into an index vector in the 'compression'
        % phase.
        if isnumeric(flat_template.(this_field))
            % If current field is numeric, allocates double vectors
            knowledge_instance.database_contents.(this_field).values = [];
            knowledge_instance.database_contents.(this_field).data = zeros(nitems,1);
        else
            % Else allocate cell arrays
            knowledge_instance.database_contents.(this_field).values = {};
            knowledge_instance.database_contents.(this_field).data = cell(nitems,1);
        end

    else
        % If current field is queryable, allocate raw data only
        if isnumeric(flat_template.(this_field))
            knowledge_instance.database_contents.(this_field) = zeros(nitems,dim);
        else
            knowledge_instance.database_contents.(this_field) = cell(nitems,dim);
        end

    end

end

%%%%% Fill content fields %%%%%

for i = 1:nitems

    message = ['Adding: ' metadata(i).info.uri ' (DB entry ' num2str(i) ')'];
    server_says(handles,message,0.7+i/length(metadata)/10);
    
    % Convert current metadata element into a flat structure
    % (easier to iterate on fields)
    flat_data = flatten_structure(metadata(i));

    % Iterate on element fields
    for k = 1:length(knowledge_instance.database_description.fields)

        this_field = knowledge_instance.database_description.fields{k};

        if knowledge_instance.database_description.queryable(k)
            % If current field is queryable, assign the 'data' slot only
            if isnumeric(flat_data.(this_field))
                if isempty(flat_data.(this_field))
                    knowledge_instance.database_contents.(this_field).data(i,:) = 0;
                else
                    knowledge_instance.database_contents.(this_field).data(i,:) = ...
                        reshape(flat_data.(this_field),1,[]);
                end
            else
                knowledge_instance.database_contents.(this_field).data{i} = flat_data.(this_field);
            end

        else
            % If current field is not queryable, copy raw data into database
            if isnumeric(flat_data.(this_field))
                knowledge_instance.database_contents.(this_field)(i,:) = ...
                    reshape(flat_data.(this_field),1,[]);
            else
                knowledge_instance.database_contents.(this_field){i} = flat_data.(this_field);
            end

        end

    end

end

%%%%% 'Compress' queryable data %%%%%

server_says(handles,'Compress data ...',0.9)

for k = 1:length(knowledge_instance.database_description.fields)
    
    % Process only queryable data
    if knowledge_instance.database_description.queryable(k)

        this_field = knowledge_instance.database_description.fields{k};

        % Assign 'values' to the list of all possible values of the field
        % (without any redundancy)
        knowledge_instance.database_contents.(this_field).values = ...
            unique(knowledge_instance.database_contents.(this_field).data);
        % Assign 'data' to an index vector refering to 'values'
        [T,knowledge_instance.database_contents.(this_field).data] = ismember(...
            knowledge_instance.database_contents.(this_field).data, ...
            knowledge_instance.database_contents.(this_field).values);

    end

end

%%%%%%%%%%%%%%%%%%%%%%
% Build index tables %
%%%%%%%%%%%%%%%%%%%%%%

% Index tables are used for efficient queries in database.
% Each queryable field is linked to a table made out of two fields: 'index'
% and 'limits'. 'index' is used to sort the values of fields by increasing
% (or alphabetical) order. 'limits' is a 2-column vector, where limits(i,1)
% is the starting index of value i in the sorted list and limits(i,2) is
% the ending index (see the QUERY method for more info).

server_says(handles,'Build index tables ...',0.93);

for k = 1:length(knowledge_instance.database_description.fields)

    % Process only queryable data
    if knowledge_instance.database_description.queryable(k)

        this_field = knowledge_instance.database_description.fields{k};
        
        data = knowledge_instance.database_contents.(this_field).data;
        values = knowledge_instance.database_contents.(this_field).values;
        
        % Assign sort index vector
        [data,idx] = sort(data);
        tables.(this_field).index = idx;
        
        % Assign index limits for each value
        % Note that [ (limits(1,1):limits(1,2)) (limits(2,1):limits(2,2)) ... ]
        % is a partition of (1:lenght(index)).
        % Moreover: for all i>2, limits(i,1) = limits(i-1,2)
        for i = 1:length(values)
            I = find(data==i);
            limits(i,1) = min(I);
            limits(i,2) = max(I);
        end
        tables.(this_field).limits = limits;

    end

end

knowledge_instance.index_tables = tables;

%%%%%%%%%%%%%%%%%%
% Build URI tree %
%%%%%%%%%%%%%%%%%%

% This is used to efficiently (in O(1)) check whether a given URI is
% already in database or not.

server_says(handles,'Build URI tree ...',0.96);

knowledge_instance.uri_tree = build_uri_tree(knowledge_instance.database_contents.uri);

%%%%%%%%%%%%%%%%%%%%%%%%
% Assign database date %
%%%%%%%%%%%%%%%%%%%%%%%%

knowledge_instance.creation_date = datestr(now,'yyyymmddHHMMSS');

server_says(handles,'Done.',1);