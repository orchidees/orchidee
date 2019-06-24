function criteria = compare_features(target_features,soundset_features)

% COMPARE_FEATURES - Ouput a structure of perceptual dissimilaries
% between target and sound combinations for each feature in the
% input soundset feature structure. In each dissimilarity vector
% each element i is the dissimilarity between the target and
% soundset i for the associated descriptor. COMPARE_FEATURES is a
% generic method that calls appropriate methods in the /compare/ sub-directory.
%
% Usage: criteria = compare_features(target_features,soundset_features)
%

% Iterate on feature structure fields
features = fieldnames(soundset_features);

for k = 1:length(features)
  
    % Call the appropriate compare method for the current feature
    cmd = [ 'criteria.' features{k} ' = compare_' features{k} '(target_features,soundset_features) ;' ];
    eval(cmd);  
end