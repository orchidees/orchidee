function  [N6] = FcalcN6(mel_s) 
%function  [] = FcalcLoudnessPrctile(amp_m) 
%
% Calcul L10, L20, L30, L50 et L90. Prctile de la loudness
% approximée par amplitude^.6
%
amp_m = mel_s.value';
loud_v = sum(amp_m.^.6, 2);
ener_v = sum(amp_m.^2, 2);
maxener = max(ener_v);
maxloud = max(loud_v);
%% max ener -20 dB (sone)
pos_v = find(ener_v>10^-3*maxener);
N6 = 10*log2(prctile(loud_v(pos_v), 94));
