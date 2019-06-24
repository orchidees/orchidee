function [mating_pool_idx,mating_pool_fitness] = select_popuation(fitness,mating_pool_size)

% SELECT_PUPULATION - Perform a binary tournament (with
% replacement) procedure to select individuals on the basis
% of their fitness. Output is an index vector.
%
% Usage: [mating_pool_idx,mating_pool_fitness] = select_popuation(fitness,mating_pool_size)
%

n = length(fitness);
fitness = reshape(fitness,[],1);
I = randsample(n,mating_pool_size*2,true);
I = [ I(1:mating_pool_size) I(mating_pool_size+1:mating_pool_size*2) ];
F = fitness(I);
[F,i] = min(F,[],2);
i = i+(0:1:mating_pool_size-1)'*2;
I = I';
mating_pool_idx = I(i);
mating_pool_idx = reshape(mating_pool_idx,[],1);
mating_pool_fitness = F;