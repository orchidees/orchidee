function [varargout] = Fcomparepics2(varargin)
% CCCCCCCCCC
% function [pos_peak_v] = Fcomparepics2(input_v, lag_n, do_affiche, lag2_n, threshold)
%
% DESCRIPTION:
% ============
% detection des maxima locaux [n-lag:n+lag] du vecteur input_v
%
% INPUTS:
% =======
% - input_v					: le spectre d'amplitude
% - lag_n		(2)			: nombre de points lateraux de comparaisons
% - do_affiche	(0)			:
% - lag2_n		(2*lag_n)	:
% - threshold	(0)			:
%
% OUTPUTS:
% ========
% - pos_peak_v				: position des maximas locaux
%
% LAST EDIT: peeters@ircam.fr 2006/05/24: debug traitement des extrémités, ajout traitement données négatives, plusieurs méthode de threshold
% REFERENCE VERSION
%

[varargout{1:nargout}] = Fcomparepics2_main(varargin{:});
