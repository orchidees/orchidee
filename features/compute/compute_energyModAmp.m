function energyModAmp = compute_energyModAmp(feature_structure,soundsets)

% Combination feature estimator for energyModAmp descriptor

ema_matrix = feature_structure.data.energyModAmp(soundsets);
mme_matrix = feature_structure.data.melMeanEnergy(soundsets);

ema_matrix = reshape(ema_matrix,size(soundsets,1),size(soundsets,2));
mme_matrix = reshape(mme_matrix,size(soundsets,1),size(soundsets,2));

energyModAmp = sum(ema_matrix.*mme_matrix,2)./sum(mme_matrix,2);

