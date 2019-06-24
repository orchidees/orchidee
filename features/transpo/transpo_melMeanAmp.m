function [tsp_mma,idx_origin,transpo] = transpo_melMeanAmp(knowledge_instance,resolution)

% Transposition method for the melMeanAmp descriptor

% This transpo function is a rough approximation
% A better one would interpolate the mel spectra between two pitches

mma = get_field_values(knowledge_instance,'melMeanAmp');
mma = repmat(mma,resolution,1);

[tsp_idx,idx_origin,transpo] = interleave_indices(size(mma,1)/resolution,resolution);

tsp_mma = mma(tsp_idx,:);