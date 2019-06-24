function searchstructure_instance = set_criteria(searchstructure_instance,criteria)

% SET_CRITERIA - Set a feature list as current optimization
% criteria.
%
% Usage: searchstructure_instance = set_criteria(searchstructure_instance,criteria)
%

criteria = unique(criteria);

% Check input argument type
if ~iscell(criteria)
    error('orchidee:searchstructure:set_criteria:BadArgumentType', ...
        'Criteria list must be a cell array of strings.');
end

for k = 1:length(criteria)
    
    % Check that each criterion in the input list is a string
    if ~ischar(criteria{k})
        error('orchidee:searchstructure:set_criteria:BadArgumentType', ...
            'Criteria list must be a cell array of strings.');
    end
    % Check that each element in the input list is a valid criteria
    if ~ismember(criteria{k},searchstructure_instance.allowed_features)
        error('orchidee:searchstructure:set_criteria:BadArgumentValue', ...
            [ '''' criteria{k} ''': unknown criterion.' ]);
    end
    
end

% Reshape list
criteria = reshape(criteria,[],1);

% Assign field
searchstructure_instance.used_features = criteria;