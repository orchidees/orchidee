function neutral_features = neutral_element(feature_structure)

% NEUTRAL_ELEMENT - Ouput a structure of neutral element values for
% each feature in the input feature structure. NEUTRAL_ELEMENT is a
% generic method that calls appropriate methods in the /neutral/
% sub-directory.
%
% Usage: neutral_features = neutral_element(feature_structure)
%

neutral_features = [];

% Iterate on features in input feature structure
for k = 1:length(feature_structure.names)
    
    % Call the appropriate neutral method for the current feature
    cmd = [ 'neutral_features. ' feature_structure.names{k} ' = neutral_' feature_structure.names{k} '(feature_structure);' ];
    eval(cmd);
    
end