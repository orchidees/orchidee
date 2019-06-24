function criteria = eval_population(population,feature_structure,target_features,features)

population_features = compute_features(feature_structure,population,features);
criteria = compare_features(target_features,population_features);

criteria = criteria.matrix;