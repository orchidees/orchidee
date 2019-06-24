function value_list = apply_filter_instrument(filter_instance,session_instance,knowledge_instance)

% APPLY_FILTER_INSTRUMENT - Specific apply function for the filter
% associated with the 'instrument field
%
% Usage: value_list =
% apply_filter_instrument(filter_instance,session_instance,knowledge_instance)
%

% Return flattened instrument list
value_list = flatcell(get_orchestra(session_instance));
value_list = reshape(value_list,[],1);