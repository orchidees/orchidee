function [tsp_pme,idx_origin,transpo] = transpo_partialsMeanEnergy(knowledge_instance,resolution)

% Transposition method for the partialsMeanEnergy descriptor

pme = get_field_values(knowledge_instance,'partialsMeanEnergy');
pme = repmat(pme,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(pme,1)/resolution,resolution);

tsp_pme = pme(tsp_idx);