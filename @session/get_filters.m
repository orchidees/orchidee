function [filters,filter_names] = get_filters(session_instance)

% GET_FILTERS - Filter names and filter list accessor.
%
% Usage: [filters,filter_names] = get_filters(session_instance)
%

filters = session_instance.filters;
filter_names = session_instance.filter_names;