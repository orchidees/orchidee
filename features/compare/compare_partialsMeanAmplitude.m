function partialsMeanAmplitude_criteria = compare_partialsMeanAmplitude(target_features,soundset_features)

% Feature dissimilarity for the partialsMeanAmplitude descriptor

PMA_vector_T = target_features.partialsMeanAmplitude;
PMA_matrix_T = repmat(PMA_vector_T,size(soundset_features.partialsMeanAmplitude,1),1);

C = (soundset_features.partialsMeanAmplitude).*PMA_matrix_T;
C = sum(C,2);
C = C./sqrt(sum(soundset_features.partialsMeanAmplitude.*soundset_features.partialsMeanAmplitude,2));
C = C./sqrt(sum(PMA_matrix_T.*PMA_matrix_T,2));
partialsMeanAmplitude_criteria = 1-C;

