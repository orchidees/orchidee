function [tsp_lat,idx_origin,transpo] = transpo_logAttackTime(knowledge_instance,resolution)

% Transposition method for the logAttackTime descriptor

lat = get_field_values(knowledge_instance,'logAttackTime');
lat = repmat(lat,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(lat,1)/resolution,resolution);

tsp_lat = lat(tsp_idx);