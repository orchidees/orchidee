function filter_instance = update_value_list(filter_instance,value_list)

% UPDATE_VALUE_LIST - Change the list of possibe values for the filter,
% i.e. the set of all possible values that the filtered field may
% take. This method is nvoked when the orchestra is modified.
%
% Usage: filter_instance = update_value_list(filter_instance,value_list)
% 

filter_instance.value_list = value_list;