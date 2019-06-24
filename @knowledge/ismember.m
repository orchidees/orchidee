function idx = ismember(knowledge_instance,uri)

% ISMEMBER - Return index of input URI if in database, else zero.
% The search is optimized thanks to the URI tree search structure.
% NB. The overloaded ismember method does not handles cell arrays (uri
% needs to be a char).
%
% Usage: idx = ismember(knowledge_instance,uri)
%

idx = uri_tree_find(knowledge_instance.uri_tree,uri);