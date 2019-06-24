function spectralCentroid = compute_spectralCentroid(feature_structure,soundsets)

% Combination feature estimator for spectralCentroid descriptor

sc_matrix = feature_structure.data.spectralCentroid(soundsets);
ener_matrix = feature_structure.data.melMeanEnergy(soundsets);

sc_matrix = reshape(sc_matrix,size(soundsets,1),size(soundsets,2));
ener_matrix = reshape(ener_matrix,size(soundsets,1),size(soundsets,2));

spectralCentroid = sum(sc_matrix.*ener_matrix,2)./sum(ener_matrix,2);