function partialsMeanAmplitude = compute_partialsMeanAmplitude(feature_structure,soundsets)

% Combination feature estimator for partialsMeanAmplitude descriptor

n_PMA = size(feature_structure.data.partialsMeanAmplitude,2);

nSounds = size(soundsets,2);
nCombs = size(soundsets,1);

PMA_matrix = feature_structure.data.partialsMeanAmplitude(soundsets',:);
PME_matrix = feature_structure.data.partialsMeanEnergy(soundsets',:);
PMA_matrix = (PMA_matrix.^2).*repmat(PME_matrix,1,n_PMA);

PMA_matrix = reshape(PMA_matrix,nSounds,nCombs,n_PMA);

PMA_matrix = sum(PMA_matrix,1);

PMA_matrix = reshape(PMA_matrix,nCombs,n_PMA);

partialsMeanAmplitude = PMA_matrix;