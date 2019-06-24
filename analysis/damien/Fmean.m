% function [m] = Fmean(x_v, [prob_v])
%
% DESCRIPTION
% ============
% compute the mean value of x_v or the weigthed (prob_v) mean value 
%
% INPUTS:
% =======
% -x_v		:
% -prob_v	:
%
% OUTPUTS:
% ========
% -m		:
%
% LAST EDIT: Gfp 09/01/2003
% 

function [m] = Fmean(x_v, prob_v)


% =======================
x_v 		= x_v(:);
L   		= length(x_v);
if nargin < 2, prob_v = ones(L,1);, end
prob_v	= prob_v(:)/sum(prob_v);
if length(x_v) ~= length(prob_v), error('wrong size');, end
% =======================

m  		= sum(x_v .* prob_v);

if 0
    plot(x_v, prob_v), 
    M = max(prob_v)
    hold on, plot(m, M, 'r*'), hold off
    title(num2str(m))
    pause
end
    