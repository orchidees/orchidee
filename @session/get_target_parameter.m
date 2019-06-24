function param_value = get_target_parameter(session_instance,param_name)

% GET_TARGET_PARAMETER - Target analysis parameters accessor. If a
% parameter name is specified, return its value. Else, return the whole
% parameter structure.
%
% Usage: param_value = get_target_parameter(session_instance,param_name)
%

if nargin < 2
    param_value = get_parameter(session_instance.target);
else
    param_value = get_parameter(session_instance.target,param_name);
end