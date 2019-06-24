function T = is_dominated_by(critA,critB,mode)

% IS_DOMINATED_BY - Pareto domination test. Return 1 iif critB
% Pareto-dominates critA. 'mode' is used to decide between a maximization
% or minimization problem.
%
% Usage: T = is_dominated_by(critA,critB,mode)
% 

% Reshape critA to critB size
critA = ones(size(critB,1),1)*critA;

% Compare A & B vectors
if strcmp(mode,'min')
  % Minimization case
  T = min((critB<critA),[],2);
else
  % Maximization case
  T = min((critB>critA),[],2);
end
