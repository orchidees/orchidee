function criteria_list = get_criteria_list(searchstructure_instance)

% GET_CRITERIA_LIST - Return the list of allowed optimization
% features.
%
% Usage: criteria_list = get_criteria_list(searchstructure_instance)
%

criteria_list = searchstructure_instance.allowed_features;