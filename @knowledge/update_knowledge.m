function knowledge_instance = update_knowledge(knowledge_instance,new_metadata,handles)

% UPDATE_KNOWLEDGE - Update knowledge object with metadata
% structure or XML root directory.
%
% Usage: knowledge_instance = update_knowledge(knowledge_instance,new_metadata)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT: EXPLICITLY EXPORT NEW DBMAP AFTER UBDATING KNOWLEDGE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if in server mode
if nargin < 3
    handles = [];
end

% If input database is empty, call the BUILD_KNOWLEDGE method
if isempty(knowledge_instance.database_contents)
    knowledge_instance = build_knowledge(knowledge_instance,new_metadata);
    return;
end

% If metadata is a char, take it for the XML root dir.
if ischar(new_metadata)
    % Get XML file to import
    xml_filenames = get_xml_filenames(new_metadata, ...
        knowledge_instance.creation_date, ...
        knowledge_instance.database_contents.uri, ...
        handles);
    % Load XML template (stored as a MAT file)
    metadata_template = load('metadata_template.mat');
    metadata_template = metadata_template.metadata_template;
    % Load XML data as a struct array
    new_metadata = load_xml_files(xml_filenames,metadata_template,handles);
end

% Exit function if no files to import
if isempty(new_metadata)
    server_says(handles,'Nothing to do!',1);
    return;
end

% Check consistency of new metadata with prior knowledge
new_fields = fieldnames(flatten_structure(new_metadata(1)));
t1 = setdiff(new_fields,get_fields_info(knowledge_instance,'list'));
t2 = setdiff(get_fields_info(knowledge_instance,'list'),new_fields);
if ~isempty(t1) || ~isempty(t2)
    error('orchidee:knowledge:update_knowledge:InconsistentMetadata', ...
        'New metadata inconsistent with current knowledge structure.' );
end

% 'Uncompress' queryable data
for k = 1:length(knowledge_instance.database_description.fields)
    this_field = knowledge_instance.database_description.fields{k};
    if knowledge_instance.database_description.queryable(k)
        knowledge_instance.database_contents.(this_field).data = ...
            knowledge_instance.database_contents.(this_field).values( ...
            knowledge_instance.database_contents.(this_field).data);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill database contents field %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save current DB length for later insertion
offset = length(knowledge_instance.database_contents.uri);

%%%%% Allocate memory for content objects %%%%%

server_says(handles,'Allocate memory ...',0.7);

% Check whether new entrie are already in database or not
% Code could be optimized here by using the traditional ISMEMBER
% method instead of the overloeaded method.
new_entries = 0;
for i = 1:length(new_metadata)
    if ~ismember(knowledge_instance,new_metadata(i).info.uri);
    new_entries = new_entries+1;
    end
end

for k = 1:length(knowledge_instance.database_description.fields)
    
    this_field = knowledge_instance.database_description.fields{k};

    if knowledge_instance.database_description.queryable(k)
        % If current field is queryable, allocate a structure that allows
        % queries: 'values" contains all the possible field values (without
        % any redundancy) and 'data' is an index vector refering to
        % 'values'.
        % Note that 'data' is first a copy of the raw metadata field, and
        % will be converted into an index vector in the 'compression'
        % phase.
        if isnumeric(knowledge_instance.database_contents.(this_field).data)
            % If current field is numeric, allocates double vectors
            knowledge_instance.database_contents.(this_field).values = [];
            knowledge_instance.database_contents.(this_field).data = [ ...
                knowledge_instance.database_contents.(this_field).data ; zeros(new_entries,1) ];
        else
            % Else allocate cell arrays
            knowledge_instance.database_contents.(this_field).values = {};
            knowledge_instance.database_contents.(this_field).data = [ ...
                knowledge_instance.database_contents.(this_field).data ; cell(new_entries,1) ];
        end

    else
        % If current field is queryable, allocate raw data only
        dim = size(knowledge_instance.database_contents.(this_field),2); % Get descriptor dimension
        if isnumeric(knowledge_instance.database_contents.(this_field))
            knowledge_instance.database_contents.(this_field) = [ ...
                knowledge_instance.database_contents.(this_field) ; zeros(new_entries,dim) ];
        else
            knowledge_instance.database_contents.(this_field) = [ ...
                knowledge_instance.database_contents.(this_field) ; cell(new_entries,dim) ];
        end

    end

end
    
%%%%% Fill content fields %%%%%

new_uris = {};

for i = 1:length(new_metadata)

    idx = ismember(knowledge_instance,new_metadata(i).info.uri);

    if idx
        % If new entry already in DB, update it
        message = ['Updating: ' new_metadata(i).info.uri ' (DB entry ' num2str(idx) ')'];
        server_says(handles,message,0.7+i/length(new_metadata)/10);

    else
        % Else create a new entry
        new_uris = [ new_uris new_metadata(i).info.uri ];
        idx = offset+1;
        offset = offset+1;
        message = ['Adding: ' new_metadata(i).info.uri ' (DB entry ' num2str(idx) ')'];
        server_says(handles,message,0.7+i/length(new_metadata)/10);

    end
    
    % Convert current metadata element into a flat structure
    % (easier to iterate on fields)
    flat_data = flatten_structure(new_metadata(i));
    
    % Iterate on element fields
    for k = 1:length(knowledge_instance.database_description.fields)

        this_field = knowledge_instance.database_description.fields{k};

        if knowledge_instance.database_description.queryable(k)
            % If current field is queryable, assign the 'data' slot only
            if isnumeric(flat_data.(this_field))

                if isempty(flat_data.(this_field))
                    knowledge_instance.database_contents.(this_field).data(idx,:) = 0;
                else
                    knowledge_instance.database_contents.(this_field).data(idx,:) = ...
                        reshape(flat_data.(this_field),1,[]);
                end
            else
                knowledge_instance.database_contents.(this_field).data{idx} = flat_data.(this_field);
            end

        else
            % If current field is not queryable, copy raw data into database
            if isnumeric(flat_data.(this_field))
                knowledge_instance.database_contents.(this_field)(idx,:) = ...
                    reshape(flat_data.(this_field),1,[]);
            else
                knowledge_instance.database_contents.(this_field){idx} = flat_data.(this_field);
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

%%%%%%%%%%%%%%%%%%%
% Update URI tree %
%%%%%%%%%%%%%%%%%%%

% This is used to efficiently (in O(1)) check whether a given URI is
% already in database or not.

server_says(handles,'Build URI tree ...',0.96)

knowledge_instance.uri_tree = build_uri_tree( ...
    new_uris,knowledge_instance.uri_tree,offset);

%%%%%%%%%%%%%%%%%%%%%%%%
% Assign database date %
%%%%%%%%%%%%%%%%%%%%%%%%

knowledge_instance.creation_date = datestr(now,'yyyymmddHHMMSS');

server_says(handles,'Done.',1);