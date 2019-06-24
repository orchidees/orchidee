function spectralSpread_criteria = compare_spectralSpread(target_features,soundset_features)

% Feature dissimilarity for the spectralSpread descriptor

ss_vector_T = target_features.spectralSpread;
ss_matrix_T = repmat(ss_vector_T,size(soundset_features.spectralSpread,1),1);

spectralSpread_criteria = abs(soundset_features.spectralSpread-ss_matrix_T)./ss_matrix_T;