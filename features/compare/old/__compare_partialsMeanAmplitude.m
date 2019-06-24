function partialsMeanAmplitude_criteria = compare_partialsMeanAmplitude(target_features,soundset_features)

idx_PMA_K = find(strcmp(soundset_features.names,'partialsMeanAmplitude'));
PMA_matrix_K = soundset_features.matrix(:,find(soundset_features.positions==idx_PMA_K));
PMA_vector_T = target_features.partialsMeanAmplitude;
PMA_matrix_T = repmat(PMA_vector_T,size(PMA_matrix_K,1),1);

C = PMA_matrix_K.*PMA_matrix_T;
C = sum(C,2);
C = C./sqrt(sum(PMA_matrix_K.*PMA_matrix_K,2));
C = C./sqrt(sum(PMA_matrix_T.*PMA_matrix_T,2));
partialsMeanAmplitude_criteria = 1-C;

