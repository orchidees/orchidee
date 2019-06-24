function criteria = compare_features(target_features,soundset_features)



criteria.names = soundset_features.names;
criteria.matrix = ones(size(soundset_features.matrix,1),length(criteria.names));

for k = 1:length(criteria.names)
    
    cmd = [ 'D = compare_' criteria.names{k} '(target_features,soundset_features) ;' ];
    eval(cmd);
    
    criteria.matrix(:,k) = D;
    
end