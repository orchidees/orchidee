function searchstructure_instance = compute_feature_structure(searchstructure_instance,session_instance,knowledge_instance)

feature_structure.names = {};
feature_structure.positions = [];
feature_structure.matrix = [];
feature_structure.neutral_element = NaN;
feature_structure.knowledge_indices = [];
feature_structure.transposition = [];

notes = get_field_values(knowledge_instance,'note');
midinotes = reshape(note2midi(notes),[],1);
[instlist,resolution] = get_orchestra(session_instance);
[interleave_idx,feature_structure.knowledge_indices, ...
    feature_structure.transposition] = interleave_indices(length(midinotes),resolution);

normalization_features = {};

for i = 1:length(searchstructure_instance.allowed_features)

    switch searchstructure_instance.allowed_features{i}

        case 'partialsMeanAmplitude'

            target_parameters = get_target_parameter(session_instance);
            target_features = get_target_features(session_instance);

            all_notes = [];
            for k = 0:resolution-1
                all_notes = [all_notes ; midinotes+k/resolution];
            end
            all_notes = all_notes(interleave_idx);

            [all_notes_unique,I,J] = unique(all_notes);
            contrib_idx = midinotes_partial_contributions(knowledge_instance, ...
                all_notes_unique,target_features.partialsMeanFrequency,target_parameters.delta);
            contrib_idx = contrib_idx(J,:);

            amplitudes = transpo_partialsMeanAmplitude(knowledge_instance,resolution);

            contrib_idx = contrib_idx';
            contrib_amps = contrib_idx;
            amplitudes = amplitudes';

            k = find(contrib_idx>0);
            offset = repmat((0:1:size(amplitudes,2)-1)*size(amplitudes,1),length(target_features.partialsMeanFrequency),1);
            contrib_idx_offset = contrib_idx+offset;
            index = contrib_idx_offset(k);
            contrib_amps(k) = amplitudes(index);
            contrib_amps = contrib_amps';
            
            feature_structure.names = [ feature_structure.names 'partialsMeanAmplitude' ];
            feature_structure.positions = [ feature_structure.positions ones(1,size(contrib_amps,2))*i ];
            feature_structure.matrix = [ feature_structure.matrix contrib_amps ];
            
            normalization_features = [ normalization_features 'partialsMeanEnergy' ];

        case 'spectralCentroid'
            
            sc = transpo_spectralCentroid(knowledge_instance,resolution);
            feature_structure.names = [ feature_structure.names 'spectralCentroid' ];
            feature_structure.positions = [ feature_structure.positions i ];
            feature_structure.matrix = [ feature_structure.matrix sc ];
            
            normalization_features = [ normalization_features 'melMeanEnergy' ];
            
        case 'spectralSpread'
            
            ss = transpo_spectralSpread(knowledge_instance,resolution);
            feature_structure.names = [ feature_structure.names 'spectralSpread' ];
            feature_structure.positions = [ feature_structure.positions i ];
            feature_structure.matrix = [ feature_structure.matrix ss ];
            
            normalization_features = [ normalization_features 'melMeanEnergy' ];

        otherwise

            error('orchidee:searchstructure:compute_feature_structure:BadArgumentValue', ...
                [ '''' searchstructure_instance.allowed_features{i} ''': unknown feature.' ]);

    end

end

normalization_features = unique(normalization_features);

offset = length(feature_structure.names);

for i = 1:length(normalization_features)

    switch normalization_features{i}
        
        case 'melMeanEnergy'
            
            mme = transpo_melMeanEnergy(knowledge_instance,resolution);
            feature_structure.names = [ feature_structure.names 'melMeanEnergy' ];
            feature_structure.positions = [ feature_structure.positions offset+i ];
            feature_structure.matrix = [ feature_structure.matrix mme ];
            
        case 'partialsMeanEnergy'
            
            pme = transpo_partialsMeanEnergy(knowledge_instance,resolution);
            feature_structure.names = [ feature_structure.names 'partialsMeanEnergy' ];
            feature_structure.positions = [ feature_structure.positions offset+i ];
            feature_structure.matrix = [ feature_structure.matrix pme ];
            
        otherwise
            
            error('orchidee:searchstructure:compute_feature_structure:BadArgumentValue', ...
                [ '''' normalization_features{i} ''': unknown normalization feature.' ]);
            
    end
    
end



feature_structure.neutral_element = size(feature_structure.matrix,1)+1;
feature_structure.matrix = [ feature_structure.matrix ; neutral_element(feature_structure) ];


searchstructure_instance.feature_structure = feature_structure;