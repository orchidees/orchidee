function [tsp_ema,idx_origin,transpo] = transpo_energyModAmp(knowledge_instance,resolution)

% Transposition method for the energyModAmp descriptor

ema = get_field_values(knowledge_instance,'energyModAmp');
ema = repmat(ema,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(ema,1)/resolution,resolution);

tsp_ema = ema(tsp_idx);