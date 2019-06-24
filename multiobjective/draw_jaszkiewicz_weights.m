function W = draw_jaszkiewicz_weights(N,K)

% DRAW_JASZKIEWICZ_WEIGHTS - Draw a set of N K-dimension weight
% vectors uniformly spread on the hyperplane w1+w2+...+wK = 1. The
% generative method is the one suggested by Jaszkiewicz in 
% Andrzej Jaszkiewicz, Comparison of Local Search-Based
% Metaheuristics on the Multiple Objective Knapsack Problem,
% Foundations of Computing and Design Sciences 26 (2001), no. 1, 99-120.
%
% Usage: W = draw_jaszkiewicz_weights(N,K)
%

E = rand((K-1)*N,1);
W = zeros(N,K);
thisE = E(1:N);
W(:,1) = 1-thisE.^(1/(K-1));
for i = 2:K-1 
  thisE = E((i-1)*N+1:i*N);
  sum(W(:,1:i-1),2);
  W(:,i) = (1-sum(W(:,1:i-1),2)).*(1-thisE.^(1/(K-i))); 
end
W(:,K) = 1-sum(W(:,1:K-1),2);