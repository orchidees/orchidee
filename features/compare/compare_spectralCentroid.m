function spectralCentroid_criteria = compare_spectralCentroid(target_features,soundset_features)

% Feature dissimilarity for the spectralCentroid descriptor

sc_vector_T = target_features.spectralCentroid;
sc_matrix_T = repmat(sc_vector_T,size(soundset_features.spectralCentroid,1),1);

spectralCentroid_criteria = abs(soundset_features.spectralCentroid-sc_matrix_T)./sc_matrix_T;