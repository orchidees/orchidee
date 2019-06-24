function session_instance = session(knowledge_instance)

% SESSION - Session instance constructor. A session object is
% created at each new orchestration problem.

% The session will need to be updated before running the
% orchestration algorithm (some information is currently missing):
% Set all 'need_update' flags to true.
session_instance.need_update.dom_attributes = 1;
session_instance.need_update.dom_variables = 1;
session_instance.need_update.mat_features = 1;

% Create default orchestra object
session_instance.orchestra = orchestra(knowledge_instance);
% Create empty target object
session_instance.target = target();
% Assign empty filter names slot
session_instance.filter_names = [];
% Assign empty filters slot
session_instance.filters = [];
% Assign empty constraint slot (this is for future versions of Orchidee)
session_instance.constraints = [];
% Create empty search_structure object
session_instance.search_structure = searchstructure(knowledge_instance);

% Get filter names from the list of queryable fields
db_fields = get_fields_info(knowledge_instance,'list');
query_fields = db_fields(find(get_fields_info(knowledge_instance,'query')));
session_instance.filter_names = query_fields;

% Create a filter for each queryable field in database
for k = 1:length(query_fields)
    switch query_fields{k}
        % Special case for the 'note' attribute
        case 'note'
            % Get orchestra microtonic resolution
            resolution = get_resolution(session_instance.orchestra);
            % Get the list of possible notes (accounting for the
            % microtonic resolution) and create filter
            session_instance.filters = [ session_instance.filters ; ...
                filter(knowledge_instance,query_fields{k},get_possible_notes(knowledge_instance,resolution)) ];
        otherwise
            % Otherwise, create default filter
            session_instance.filters = [ session_instance.filters ; ...
                filter(knowledge_instance,query_fields{k}) ];
    end
end

% Assign fieldnames
session_instance.fieldnames = fieldnames(session_instance);

% Build class
session_instance = class(session_instance,'session');