function melMeanAmp = compute_melMeanAmp(feature_structure,soundsets)

% Combination feature estimator for melMeanAmp descriptor

n_MMA = size(feature_structure.data.melMeanAmp,2);

nSounds = size(soundsets,2);
nCombs = size(soundsets,1);

MMA_matrix = feature_structure.data.melMeanAmp(soundsets',:);
MME_matrix = feature_structure.data.melMeanEnergy(soundsets',:);
MMA_matrix = (MMA_matrix.^2).*repmat(MME_matrix,1,n_MMA);

MMA_matrix = reshape(MMA_matrix,nSounds,nCombs,n_MMA);

MMA_matrix = (sum(MMA_matrix,1)).^(1/2);

melMeanAmp = reshape(MMA_matrix,nCombs,n_MMA);

