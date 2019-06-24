function session_instance = orchestrate(session_instance,knowledge_instance,handles)

% ORCHESTRATE - Run the orchestration algorithm.
%
% Usage: session_instance = orchestrate(session_instance,knowledge_instance,handles)
%

% Update search structure if needed
session_instance = update_search_structure(session_instance,knowledge_instance,'all',handles);

% Run the orchestration algorithm
session_instance.search_structure = orchestrate(session_instance.search_structure,handles);