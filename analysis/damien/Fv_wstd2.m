% function [sm2] = Fv_wstd2(x_v, [prob_v])
%
% DESCRIPTION:
% ============
% compute the std value of x_v or the weigthed (prob_v) std value 
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
% (LAST EDIT: Gfp 28/02/2003
%

function [sm2] = Fv_wstd2(x_v, prob_v)


% =======================
%x_v 		= x_v(:);
L   		= length(x_v);
if nargin < 2, prob_v = ones(L,1);, end
prob_v	= prob_v(:)/sum(prob_v);
if length(x_v) ~= length(prob_v), error('wrong size');, end
% =======================

% === moyenne
m	= sum(x_v .* prob_v);
xc_v	= x_v - m;

% === std
m2	= sum(xc_v.^2 .* prob_v);
sm2	= sqrt( m2 );
