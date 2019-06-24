function values = get_field_values(knowledge_instance,field,idx)

% GET_FIELD_VALUES - Get content of a knowledge database field
% (an optional index vector may be specified).
% 
% Usage: values = get_field_values(knowledge_instance,field,<idx>)
%

if nargin < 3
    idx = 1:1:length(knowledge_instance.database_contents.uri); 
end

database_fields = knowledge_instance.database_description.fields;

[T,I] = ismember(field,database_fields);

if ~T
    error('orchidee:knowledge:get_field_values:UnknownField', ...
        [ '''' field ''' : no such field in database.' ] );
end

if knowledge_instance.database_description.queryable(I)
    
    values = cell(length(idx),1);
    data = knowledge_instance.database_contents.(field).data(idx,:);
    values = knowledge_instance.database_contents.(field).values(data);
    
else
    
    dim = size(knowledge_instance.database_contents.(field)(idx(1),:),1);
    values = zeros(length(idx),dim);
    values = knowledge_instance.database_contents.(field)(idx,:);
    
end

    
    