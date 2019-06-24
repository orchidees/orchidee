function melMeanAmp_criteria = compare_melMeanAmp(target_features,soundset_features)

% Feature dissimilarity for the melMeanAmp descriptor

MMA_vector_T = target_features.melMeanAmp;
MMA_matrix_T = repmat(MMA_vector_T,size(soundset_features.melMeanAmp,1),1);

C = (soundset_features.melMeanAmp).*MMA_matrix_T;
C = sum(C,2);
C = C./sqrt(sum(soundset_features.melMeanAmp.*soundset_features.melMeanAmp,2));
C = C./sqrt(sum(MMA_matrix_T.*MMA_matrix_T,2));
melMeanAmp_criteria = 1-C;