function session_instance = set_target_parameter(session_instance,param_name,param_value)

% SET_TARGET_PARAMETER - Set a new value to a target analysis
% parameter.
%
% Usage: session_instance = set_target_parameter(session_instance,param_name,param_value)
%

switch param_name

    case 'autodelta'
        
        % Special case for 'autodelta'
        if param_value

            % If 'autodelta' is set to 'true', compute the new
            % delta value
            session_instance.target = set_parameter(session_instance.target,param_name,param_value);
            delta = update_delta(session_instance.target,session_instance);
            session_instance = set_target_parameter(session_instance,'delta',delta);

        end

    otherwise
        
        % Set the parameter value
        session_instance.target = set_parameter(session_instance.target,param_name,param_value);

end

% Attribute domains, variable domains and feature matrices will
% need to be recomputed
session_instance.need_update.dom_attributes = 1;
session_instance.need_update.dom_variables = 1;
session_instance.need_update.mat_features = 1;