function searchstructure_instance = searchstructure(knowledge_instance)

% SEARCHSTRUCTURE - 'searchstructure' object constructor.
%
% Usage: searchstructure_instance = searchstructure(knowledge_instance)
%

% Get allowed optimization criteria from the knowledge instance
% (look for the available features in the knowledge, then check
% that the associated methods are implemented in the /features/
% toolbox).
searchstructure_instance.allowed_features = get_criteria(knowledge_instance);
searchstructure_instance.used_features = get_criteria(knowledge_instance);
% Assign empty other slots
searchstructure_instance.target_features = [];
searchstructure_instance.attribute_domains = [];
searchstructure_instance.variable_domains = [];
searchstructure_instance.feature_structure = [];
searchstructure_instance.solution_set = [];

% Assign field names
searchstructure_instance.fieldnames = fieldnames(searchstructure_instance);

% Build class
searchstructure_instance = class(searchstructure_instance,'searchstructure');