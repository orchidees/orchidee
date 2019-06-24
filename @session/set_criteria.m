function session_instance = set_criteria(session_instance,criteria)

% SET_CRITERIA - Set a criterion list as current optimization
% criteria.
%
% Usage: session_instance = set_criteria(session_instance,criteria)
%

session_instance.search_structure = set_criteria(session_instance.search_structure,criteria);