function [ampbank_s, filtre_m] = FmelbandFromSoundFix(snd_v, sr_hz,filtre_m)
%function [ampbank_s, filtre_s] = FmelbandFromSound(snd_v, sr_hz, note)
    

nbFiltre = 70;


winsize_k = 8100;
hopsize_k = 4000;
noverlap_k = winsize_k-hopsize_k;
fftsize_k = 32768;

if nargin < 3
    filtre_m = melbankm(nbFiltre, fftsize_k-1, sr_hz);
end


fenetre_v = blackman(winsize_k);
if length(snd_v)<winsize_k,
     snd_v = [snd_v; zeros(winsize_k-length(snd_v),1)];
end
[y,f,t,p] = spectrogram(snd_v,fenetre_v,noverlap_k,fftsize_k-1, sr_hz);

amp_m = [abs(y)]./sum(fenetre_v)*2;
ampbank_s.value = filtre_m * amp_m;

ampbank_s.time = t;
