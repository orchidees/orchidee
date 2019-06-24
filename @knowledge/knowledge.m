function knowledge_instance = knowledge()

% KNOWLEDGE - Instrumental knowledge object constructor.
% Returns an empty instance of class 'knowledge'.
%
% Usage: knowledge_instance = knowledge()
%

% Knowledge slots
knowledge_instance.creation_date = datestr(now,'00000000000000');
knowledge_instance.database_description = [];
knowledge_instance.database_contents = [];
knowledge_instance.index_tables = [];
knowledge_instance.uri_tree = [];

% Assign fieldnames
knowledge_instance.fieldNames = fieldnames(knowledge_instance);

% Build Class
knowledge_instance = class(knowledge_instance,'knowledge');