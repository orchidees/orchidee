function fields_info = get_fields_info(knowledge_instance,mode)

% GET_FIELDS_INFO - Provide basic information about the fields of a
% knowledge instance: Name, type (info, attribute or feature) and
% queryability.
%
% Usage: fields_info = get_fields_info(knowledge_instance,<mode>)
%
% Allowed values for 'mode': { 'all', 'list', 'type' 'query'}
% Default value for 'mode': 'all'
%

if nargin < 2
    mode = 'all';
end

switch mode

    case 'list'
        % Output field names list
        field_list = knowledge_instance.database_description.fields;
        fields_info = reshape(field_list,[],1);

    case 'type'
         % Output field types ('I', 'A' or 'F') list 
        field_types = knowledge_instance.database_description.types;
        fields_info = reshape(field_types,[],1);

    case 'query'
        % Output field query flags
        field_query = knowledge_instance.database_description.queryable;
        fields_info = reshape(field_query,[],1);

    case 'all'
        % Output names, types and query flags
        field_list = knowledge_instance.database_description.fields;
        field_types = knowledge_instance.database_description.types;
        field_query = knowledge_instance.database_description.queryable;

        fields_info = [ reshape(field_list,[],1) ...
            reshape(field_types,[],1) ];
        for i = 1:length(field_query)
            fields_info{i,3} = field_query(i);
        end
        
    otherwise
        
        error('orchidee:knowledge:get_fields_info:BadArgumentValue', ...
            'Optional argument should be ''list'', ''type'', ''query'' or ''all''.');
end