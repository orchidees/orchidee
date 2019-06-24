function searchstructure_instance = compute_attribute_domains(searchstructure_instance,session_instance,knowledge_instance)

% COMPUTE_ATTRIBUTE_DOMAINS - Return a structure of allowed search
% values for each attribute. ('Attribute' here refers to any field
% of the database on which a filterd may be applied, i.e. each
% queryable field).
%
% Usage: searchstructure_instance = compute_attribute_domains(searchstructure_instance,session_instance,knowledge_instance)
%

% Initialize output
attribute_domains = [];

% Get filter objects and filter names
[filters,filter_names] = get_filters(session_instance);

% Iterate on filtered fields
for k = 1:length(filters)
    % for each filterd field, apply filter to compute the allowed values
    attribute_domains.(filter_names{k}) = ...
        apply_filter(filters(k),session_instance,knowledge_instance);
end

% Assign ouput
searchstructure_instance.attribute_domains = attribute_domains;