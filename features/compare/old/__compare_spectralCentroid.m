function spectralCentroid_criteria = compare_spectralCentroid(target_features,soundset_features)

idx_sc_K = find(strcmp(soundset_features.names,'spectralCentroid'));
sc_matrix_K = soundset_features.matrix(:,find(soundset_features.positions==idx_sc_K));
sc_vector_T = target_features.spectralCentroid;
sc_matrix_T = repmat(sc_vector_T,size(sc_matrix_K,1),1);

spectralCentroid_criteria = abs(sc_matrix_K-sc_matrix_T)./sc_matrix_T;