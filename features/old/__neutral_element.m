function neutral_features = neutral_element(feature_structure)

neutral_features = [];

for k = 1:length(feature_structure.names)
    
    cmd = [ 'neutral_features = [ neutral_features neutral_' feature_structure.names{k} '(feature_structure) ];' ];
    eval(cmd);
    
end