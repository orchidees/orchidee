function [tsp_ss,idx_origin,transpo] = transpo_spectralSpread(knowledge_instance,resolution)

% Transposition method for the spectralSpread descriptor

ss = get_field_values(knowledge_instance,'spectralSpread');
ss = repmat(ss,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(ss,1)/resolution,resolution);

tsp_ss = ss(tsp_idx);