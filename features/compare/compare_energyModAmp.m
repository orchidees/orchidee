function energyModAmp_criteria = compare_energyModAmp(target_features,soundset_features)

% Feature dissimilarity for the energyModAmp descriptor

ema_vector_T = target_features.energyModAmp;
ema_matrix_T = repmat(ema_vector_T,size(soundset_features.energyModAmp,1),1);

energyModAmp_criteria = abs(soundset_features.energyModAmp-ema_matrix_T)./ema_matrix_T;