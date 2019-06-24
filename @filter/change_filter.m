function filter_instance = change_filter(filter_instance,operator,list)

% CHANGE_FILTER - Change the filter mode and eventually the
% associated include and exclude lists.
%
% Usage: filter_instance = change_filter(filter_instance,operator,<list>)
%

% Prevent from updating the filter on instruments (as it is automatically
% buit from the orchestra oject).
if strcmp(filter_instance.attribute,'instrument')
    error('orchidee:filter:change_filter:BadArgumentValue', ...
        'Instrument filters cannot be manually edited. Change your orchestra instead.' )
end

% Check argument type
if ~ischar(operator)
    error('orchidee:filter:change_filter:BadArgumentType', ...
        'Filter operator must be a string.' )
end

switch operator
    
    case 'free'
        % If new mode is 'free', empty te include and exclude lists
        filter_instance.mode = 'free';
        filter_instance.include_list = [];
        filter_instance.exclude_list = [];
        
    case 'auto'
         % If new mode is 'auto', empty te include and exclude lists
        filter_instance.mode = 'auto';
        filter_instance.include_list = [];
        filter_instance.exclude_list = [];
        
    case 'force'
        % A list of values is required here to update the filter
        if nargin < 3
            error('orchidee:filter:change_filter:BadArgumentNumber', ...
            [ 'Value list is missing.'] );
        end
        % Check that the input list of values is consistent with the
        % possible values of the filter.
        check_new_value_list(filter_instance.attribute,filter_instance.value_list,list);
        filter_instance.include_list = reshape(list,[],1);
        filter_instance.exclude_list = setdiff(filter_instance.value_list,reshape(list,[],1));
        filter_instance.exclude_list = reshape(filter_instance.exclude_list,[],1);
        filter_instance.mode = 'force';
        
    case 'include'
        
        % A list of values is required here to update the filter
        if nargin < 3
            error('orchidee:filter:change_filter:BadArgumentNumber', ...
            [ 'Value list is missing.'] );
        end
        % Check that the input list of values is consistent with the
        % possible values of the filter.
        check_new_value_list(filter_instance.attribute,filter_instance.value_list,list);
        filter_instance.include_list = [ filter_instance.include_list ; reshape(list,[],1) ];
        filter_instance.include_list = unique(filter_instance.include_list);
        filter_instance.exclude_list = setdiff(filter_instance.exclude_list,reshape(list,[],1));
        filter_instance.exclude_list = reshape(filter_instance.exclude_list,[],1);
        filter_instance.mode = 'inex';
        
    case 'exclude'
        
        % A list of values is required here to update the filter
        if nargin < 3
            error('orchidee:filter:change_filter:BadArgumentNumber', ...
            [ 'Value list is missing.'] );
        end
        % Check that the input list of values is consistent with the
        % possible values of the filter.
        check_new_value_list(filter_instance.attribute, ...
                             filter_instance.value_list,list);
        % Add new list to the exclude list
        filter_instance.exclude_list = [ filter_instance.exclude_list ; reshape(list,[],1) ];
        filter_instance.exclude_list = unique(filter_instance.exclude_list);
        % Remove elements of new list from the include list
        filter_instance.include_list = setdiff(filter_instance.include_list,reshape(list,[],1));
        filter_instance.include_list = reshape(filter_instance.include_list,[],1);
        filter_instance.mode = 'inex';
        
    otherwise
        % Raise exception if unknown filter mode
        error('orchidee:filter:change_filter:BadArgumentValue', ...
            [ '''' operator ''': unknown filter operator.'] );
        
end

% If include and exclude lists are complementary, mode changes to 'force'
if length(filter_instance.include_list)+length(filter_instance.exclude_list) == ...
        length(filter_instance.value_list)
    filter_instance.mode = 'force';
end




function check_new_value_list(attribute,allowed_values,list)

% CHECK_NEW_VALUE_LIST - Check that all elements of the new list
% belong to the attribute domain

% Check attribute type
if ~strcmp(class(allowed_values),class(list))
    error('orchidee:filter:change_filter:BadArgumentType', ...
            [ 'Bad type for attribute ''' attribute '''.' ]);
end

% Check the validity of the list elements
T = ~ismember(list,allowed_values);
if sum(T);
    idx = find(T,1,'first');
    if isnumeric(list)
        value = num2str(list(idx));
    else
        value = list{idx};
    end
    error('orchidee:filter:change_filter:BadArgumentValue', ...
            [ '''' value ''': unknown value for attribute ''' attribute '''.' ]);
end