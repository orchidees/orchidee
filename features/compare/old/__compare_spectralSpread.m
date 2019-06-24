function spectralSpread_criteria = compare_spectralSpread(target_features,soundset_features)

idx_ss_K = find(strcmp(soundset_features.names,'spectralSpread'));
ss_matrix_K = soundset_features.matrix(:,find(soundset_features.positions==idx_ss_K));
ss_vector_T = target_features.spectralSpread;
ss_matrix_T = repmat(ss_vector_T,size(ss_matrix_K,1),1);

spectralSpread_criteria = abs(ss_matrix_K-ss_matrix_T)./ss_matrix_T;