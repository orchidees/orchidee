function [idx,origin,transpo] = interleave_indices(n_rows,factor)

% INTERLEAVE_INDICES - Ouput an index vector for feature microtonic
% transposition. This index vector is used to sort features by
% increasing pitch order.
%
% Let F be a feature matrix for semitone samples, and F2, F4, ...,
% Fn microtonic transpositions of F. Let p = size(F,1) and
% [idx,origin,transpo] = interleave_indices(p,n). Let FF be the
% concatenation [ F ; F2 ; F4 ; ... ; Fn ]. Then FF(idx,:) is
% sorted by increasing pitch. Moreover, given a line i of FF,
% origin(i) gives the index of the base semitone tone sound in F
% from which FF(i) is derived, and transpo(i) gives the amount of
% transposition (in fraction of semitone).
%
% Usage: [idx,origin,transpo] = interleave_indices(n_rows,factor)
%

idx = (1:1:n_rows)';
idx = repmat(idx,1,factor);

shift = (0:1:(factor-1))/factor;
shift = repmat(shift,n_rows,1);

idx = idx+shift;
idx = reshape(idx,[],1);

[idx,sort_idx] = sort(idx);

origin = floor(idx);
transpo = idx-origin;

idx = sort_idx;