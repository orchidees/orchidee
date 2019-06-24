% function [env_v] = Fnrgfiltre(data_v, Fe_hz, fc_hz)
%
% DESCRIPTION:
% ============
% calcul de l'enveloppe temporelle d'un signal s(t) par filtrage de l'envelope
% du signal analytique
%
% INPUTS:
% =======
% data_v	:
% Fe_hz	[Hz]	: fréquence d'echantillonnage (Hz) 
% fc_hz [Hz]	: fréquence de coupure pour lissage de l'enveloppe par passe-bas
%
% OUTPUTS:
% ========
% env_v		:
%
% SOURCE:	P. Susini
% LAST UPDATE:	Gfp 08/01/2003
%

function [env_v] = Fnrgfiltre(data_v, Fe_hz, fc_hz);

  % ============================
  if ~nargin
    %a = randn(1000,1);
    %a = [zeros(1000,1); 1; zeros(1000,1)];
    a = [zeros(1000,1); ones(1000,1); zeros(1000,1)];
    
    b = Fnrgfiltre(a, 1, 0.05);             
    plot(a), hold on, plot(b,'r'), hold off, grid on
    return
  end
  % ============================
  
  % ============================
  % calcul du signal analytique: Sanalytique(t) = s(t)+i*TH(s(t)), TH:Transforme de Hilbert
  % ============================
  Sanalytique_v      = hilbert(data_v);
  ampl_Sanalytique_v = abs(Sanalytique_v); 
  
  % ============================
  % filtrage passe-bas d'ordre 3 de frequence de coupure 0<w<1
  % ============================
  w = fc_hz/(Fe_hz/2);
  
  if 0
    monfiltre	= fir1(501, w);
    Lfiltre_n	= length(monfiltre);
    env_v	= conv(ampl_Sanalytique_v, monfiltre);
    env_v	= env_v(Lfiltre_n/2 : end-Lfiltre_n/2);
  else
    [B,A]	= butter(3, w);
    env_v	= filter(B, A, ampl_Sanalytique_v);
    
  end
  

