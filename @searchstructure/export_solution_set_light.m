function export_solution_set_light(searchstructure_instance,knowledge_instance,solutions_file,map_file,handles)

% EXPORT_SOLUTION_SET_LIGHT - Export current orchestration solutions in a
% structured text file. If a 4th argument is specified, alos export critria
% and 1D-features of the solution set.
%
% Usage: export_solution_set_light(searchstructure_instance,knowledge_instance,solutions_file,<map_file>,<handles>)
%

% Check if in sever mode
if nargin < 5
    handles = [];
end

% Raise exception if solution set is empty
if isempty(searchstructure_instance.solution_set)
    error('orchidee:searchstructure:export_solution_set:MissingData', ...
        'Nothing to export! Orchestrate first, then retry.');
end

% Open export file
fid = fopen(solutions_file,'w');

% Raise exception if cannot open
if fid == -1
    error('orchidee:searchstructure:export_solution_set_light:CannotOpenFile', ...
        [ 'Cannot open export file ' solutions_file ] );
end

server_says(handles,'Export solution set ...',0);

% write solutions data
for i = 1:size(searchstructure_instance.solution_set.genes,1)

    for j = 1:size(searchstructure_instance.solution_set.genes,2)

        if searchstructure_instance.solution_set.genes(i,j) == searchstructure_instance.feature_structure.neutral_element
            fprintf(fid,'0 +0 ');
        else
            % write sound index and transposition
            db_idx = searchstructure_instance.feature_structure.knowledge_indices(searchstructure_instance.solution_set.genes(i,j));
            tsp = string_transpo(searchstructure_instance.feature_structure.transposition(searchstructure_instance.solution_set.genes(i,j)));
            fprintf(fid,'%d %s ',db_idx,tsp);
        end
    end
    fprintf(fid,'\n');

    server_says(handles,'Export solution set ...',i/size(searchstructure_instance.solution_set.genes,1));

end

% Close export file
fclose(fid);


% If a non-empty 'map_file' is specified, ...
if nargin > 4
    if ~isempty(map_file)

        % Open map file
        fid = fopen(map_file,'w');

        % Raise exception if cannot open
        if fid == -1
            error('orchidee:searchstructure:export_solution_set_light:CannotOpenFile', ...
                [ 'Cannot open map file ' map_file ] );
        end
        
        server_says(handles,'Export solution set map ...',0);
        
        % Get current timbre features
        features = searchstructure_instance.used_features;
        
        % Compute criteria names
        criteria_names = features;
        for k = 1:length(features)
            criteria_names{k} = strcat(criteria_names{k},'_distance');
        end
        % Normalize criteria
        map_criteria = searchstructure_instance.solution_set.criteria;
        map_criteria = map_criteria./repmat(max(map_criteria,[],1),size(map_criteria,1),1);
        
        % Get 1D-feature names and values
        feature_names = {};
        map_features = [];
        for k = 1:length(features)
            if size( searchstructure_instance.solution_set.features.(features{k}) , 2 ) == 1
                feature_names = [ feature_names ; features{k} ];
                map_features = [ map_features searchstructure_instance.solution_set.features.(features{k}) ];
            end
        end
        % Normalize 1D-features
        map_features = map_features-repmat(min(map_features,[],1),size(map_features,1),1);
        map_features = map_features./repmat(max(map_features,[],1),size(map_features,1),1);
        
        % Write map_file first line (file content)
        for k = 1:length(criteria_names)
            fprintf(fid,'%s ',criteria_names{k});
        end
        for k = 1:length(feature_names)
            fprintf(fid,'%s ',feature_names{k});
        end
        fprintf(fid,'\n');
        
        % Write data in map_file
        map_data = [ map_criteria map_features ];
        for i = 1:size( map_data, 1);
            server_says(handles,'Export solution set map ...',i/size(map_data,1));
            for j = 1:size( map_data, 2);
                fprintf(fid,'%1.4f ',map_data(i,j));
            end
            fprintf(fid,'\n');
        end
        
        % Close map_file
        fclose(fid);
        
    end
end






function str_tsp = string_transpo(tsp)

% char strings associated with microtonic pitches

I = find([0 0.125 0.25 0.375 0.5 0.625 0.75 0.875]==tsp);
tsp_all = { '+0' '+1.16' '+1.8' '+3.16' '+1.4' '+5.16' '+3.8' '+7.16' };
str_tsp = tsp_all{I};