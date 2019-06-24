function [tsp_mme,idx_origin,transpo] = transpo_melMeanEnergy(knowledge_instance,resolution)

% Transposition method for the melMeanEnergy descriptor

mme = get_field_values(knowledge_instance,'melMeanEnergy');
mme = repmat(mme,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(mme,1)/resolution,resolution);

tsp_mme = mme(tsp_idx);