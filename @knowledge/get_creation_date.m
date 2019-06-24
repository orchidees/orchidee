function cr_date = get_creation_date(knowledge_instance)

% GET_CREATION_DATE - Return the knowledge instance cration
% date as an array of 14 characters.
% Date format: yyyymmddHHMMSS
%
% Usage: cr_date = get_creation_date(knowledge_instance)
%

cr_date = knowledge_instance.creation_date;