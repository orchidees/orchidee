function target_instance = set_parameter(target_instance,param_name,param_value)

% SET_PARAMETER - Set a analysis parameter to a new value. The
% validity of the new value (type and range) is preliminarily
% checked by invoking the 'default_analysis_params' method.
%
% Usage: target_instance = set_parameter(target_instance,param_name,param_value)
%

% Get parameter list
allowed_parameters = fieldnames(target_instance.parameters);

% Check the validity of the input parameter
if ~ischar(param_name)
    error('orchidee:target:set_parameter:BadArgumentType', ...
        'Parameter name must be a string.' );
end
if ~ismember(param_name,allowed_parameters)
    error('orchidee:target:set_parameter:BadArgumentValue', ...
        [ '''' param_name ''': unknown analysis parameter.' ] );
end

% Get parameters types and allowed ranges
[params_values,params_class,params_range] = default_analysis_params();

% Check type of parameter new value
if ~strcmp(params_class.(param_name),class(param_value));
    error('orchidee:target:set_parameter:BadArgumentType', ...
        [ 'Wrong type for parameter ''' param_name '''.' ] );
end

% Check if new value is i parameter range
range = params_range.(param_name);
if isnumeric(param_value)
    if isnumeric(range)
        T = (param_value>=range(1)) && (param_value<=range(2));
    else
        range = cell2mat(range);
        T = ismember(param_value,range);
    end
elseif ischar(param_value)
    T = ismember(param_value,range);
end
if ~T
    error('orchidee:target:set_parameter:BadArgumentType', ...
        [ 'Bad value for parameter ''' param_name '''.' ] );
end

% Assign new value in slot
target_instance.parameters.(param_name) = param_value;

% Clear target features if new parameter is not 'autodelta'
if ~ismember(param_name,{'delta' 'autodelta'})
    target_instance.features = [];
end