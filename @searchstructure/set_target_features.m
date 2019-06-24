function searchstructure_instance = set_target_features(searchstructure_instance,session_instance,knowledge_instance)

% Import target features in 'searchstructure' object
%
% Usage: searchstructure_instance = set_target_features(searchstructure_instance,session_instance,knowledge_instance)
% 

searchstructure_instance.target_features = get_target_features(session_instance);