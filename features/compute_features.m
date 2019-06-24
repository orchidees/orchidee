function soundsets_features = compute_features(feature_structure,soundsets,features)

% COMPUTE_FEATURES - Ouput a structure of feature matrices for
% each feature in the input feature cell array. In each feature
% matrix, each line i is the estimation of the feature vector for
% the soundset i. COMPUTE_FEATURES is a generic method that calls
% appropriate methods in the /compute/ sub-directory.
%
% Usage: soundsets_features = compute_features(feature_structure,soundsets,features)
%

Ndescriptors = length(features);

% Iterate on input feature cell array
for k = 1:Ndescriptors
  
    % Call the appropriate compute method for the current feature
    cmd = [ 'soundsets_features.' features{k} ' = compute_' features{k} '(feature_structure,soundsets);' ];
    eval(cmd);
end
