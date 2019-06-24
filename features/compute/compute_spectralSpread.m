function spectralSpread = compute_spectralSpread(feature_structure,soundsets)

% Combination feature estimator for spectralSpread descriptor

sc_matrix = feature_structure.data.spectralCentroid(soundsets);
ss_matrix = feature_structure.data.spectralSpread(soundsets);
ener_matrix = feature_structure.data.melMeanEnergy(soundsets);

sc_matrix = reshape(sc_matrix,size(soundsets,1),size(soundsets,2));
ss_matrix = reshape(ss_matrix,size(soundsets,1),size(soundsets,2));
ener_matrix = reshape(ener_matrix,size(soundsets,1),size(soundsets,2));

spectralCentroid = sum(sc_matrix.*ener_matrix,2)./sum(ener_matrix,2);

moment2_matrix = ss_matrix.^2+sc_matrix.^2;

spectralSpread = sqrt(sum(moment2_matrix.*ener_matrix,2)./sum(ener_matrix,2)-spectralCentroid.^2);