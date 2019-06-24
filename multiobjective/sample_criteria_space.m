function [n,C] = sample_criteria_space(C,k)

% SAMPLE_CRITERIA_SPACE - Remove dominated elements from a criteria
% set by random direction drawing. Call this method before
% extracting pareto sets on large population to decrease the
% computational cost.
%
% Usage: [n,C] = sample_criteria_space(C,k)
%
% Inputs: - A criteria set C
%         - A number of random draws k
% Outputs: - The size of the sampled population n
%          - The sampled population criteria C
%

n = 0;
dim = size(C,2);
W = rand(k,dim);
for i = 1:k    
    CW = C.*(ones(size(C,1),1)*W(i,:));
    CW = max(CW,[],2);
    [m,I] = min(CW);
    P = C(I,:);
    idx = C > ones(size(C,1),1)*P;
    idx = min(idx,[],2);
    idx = find(~idx);
    C = C(idx,:);
end
n = length(C);