function param_value = get_parameter(target_instance,param_name)

% GET_PARAMETER - 'parameters' slot accessor. If a valid parameter
% name is provided, return its value.
%
% Usage: param_value = get_parameter(target_instance,<param_name>)
%

if nargin < 2

    % Default method accesses all parameters
    param_value = target_instance.parameters;

else
    
  % If a parameter name is provided, do:
    % -- Get the possible parameter names
    allowed_parameters = fieldnames(target_instance.parameters);
    % -- Check the input parameter is valid
    if ~ischar(param_name)
        error('orchidee:target:get_parameter:BadArgumentType', ...
            'Parameter name must be a string.' );
    end
    if ~ismember(param_name,allowed_parameters)
        error('orchidee:target:get_parameter:BadArgumentValue', ...
            [ '''' param_name ''': unknown analysis parameter.' ] );
    end
    % -- Return the input parameter value
    param_value = target_instance.parameters.(param_name);

end