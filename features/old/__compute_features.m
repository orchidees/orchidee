function soundsets_features = compute_features(feature_structure,soundsets,features)



[T,loc] = ismember(features,feature_structure.names);
[T,loc] = ismember(feature_structure.positions,loc);
positions = loc(T==1);

Ndescriptors = length(features);

matrix = zeros(size(soundsets,1),length(positions));

for k = 1:Ndescriptors
    
    idx = find(positions==k);
    if exist(['compute_' features{k}])
        cmd = [ 'matrix(:,idx) = [ compute_' features{k} '(feature_structure,soundsets) ];' ];
        eval(cmd);
    end
    
end

soundsets_features.names = features;
soundsets_features.positions = positions;
soundsets_features.matrix = matrix;

