function [tsp_sc,idx_origin,transpo] = transpo_spectralCentroid(knowledge_instance,resolution)

% Transposition method for the spectralCentroid descriptor

sc = get_field_values(knowledge_instance,'spectralCentroid');
n_items = size(sc,1);

sc = repmat(sc,resolution,1);

transpo = 100*(0:1:resolution-1)/resolution;
transpo = repmat(2.^(transpo/1200),n_items,1);
transpo = reshape(transpo,[],1);

sc = sc.*transpo;

[tsp_idx,idx_origin,transpo] = interleave_indices(size(sc,1)/resolution,resolution);

tsp_sc = sc(tsp_idx);