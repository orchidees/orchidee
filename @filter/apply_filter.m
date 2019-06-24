function value_list = apply_filter(filter_instance,session_instance,knowledge_instance)

% APPLY_FILTER - Returns the list of possible values allowed in the
% search process for the field associated to the filter.
%
% Usage: value_list = apply_filter(filter_instance,session_instance,knowledge_instance)
%

attribute = filter_instance.attribute;

% If a specific apply function exists for this filter, call it!
apply_function = [ 'apply_filter_' attribute '.m' ];
loc = which(apply_function);
if length(loc)
    apply_function = strrep(apply_function,'.m','');
    cmd = [ 'value_list = ' apply_function '(filter_instance,session_instance,knowledge_instance);' ];
    eval(cmd);
else
    % If no specific apply function exists, do:
    switch filter_instance.mode

        case 'auto'
            % In 'auto' mode, all values are allowed
            value_list = filter_instance.value_list;

        case 'free'
            % In 'free' mode, all values are allowed
            value_list = filter_instance.value_list;

        case 'inex'
            % In 'include' or 'exclude' mode, substract exclude
            % list to possible values
            value_list = setdiff(filter_instance.value_list,filter_instance.exclude_list);

        case 'force'
            % In 'force' mode, return include list
            value_list = filter_instance.include_list;

    end

end

% If all values are allowed, just return 'all'
t = ismember(value_list,filter_instance.value_list);
value_list = value_list(find(t));
if length(value_list) == length(filter_instance.value_list)
    value_list = 'all';
end