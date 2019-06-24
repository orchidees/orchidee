function filter_instance = filter(knowledge_instance,attribute,value_list)

% FILTER - Filter object constructor. A filter is a convenient way
% to restrict or enlarge the search domain by specifying forbidden
% or mandatory values. Each filter instance is specific to a
% given attribute (or more generally a queryable field of the knowledge
% instance).
%
% Usage: filter_instance = filter(knowledge_instance,attribute,<value_list>)
%

%%%%%%%%%%%%%%%%
% Filter slots %
%%%%%%%%%%%%%%%%

% Assign field to be filtered
filter_instance.attribute = attribute;

% Assign possible values of the field to be filtered. This is used
% to check, during future updates of the filter, if new parameters are valid or not.
if nargin < 3
    filter_instance.value_list = get_field_value_list(knowledge_instance,attribute);
else
    filter_instance.value_list = value_list;
end

% Assign default filter mode
filter_instance.mode = 'auto';

% Assign include and exclude lists
filter_instance.include_list = []; % Values to include in the search space
filter_instance.exclude_list = []; % Values to exclude from the search space

%%%%%%%%%%%%%%%%%%%%%
% Assign fieldnames %
%%%%%%%%%%%%%%%%%%%%%
filter_instance.fieldnames = fieldnames(filter_instance);

%%%%%%%%%%%%%%%
% Build Class %
%%%%%%%%%%%%%%%
filter_instance = class(filter_instance,'filter');