function partialsMeanAmplitude = compute_partialsMeanAmplitude(feature_structure,soundsets)

idx_PMA = find(strcmp(feature_structure.names,'partialsMeanAmplitude'));
idx_PME = find(strcmp(feature_structure.names,'partialsMeanEnergy'));

n_PMA = length(find(feature_structure.positions==idx_PMA));
nSounds = size(soundsets,2);
nCombs = size(soundsets,1);

PMA_matrix = feature_structure.matrix(:,(feature_structure.positions==idx_PMA));
PME = feature_structure.matrix(:,(feature_structure.positions==idx_PME));
PME_matrix = repmat(PME,1,n_PMA);
PMA_matrix = (PMA_matrix.^2).*PME_matrix;

PMA_matrix = PMA_matrix(soundsets',:);
PMA_matrix = reshape(PMA_matrix,nSounds,nCombs,n_PMA);

PMA_matrix = sum(PMA_matrix,1);

PMA_matrix = reshape(PMA_matrix,nCombs,n_PMA);

partialsMeanAmplitude = PMA_matrix;