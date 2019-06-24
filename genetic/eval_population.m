function criteria = eval_population(population,feature_structure,target_features,features)

% EVAL_POPULATION - Compute the vector distances between the
% individuals of a population and the target sound. Ouput is a
% matrix where each line is an distance vector associated with one
% individual, and each column is the perceptual dissimilarity along
% one optimization criteria.
%
% Usage: criteria = eval_population(population,feature_structure,target_features,features)
%

% Estimate the perceptual features of the population individuals
population_features = compute_features(feature_structure,population,features);
% Compute the dissimilarities between the population individuals
% and the target
criteria_s = compare_features(target_features,population_features);

% Convert the structure output by compare_features into a matrix
features = fieldnames(criteria_s);
criteria = zeros(size(criteria_s.(features{1}),1),length(features));
for k = 1:length(features)
     criteria(:,k) = criteria_s.(features{k});
end