function [tsp_ll,idx_origin,transpo] = transpo_loudnessLevel(knowledge_instance,resolution)

% Transposition method for the loudnessLevel descriptor

ll = get_field_values(knowledge_instance,'loudnessLevel');
ll = repmat(ll,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(ll,1)/resolution,resolution);

tsp_ll = ll(tsp_idx);