function value_list = get_field_value_list(knowledge_instance,field,idx)

% GET_FIELD_VALUE_LIST - Get all possible values of a knowledge
% database queryable field. Values are sorted and multiple occurrences are
% discarded. 
%
% Usage: value_list = get_field_value_list(knowledge_instance,field,<idx>)
%

database_fields = knowledge_instance.database_description.fields;

[T,I] = ismember(field,database_fields);

if ~T
    error('orchidee:knowledge:get_field_value_list:UnknownField', ...
        [ '''' field ''' : no such field in database.' ] );
end

if ~knowledge_instance.database_description.queryable(I)
    error('orchidee:knowledge:get_field_value_list:BadArgumentValue', ...
        [ '''' field ''' is not queryable.' ] );
end

if nargin < 3

    value_list = knowledge_instance.database_contents.(field).values;
    value_list = unique(value_list);

else
    
    if ~isnumeric(idx)
        error('orchidee:knowledge:get_field_value_list:BadArgumentType', ...
        'Unapproriate index vector.' );
    end
    
    if min(size(idx)) > 1
        error('orchidee:knowledge:get_field_value_list:BadArgumentValue', ...
        'Unapproriate index vector.' );
    end
    
    value_list = knowledge_instance.database_contents.(field).data;
    value_list = value_list(idx);
    value_list = knowledge_instance.database_contents.(field).values(value_list);
    value_list = unique(value_list);

end

% If method is called on the 'note' field, sort values by pitch
% instead of alphabetical order.
if strcmp(field,'note')
    value_list = midi2mtnotes(sort(mtnotes2midi(value_list)));
end