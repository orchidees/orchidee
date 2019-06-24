function session_instance = set_filter(session_instance,attribute,operator,list)

% SET_FILTER - Change a filter in the current session.
%
% Usage: session_instance = set_filter(session_instance,attribute,operator,list)
%

% Attribute domains and variable domains will
% need to be recomputed
session_instance.need_update.dom_attributes = 1;
session_instance.need_update.dom_variables = 1;

% Check attribute type
if ~ischar(attribute)
    error('orchidee:session:set_filter:BadArgumentType', ...
        'Filter attribute must be a string.' )
end

% Check that attribute is a filter name
[T,idx] = ismember(attribute,session_instance.filter_names);
if ~T
    error('orchidee:session:set_filter:BadArgumentValue', ...
        [ '''' attribute ''': unknown attribute.' ] );
end
    
% Update filter
session_instance.filters(idx) = change_filter(session_instance.filters(idx),operator,list);
