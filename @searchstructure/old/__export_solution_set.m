function export_solution_set(searchstructure_instance,knowledge_instance,filename,handles)

if nargin < 4
    handles = [];
end

if isempty(searchstructure_instance.solution_set)
    error('orchidee:searchstructure:export_solution_set:MissingData', ...
        'Nothing to export! Orchestrate first, then retry.');
end



fid = fopen(filename,'w');

if fid == -1
    error('orchidee:searchstructure:export_solution_set:CannotOpenFile', ...
        [ 'Cannot open export file ' filename ] );
end

server_says(handles,'Export solution set ...',0);

% write number of solution
fprintf(fid,'%d\n',size(searchstructure_instance.solution_set.genes,1));

% write number of instruments
fprintf(fid,'%d\n',size(searchstructure_instance.solution_set.genes,2));

% write number of features
fprintf(fid,'%d\n',length(searchstructure_instance.used_features));

% write optimization features
for k = 1:length(searchstructure_instance.used_features)
    fprintf(fid,'%s\n',searchstructure_instance.used_features{k});
end

% write solutions data
for i = 1:size(searchstructure_instance.solution_set.genes,1)
    
    % write solution number
    fprintf(fid,'%d\n',i);
    
    % write symbolic data
    for j = 1:size(searchstructure_instance.solution_set.genes,2)
        if searchstructure_instance.solution_set.genes(i,j) == searchstructure_instance.feature_structure.neutral_element
            fprintf(fid,'%s\n','<empty>');
        else
            % write instrument, note, playingstyle, dynamics, mute string
            db_idx = searchstructure_instance.feature_structure.knowledge_indices(searchstructure_instance.solution_set.genes(i,j));
            inst = get_field_values(knowledge_instance,'instrument',db_idx); inst = inst{1};
            note = get_field_values(knowledge_instance,'note',db_idx); note = note{1};
            tsp = string_transpo(searchstructure_instance.feature_structure.transposition(searchstructure_instance.solution_set.genes(i,j)));
            if ~strcmp(tsp,'+0'), note = [ note tsp ]; end
            ps = get_field_values(knowledge_instance,'playingStyle',db_idx); ps = ps{1};
            dy = get_field_values(knowledge_instance,'dynamics',db_idx); dy = dy{1};
            sm = get_field_values(knowledge_instance,'stringMute',db_idx); sm = sm{1};
            bm = get_field_values(knowledge_instance,'brassMute',db_idx); bm = bm{1};
            if strcmp(sm,'NA') && strcmp(bm,'NA')
                mute = 'NA';
            elseif strcmp(sm,'NA') && ~strcmp(bm,'NA')
                mute = bm;
            elseif ~strcmp(sm,'NA') && strcmp(bm,'NA')
                mute = sm;
            end
            co = get_field_values(knowledge_instance,'string',db_idx);
            fprintf(fid,'%s %s %s %s %s %d ',inst,note,ps,dy,mute,co);
            % sample path
            dir = get_field_values(knowledge_instance,'dir',db_idx); dir = dir{1};
            file = get_field_values(knowledge_instance,'file',db_idx); file = file{1};
            fprintf(fid,'%s%s ',dir,file);
            % write performance corrections
            tsp = string_transpo(searchstructure_instance.feature_structure.transposition(searchstructure_instance.solution_set.genes(i,j)));
            lf = get_field_values(knowledge_instance,'loudnessFactor',db_idx);
            fprintf(fid,'%s %10.8f\n',tsp,lf);
        end
    end
    
    % write solution features
    for j = 1:length(searchstructure_instance.used_features)
        feature_idx = find(searchstructure_instance.solution_set.features.positions==j);
        feature_str = mat2str(searchstructure_instance.solution_set.features.matrix(i,feature_idx));
        feature_str = strrep(feature_str,'[',''); feature_str = strrep(feature_str,']','');
        fprintf(fid,'%s\n',feature_str);
    end
    
    % write solution criteria
    for j = 1:length(searchstructure_instance.used_features)
        crit = searchstructure_instance.solution_set.criteria(i,j);
        fprintf(fid,'%10.8f\n',crit);
    end
        
    
    server_says(handles,'Export solution set ...',i/size(searchstructure_instance.solution_set.genes,1));
        
end


fclose(fid);







function str_tsp = string_transpo(tsp)

I = find([0 0.125 0.25 0.375 0.5 0.625 0.75 0.875]==tsp);
tsp_all = { '+0' '+1.16' '+1.8' '+3.16' '+1.4' '+5.16' '+3.8' '+7.16' };
str_tsp = tsp_all{I};