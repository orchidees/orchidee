function session_instance = update_search_structure(session_instance,knowledge_instance,update_task,handles)

% UPDATE_SEARCH_STRUCTURE - Refresh attribute domains, variable
% domains and feature matrices in the 'searchstructure' object
% according to the current orchestration problem.
%
% Usage: session_instance = update_search_structure(session_instance,knowledge_instance,<update_task>,<handles>)
%

% Check if in server mode
if nargin < 4
    handles = [];
end

% Default behavior: Refresh attribute domains, variable
% domains and feature matrices
if nargin < 3
    update_task = 'all';
end

% If target has not been analyzed yet, do it now
if isempty(get_target_features(session_instance))
    session_instance = analyze_sound_file(session_instance,knowledge_instance,handles);
end

% Import target features in 'searchstructure' object
session_instance.search_structure = set_target_features( ...
    session_instance.search_structure,session_instance,knowledge_instance);





switch update_task

    % Update attribute domains
    case 'attributes'
        
        server_says(handles,'Update attribute domains ...',0);
        % Update attributes only if needed
        if session_instance.need_update.dom_attributes
            session_instance.search_structure = compute_attribute_domains( ...
                session_instance.search_structure,session_instance,knowledge_instance);
            session_instance.need_update.dom_attributes = 0;
        end
        server_says(handles,'Update attribute domains ...',1);

    % Udpate variable domains
    case 'variables'
        
        % First update attribute domains if needed
        if session_instance.need_update.dom_attributes
            session_instance = update_search_structure(session_instance,knowledge_instance,'attributes',handles);
        end
        
        server_says(handles,'Update variables domains ...',0);
        % Update variables only if needed
        if session_instance.need_update.dom_variables
            session_instance.search_structure = compute_variable_domains( ...
                session_instance.search_structure,session_instance,knowledge_instance);
            session_instance.need_update.dom_variables = 0;
        end
        server_says(handles,'Update variables domains ...',1);

    % Update feature matrices
    case 'features'
        
        % First update attribute and variables domains if needed
        if session_instance.need_update.dom_attributes
            session_instance = update_search_structure(session_instance,knowledge_instance,'attributes',handles);
        end
        if session_instance.need_update.dom_variables
            session_instance = update_search_structure(session_instance,knowledge_instance,'variables',handles);
        end
        
        % Update feature matrices only if needed
        server_says(handles,'Update features domains ...',0);
        if session_instance.need_update.mat_features
            session_instance.search_structure = compute_feature_structure( ...
                session_instance.search_structure,session_instance,knowledge_instance);
            session_instance.need_update.mat_features = 0;
        end
        server_says(handles,'Update features domains ...',1);

    % Update whole search structure
    case 'all'

        session_instance = update_search_structure(session_instance,knowledge_instance,'attributes',handles);
        session_instance = update_search_structure(session_instance,knowledge_instance,'variables',handles);
        session_instance = update_search_structure(session_instance,knowledge_instance,'features',handles);

end





