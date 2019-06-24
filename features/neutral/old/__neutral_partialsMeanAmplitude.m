function neutral_pma = neutral_partialsMeanAmplitude(feature_structure)

idx = find(strcmp('partialsMeanAmplitude',feature_structure.names));
pos = find(feature_structure.positions==idx);

neutral_pma = zeros(1,length(pos));