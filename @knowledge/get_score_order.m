function scoreorder = get_score_order(knowledge_instance)
%
% SCOREORDER - Return a string of all database instruments in orchestral
% order (families are separated with the symbol '-'). The order is read
% from a preference file in ~/Library/Preferences/IRCAM/Orchidee/. If not
% preference file exist, the order is computed from a set of rules
% implicitely defined by nomenclature.m, and a new prefernece file is
% written. Hence, the score order may be easily modified by editing
% manually the preference file.
%
% Usage: scoreorder = get_score_order(knowledge_instance)
%

% Set need-a-new-pref-file flag to false
need_new_file = 0;
% Look for scoreorder prefernce file
[s, score_order_prefs_file] = unix([ 'find ' home_directory '/Library/Preferences/IRCAM/Orchidee -name "scoreorder*"' ]);
% If no preference file exists ...
if isempty(score_order_prefs_file)
    % ... set need-a-new-pref-file flag to true
    need_new_file = 1;
else
    % ... else read preference file
    score_order_prefs_file = score_order_prefs_file(1:length(score_order_prefs_file)-1);
    % Get file creation date
    pat = '\d\d\d\d\d\d\d\d\d\d\d\d\d\d';
    file_date = regexp(score_order_prefs_file, pat, 'match');
    file_date = str2num(file_date{1});
    % If file is too older than knowledge, trash it
    if file_date < str2num(get_creation_date(knowledge_instance))
        need_new_file = 1;
        unix(['rm ' score_order_prefs_file]);
    end
end

% If the current preference file is valid ...
if ~need_new_file
    % ... read it and format content
    fid = fopen(score_order_prefs_file);
    scoreorder = fscanf(fid, '%s');
    scoreorder = strrep(scoreorder, ',', ' ');
    scoreorder = strrep(scoreorder, '-', ' - ');
    scoreorder = strrep(scoreorder, '  ', ' ');
    fclose(fid);   
else
    % ... else, creete preference file from knowledge
    % Get instrument list in knowledgd
    instlist = get_field_value_list(knowledge_instance, 'instrument');
    % Get standardized nomenclature
    known_nomenclature = nomenclature(knowledge_instance);
    known_families = known_nomenclature(:,1);
    known_instruments = known_nomenclature(:,3);
    % This is a
    family_index = ones(length(known_families), 1);
    for k = 2:length(known_families);
        if strcmp(known_families(k), known_families(k-1))
            family_index(k) = family_index(k-1);
        else
            family_index(k) = family_index(k-1)+1;
        end
    end
    % Initialize instrument rank vector
    sort_instlist = zeros(length(instlist), 1);
    % Iterate on instrument list
    for k = 1:length(instlist)
        
        %if strcmp(instlist{k},'Sn'), keyboard; end
        %if strcmp(instlist{k},'Sw'), keyboard; end
        
        % Is current instrument in the nomenclature?
        [T,idx] = ismember(instlist{k}, known_instruments);
        % If yes ...
        if T
            % ... compute current instrument's rank
            this_family = known_families(idx);
            family_idx = find(strcmp(this_family, known_families));
            sort_instlist(k) = family_index(idx)+(((find(family_idx==idx))-1)/length(family_idx));
        else
            % ... else, get current instrument's family
            this_family = get_family(knowledge_instance, instlist{k});
            T = ismember(this_family, known_families);
            % If family is known...
            if T
                % ... append instrument to the family
                % Update known families and instruments with new instrument
                idx = find(strcmp(this_family, known_families), 1, 'last' );
                known_families = [ known_families(1:idx) ; this_family ; known_families(idx+1:length(known_families)) ];
                family_index = [ family_index(1:idx) ; family_index(idx) ; family_index(idx+1:length(family_index)) ];
                known_instruments = [ known_instruments(1:idx) ; instlist(k) ; known_instruments(idx+1:length(known_instruments)) ];
                % Compute current instrument's rank
                idx = idx+1;
                family_idx = find(strcmp(this_family, known_families));
                sort_instlist(k) = family_index(idx)+(((find(family_idx==idx))-1)/length(family_idx));
            else
                % ... else append instrument and family at the end of the list
                idx = length(known_families);
                known_families = [ known_families ; this_family ];
                family_index = [ family_index ; family_index(idx)+1 ];
                known_instruments = [ known_instruments ; instlist(k) ];
                % Compute current instrument's rank
                idx = idx+1;
                family_idx = find(strcmp(this_family, known_families));
                sort_instlist(k) = family_index(idx)+(((find(family_idx==idx))-1)/length(family_idx));
            end
        end
    end
    % Sort instrument list according to the previously computed ranks
    [sort_instlist, I] = sort(sort_instlist);
    instlist = instlist(I);
    % Open new preferences file
    score_order_prefs_file = [ home_directory '/Library/Preferences/IRCAM/Orchidee/scoreorder' ...
    datestr(now, 'yyyymmddHHMMSS')];
    fid = fopen(score_order_prefs_file, 'w');
    % Write preference file
    fprintf(fid, '%s,\n', instlist{1});
    for k = 2:length(instlist)
        [t, idx] = ismember(instlist{k-1}, known_instruments);
        prev_family = known_families{idx};
        [t, idx] = ismember(instlist{k}, known_instruments);
        this_family = known_families{idx};
        if ~strcmp(prev_family, this_family)
            fprintf(fid, '-\n');
        end
        fprintf(fid, '%s,\n', instlist{k});
    end
    fclose(fid);
    % Output score order
    scoreorder = get_score_order(knowledge_instance);
end




function family = get_family(knowledge_instance, instrument)
%
% GET_FAMILY - Return the family of an instrument, specified by its symbol
% in the nomenclature.
%
% Usage: family = get_family(knowledge_instance, instrument)
%

% Get all the database entries for the input instrument
idx = query(knowledge_instance, 'instrument', instrument);
% Get the family of the first entry
family = get_field_values(knowledge_instance, 'family', idx(1));
