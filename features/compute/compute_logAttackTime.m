function logAttackTime = compute_logAttackTime(feature_structure,soundsets)

% Combination feature estimator for logAttackTime descriptor

lat_matrix = feature_structure.data.logAttackTime(soundsets);
ll_matrix = feature_structure.data.loudnessLevel(soundsets);

ll_matrix = 2.^(ll_matrix./10);

lat_matrix = reshape(lat_matrix,size(soundsets,1),size(soundsets,2));
ll_matrix = reshape(ll_matrix,size(soundsets,1),size(soundsets,2));


logAttackTime = sum(lat_matrix.*ll_matrix,2)./sum(ll_matrix,2);

