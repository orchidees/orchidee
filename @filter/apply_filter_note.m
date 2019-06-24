function value_list = apply_filter_note(filter_instance,session_instance,knowledge_instance)

% APPLY_FILTER_NOTE - Specific apply function for the filter
% associated with the 'note' attribute.
%
% Usage: value_list = apply_filter_note(filter_instance,session_instance,knowledge_instance)
%

target_features = get_target_features(session_instance);

% If target features contain a 'partialsMeanFrequency' field, do:
if isfield(target_features,'partialsMeanFrequency')
  
  switch filter_instance.mode

        case 'auto'
            % If filter in 'auto' mode, convert target partial set
            % into note list
            value_list = get_notes_from_target(session_instance,knowledge_instance);

        case 'free'
            % If filter in 'free' mode, take all notes
            value_list = filter_instance.value_list;

        case 'inex'
            % If filter in 'include' or 'exclude' mode, convert target partial set
            % into note list, add include_list elements and discard
            % remove_list elements
            value_list = get_notes_from_target(session_instance,knowledge_instance);
            value_list = union(value_list,filter_instance.include_list);
            value_list = setdiff(value_list,filter_instance.exclude_list);
            
        case 'force'
            % If filter in 'force' mode, take include_list elements
            % only
            value_list = filter_instance.include_list;

    end

else
    % If target features does not contain a 'partialsMeanFrequency' field, do:
    switch filter_instance.mode

        case 'auto'
             % If filter in 'auto' mode, take all notes
            value_list = filter_instance.value_list;

        case 'free'
             % If filter in 'free' mode, take all notes
            value_list = filter_instance.value_list;

        case 'inex'
             % If filter in 'include' or 'exclude' mode, discard
             % rmove_list elements
            value_list = setdiff(filter_instance.value_list,filter_instance.exclude_list);

        case 'force'
            % If filter in 'force' mode, take include_list elements
            % only
            value_list = filter_instance.include_list;

    end

end

% Sort note by pitches instead of alphabetical order
value_list = reshape(value_list,[],1);
value_list = midi2mtnotes(sort(mtnotes2midi(value_list)));




function value_list = get_notes_from_target(session_instance,knowledge_instance)

% GET_NOTES_FROM_TARGET - Convert target partial set (from the
% 'partialsMeanFrequency' feature) into a list of pitches
%
% Usage: value_list =
% get_notes_from_target(session_instance,knowledge_instance)
%

target_features = get_target_features(session_instance);

% Quantify target partials according to the microtonic resolution
% of the orchestra
[instlist,resolution] = get_orchestra(session_instance);
mtmidi = round(hz2midi(target_features.partialsMeanFrequency)*resolution)/resolution;

% If 'delta' parameter in 'auto' mode, take all the above pitches
if get_target_parameter(session_instance,'autodelta')
    value_list = midi2mtnotes(mtmidi);
else
    % if not, take, take only pitches that contribute to at least
    % one target partial
    contribs = midinotes_partial_contributions(knowledge_instance,mtmidi,target_features.partialsMeanFrequency,get_target_parameter(session_instance,'delta'));
    contribs = sum(contribs,2);
    mtmidi = mtmidi(find(contribs>0));
    value_list = midi2mtnotes(mtmidi);
end