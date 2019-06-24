function searchstructure_instance = compute_feature_structure(searchstructure_instance,session_instance,knowledge_instance)

% COMPUTE_FEATURE_STRUCTURE - Output a feature structure which is
% used in to estimate de perceptual features of orchestration
% proposals and compute perceptual dissimilarities with the
% target. Note that the features are calculated for ALL sounds of
% the database (plus eventually their microtonic transpositions),
% no matter the filter values. This is used to avoid feature
% recomputation after each filter change.
%
% searchstructure_instance = compute_feature_structure(searchstructure_instance,session_instance,knowledge_instance)
% 

feature_structure.names = {}; % Feature names (optimization and
                              % calculus features - see below)
feature_structure.data = []; % A structure of feature matrices (one
                             % matrix for each feature - Each line
                             % correspond to one sound)
feature_structure.neutral_element = NaN; % Neutral element value
feature_structure.knowledge_indices = []; % The original index of
                                          % each sound in knowledge
                                          % DB (may differ from
                                          % matrices line indices
                                          % because of icrotonic resolution)
feature_structure.transposition = []; % The microtonic
                                      % transposition of each sound


% Get pitches in knowledge database
notes = get_field_values(knowledge_instance,'note');
% Converts to midi
midinotes = reshape(note2midi(notes),[],1);
% Get microtonic resolution of the orchestra
[instlist,resolution] = get_orchestra(session_instance);
% Compute the index vector for interleaving DB items and their
% microtonic transpositions
[interleave_idx,feature_structure.knowledge_indices, ...
    feature_structure.transposition] = interleave_indices(length(midinotes),resolution);

% Assign normalization features (not used as optimization criteria,
% but mandatory for the computation of soundsets feature estimators
normalization_features = {};

% Iterate on optimization features
for i = 1:length(searchstructure_instance.allowed_features)

    switch searchstructure_instance.allowed_features{i}
      
        % Compute 'partialsMeanAmplitude' matrix
        case 'partialsMeanAmplitude'
         
            % Get target analysis parameter
            target_parameters = ...
                get_target_parameter(session_instance);
            % Get target features
            target_features = get_target_features(session_instance);

            % Compute vector of possible note (with microtonic transpositions)
            all_notes = [];
            for k = 0:resolution-1
                all_notes = [all_notes ; midinotes+k/resolution];
            end
            all_notes = all_notes(interleave_idx);

            % Compute the contribution of each pitch to target partials
            [all_notes_unique,I,J] = unique(all_notes);
            contrib_idx = midinotes_partial_contributions(knowledge_instance, ...
                all_notes_unique,target_features.partialsMeanFrequency,target_parameters.delta);
            contrib_idx = contrib_idx(J,:);

            % Extend 'partialsMeanAmplitude' feature to microtonic pitches
            amplitudes = transpo_partialsMeanAmplitude(knowledge_instance,resolution);

            % Compute 'partialsMeanAmplitude' matrix
            contrib_idx = contrib_idx';
            contrib_amps = contrib_idx;
            amplitudes = amplitudes';
            k = find(contrib_idx>0);
            offset = repmat((0:1:size(amplitudes,2)-1)*size(amplitudes,1),length(target_features.partialsMeanFrequency),1);
            contrib_idx_offset = contrib_idx+offset;
            index = contrib_idx_offset(k);
            contrib_amps(k) = amplitudes(index);
            contrib_amps = contrib_amps';

            % Add to feature structure
            feature_structure.names = [ feature_structure.names 'partialsMeanAmplitude' ];
            feature_structure.data.partialsMeanAmplitude = contrib_amps;
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'partialsMeanEnergy' ];

        % Compute 'spectralCentroid' matrix
        case 'spectralCentroid'

            % Add feature name to feature structure
            feature_structure.names = [ feature_structure.names 'spectralCentroid' ];
            % Extend feature to microtonic pitches
            feature_structure.data.spectralCentroid = ...
                transpo_spectralCentroid(knowledge_instance,resolution);
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'melMeanEnergy' ];

        % Compute 'spectralSpread' matrix
        case 'spectralSpread'

            % Add feature name to feature structure
            feature_structure.names = [ feature_structure.names 'spectralSpread' ];
            % Extend feature to microtonic pitches
            feature_structure.data.spectralSpread = ...
                transpo_spectralSpread(knowledge_instance,resolution);
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'melMeanEnergy' ];

        % Compute 'logAttackTime' matrix
        case 'logAttackTime'

            % Add feature name to feature structure
            feature_structure.names = [ feature_structure.names 'logAttackTime' ];
            % Extend feature to microtonic pitches
            feature_structure.data.logAttackTime = ...
                transpo_logAttackTime(knowledge_instance,resolution);
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'loudnessLevel' ];

        % Compute 'energyModAmp' matrix
        case 'energyModAmp'

            % Add feature name to feature structure
            feature_structure.names = [ feature_structure.names 'energyModAmp' ];
            % Extend feature to microtonic pitches
            feature_structure.data.energyModAmp = ...
                transpo_energyModAmp(knowledge_instance,resolution);
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'melMeanEnergy' ];

        % Compute 'melMeanAmp' matrix
        case 'melMeanAmp'

            % Add feature name to feature structure
            feature_structure.names = [ feature_structure.names 'melMeanAmp' ];
            % Extend feature to microtonic pitches
            feature_structure.data.melMeanAmp = ...
                transpo_melMeanAmp(knowledge_instance,resolution);
            % Add the associated normaization feature
            normalization_features = [ normalization_features 'melMeanEnergy' ];

        otherwise

            % Raise exception if unknown feature
            error('orchidee:searchstructure:compute_feature_structure:BadArgumentValue', ...
                [ '''' searchstructure_instance.allowed_features{i} ''': unknown feature.' ]);

    end

end

% Get normalization_feature (not used as optimization criteria but
% as data for estimating sound features of sound combinations
normalization_features = unique(normalization_features);

% Iterate on normalization features
for i = 1:length(normalization_features)

    switch normalization_features{i}

        % Compute 'melMeanEnergy' matrix
        case 'melMeanEnergy'

            % Extend 'melMeanEnergy' feature to microtonic pitches
            mme = transpo_melMeanEnergy(knowledge_instance,resolution);
            % Add feature to struct
            feature_structure.names = [ feature_structure.names 'melMeanEnergy' ];
            feature_structure.data.melMeanEnergy = mme;

        % Compute 'partialsMeanEnergy' matrix
        case 'partialsMeanEnergy'

             % Extend 'partialsMeanEnergy' feature to microtonic pitches
            pme = transpo_partialsMeanEnergy(knowledge_instance,resolution);
            % Add feature to struct
            feature_structure.names = [ feature_structure.names 'partialsMeanEnergy' ];
            feature_structure.data.partialsMeanEnergy = pme;

        % Compute 'loudnessLevel' matrix
        case 'loudnessLevel'

            % Extend 'loudnessLevel' feature to microtonic pitches
            ll = transpo_loudnessLevel(knowledge_instance,resolution);
            % Add feature to struct
            feature_structure.names = [ feature_structure.names 'loudnessLevel' ];
            feature_structure.data.loudnessLevel = ll;

        otherwise

         % Raise exception if unknow normalization feature   
         error('orchidee:searchstructure:compute_feature_structure:BadArgumentValue', ...
                [ '''' normalization_features{i} ''': unknown normalization feature.' ]);

    end

end

% Compute neutral element index value
feature_structure.neutral_element = size(feature_structure.data.(feature_structure.names{1}),1)+1;

% Compute neutral element features
ntr = neutral_element(feature_structure);

% Add neutral element features to feature matrices
for k = 1:length(feature_structure.names)
    feature_structure.data.(feature_structure.names{k}) = ...
        [ feature_structure.data.(feature_structure.names{k}) ; ntr.(feature_structure.names{k}) ];
end

% Assign slot
searchstructure_instance.feature_structure = feature_structure;