function criteria_list = get_criteria_list(session_instance)

% GET_CRITERIA_LIST -  Return the names of the database fields that may be used
% as optimization criteria. Such fields should fill the followig conditions:
% 1) Be a feature field in the knowledge instance;
% 2) Have a compute_ method implemented in the 'features/compute' dir;
% 3) Have a compare_ method implemented in the 'features/compare' dir;
% 4) Have a neutral_ method implemented in the 'features/neutral' dir;
% 5) Have a transpo_ method implemented in the 'features/transpo' dir;
%
% Usage: criteria_list = get_criteria_list(session_instance)
%

criteria_list = get_criteria_list(session_instance.search_structure);