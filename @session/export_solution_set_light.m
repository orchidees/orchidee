function export_solution_set_light(session_instance,knowledge_instance,filename,map_file,handles)

% EXPORT_SOLUTION_SET_LIGHT - Export current solution set in two text
% files: 'filename' contains the IDs of database sounds (and the microtonic tuning)
% in each solution, 'map_file' contains solution's criteria ans 1D-feature
% values.
%
% Usage: export_solution_set_light(session_instance,knowledge_instance,filename,map_file,handles)
%

export_solution_set_light(session_instance.search_structure,knowledge_instance,filename,map_file,handles);