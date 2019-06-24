function [tsp_pma,idx_origin,transpo] = transpo_partialsMeanAmplitude(knowledge_instance,resolution)

% Transposition method for the partialsMeanAmplitude descriptor

pma = get_field_values(knowledge_instance,'partialsMeanAmplitude');
pma = repmat(pma,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(pma,1)/resolution,resolution);

tsp_pma = pma(tsp_idx,:);