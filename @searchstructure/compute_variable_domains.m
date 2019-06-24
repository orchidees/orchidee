function searchstructure_instance = compute_variable_domains(searchstructure_instance,session_instance,knowledge_instance)

% COMPUTE_VARIABLE_DOMAINS - Compute the search domains for each
% variable of the current orchestration problem, i.e. for each
% instrument (or instrument group in the orchestra). The domains
% are computed according to the state of the different filters.
%
% Usage: searchstructure_instance = compute_variable_domains(searchstructure_instance,session_instance,knowledge_instance)
%

% Compute neutral element value
if isempty(searchstructure_instance.feature_structure)
    uris = get_field_values(knowledge_instance,'uri');
    [orch,res] = get_orchestra(session_instance);
    ntr_elem = size(uris,1)*res+1;
else
    ntr_elem = searchstructure_instance.feature_structure.neutral_element;
end

% Get filter names
filters = fieldnames(searchstructure_instance.attribute_domains);

% Get instrument list and microtonic resolution of the orchestra
[instlist,resolution] = get_orchestra(session_instance);

% Initialize output
variable_domains = cell(1,length(instlist));

% Iterate on instruments (or instrument groups)
for k = 1:length(instlist)

    % get current instrument or group
    instruments = instlist{k};
    domain = [];

    % Add all instrument (or instrument group) sounds to domain 
    if iscell(instruments)
        for i = 1:length(instruments)
            domain = [ domain ; query(knowledge_instance,'instrument',instruments{i}) ];
        end
    else
        domain = [ domain ; query(knowledge_instance,'instrument',instruments) ];
    end

    % Iterate on filters
    for j = 1:length(filters)

        switch filters{j}

            case 'instrument'

                % Do nothing: instrument filtering is useless after
                % the above instrument query

            case 'note'

                % Do nothing: the 'note' filter is separatedly
                % processed afterwards (due to microtonic
                % resolution specificities)

            otherwise
                
                % Get allowed values for current filter
                if ~ischar(searchstructure_instance.attribute_domains.(filters{j}))
                    
                    % Query knowledge for matching items and
                    % reduce the variable domain
                    idx = query(knowledge_instance,filters{j}, ...
                        searchstructure_instance.attribute_domains.(filters{j}));
                    domain = intersect(domain,idx);

                elseif strcmp(searchstructure_instance.attribute_domains.(filters{j}),'all')

                    % If the allowed value list has a char value, take
                    % it as the keyword 'all' (the filter is
                    % all-pass). Do nothing (all values are allowed).

                end

        end

    end

    % Add microtonic pitches to variable domain
    domain = repmat(domain,1,resolution);
    offset = (0:1:resolution-1)/resolution;
    offset = repmat(offset,size(domain,1),1);
    domain = domain+offset;
    domain = reshape(domain,[],1);
    domain = sort(domain);
    domain = resolution*domain-(resolution-1);

    % Now, process the not filter
    note_domain = [];

    % Get allowed values for note filter
    if ~ischar(searchstructure_instance.attribute_domains.note)

        % Iterate on note values
        for j = 1:length(searchstructure_instance.attribute_domains.note)

            this_note = searchstructure_instance.attribute_domains.note{j};
            
            % If microtonic pitch, retrieve original semitone pitch
            % and compute microtonic transposition
            if length(strfind(this_note,'+'))
                plus_idx = strfind(this_note,'+');
                upper = str2num(this_note(plus_idx+1));
                lower = str2num(this_note(plus_idx+3:length(this_note)))/2;
                transpo = upper/lower;
                this_note = this_note(1:plus_idx-1);
            else
                transpo = 0;
            end

            % Query knowledge for matching items
            idx = query(knowledge_instance,'note',this_note);
            % Shift indices to account for microtonic transpo
            idx = idx+transpo;
            idx = resolution*idx-(resolution-1);
            % Add to note domain
            note_domain = [ note_domain ; idx ];

        end

        % Reduce variable domain with note domain
        domain = intersect(domain,note_domain);

    elseif strcmp(searchstructure_instance.attribute_domains.(filters{j}),'all')

        % If the allowed note list has a char value, take
        % it as the keyword 'all' (the filter is
        % all-pass). Do nothing (all notes are allowed).

    end
    
    % Add neutral element
    domain = [ domain ; ntr_elem ];

    % Add domain to structure
    variable_domains{k} = domain;

end

% Assign object slot
searchstructure_instance.variable_domains = variable_domains;