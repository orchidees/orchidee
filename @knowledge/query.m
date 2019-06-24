function entries = query(knowledge_instance,varargin)

% QUERY - Multiple query in instrumental knowledge database.
%
% Usage: entries = query(knowledge_instance,filed1,value1,...,filedN,valueN)
%        where: valuei = vi
%               valuei = 'vi'
%               valuei = 'vi1/vi2/.../vik'
%               valuei = { 'vi1' 'vi2' ... 'vik' }
%               valuei = [ vi1 vi2 ... vik ]
%

% Get number of DB entries
entries = (1:1:length(knowledge_instance.database_contents.uri))';

% Get number of fields to query
if length(varargin)==1
    varargin = varargin{1};
    nargin = length(varargin);
else
    nargin = length(varargin)+1;
end

% Iterate on fields to query
for k = 1:2:nargin-1
  
  % Parse the query on current field
  field = varargin{k};
  value = parse_query(varargin{k+1});
  if ischar(value)
    value = cellstr(value);
  end
  
  tmp_entries = [];
  
  for p = 1:length(value)
      
      check_interruption();
      
    % Merge all the query resuts for current field
    if ischar(value)
        tmp_entries = union(tmp_entries,simple_query(knowledge_instance,field,value{p}));
    else
        tmp_entries = union(tmp_entries,simple_query(knowledge_instance,field,value(p)));
    end
    
  end
  
  % Intersect the query results for different fields
  entries = intersect(entries,tmp_entries);  
  
end




function c = parse_query(s)

% PARSE_QUERY - Segment a multiple value input string into a cell
% array of strings (char values) or double vector (numeric vector)
%
% Examples:
% - parse_query('C3/D3/G#3') -> { 'C3' 'D3' 'G#3' }
% - parse_query('1/3/7') -> [ 1 3 7 ]

if ischar(s)
    I = find(s=='/');
    if ~length(I)
        c = s;
    else
        I = [ I length(s)+1 ];
        start = 1;
        for k = 1:length(I)
            stop = I(k)-1;
            this = s(start:stop);
            if regexp(this,'\d') == 1
                c(k) = str2num(this);
            else
                c{k} = this;
            end
            start = I(k)+1;
        end
    end
else
    c = s;
end




function entries = simple_query(knowledge_instance,field,value)

% SIMPLE_QUERY - Enficient (O(1)) simple database query
% routine. Returns the indices of all entries for which the field
% 'field' takes the valus 'value'. Works only on queryable fields.
%
% Usage: entries = simple_query(knowledge_instance,field,value)
%

% Get DB fields
database_fields = knowledge_instance.database_description.fields;

% Check the field to query is in DB
[T,I] = ismember(field,database_fields);
if ~T
    error('orchidee:knowledge:query:UnknownField', ...
        [ '''' field ''' : no such field in database.' ] );
end

% Process only queryable fields
if knowledge_instance.database_description.queryable(I)
    % get field value list
    value_list = knowledge_instance.database_contents.(field).values;
    if isnumeric(value_list)
        v = find(value_list==value);
    else
        v = find(strcmp(value_list,value));
    end
    % retrieve matching entries
    if ~isempty(v)
        idx_min = knowledge_instance.index_tables.(field).limits(v,1);
        idx_max = knowledge_instance.index_tables.(field).limits(v,2);
        entries = (knowledge_instance.index_tables.(field).index(idx_min:1:idx_max));
    else
      % Raise exception if input value is not appropriate for the
      % queried field
        if isnumeric(value)
            error('orchidee:knowledge:query:BadArgumentValue', ...
                [ '''' num2str(value(1)) ''' : unknown value for field ''' field '''.' ] );
        else
            error('orchidee:knowledge:query:BadArgumentValue', ...
                [ '''' value{1} ''' : unknown value for field ''' field '''.' ] );
        end
    end

else
    % Raise exception if input field is not queryable
    error('orchidee:knowledge:query:UnqueryableField', ...
        [ '''' field ''' is not queryable.' ] );
end

