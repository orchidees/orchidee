function logAttackTime_criteria = compare_logAttackTime(target_features,soundset_features)

% Feature dissimilarity for the logAttackTime descriptor

lat_vector_T = target_features.logAttackTime;
lat_matrix_T = repmat(lat_vector_T,size(soundset_features.logAttackTime,1),1);

logAttackTime_criteria = abs(soundset_features.logAttackTime-lat_matrix_T)./abs(lat_matrix_T);