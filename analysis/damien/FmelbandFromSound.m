function [ampbank_s, filtre_s] = FmelbandFromSound(snd_v, sr_hz, ...
                                                  note, nbChannel)
%function [ampbank_s, filtre_s] = FmelbandFromSound(snd_v, sr_hz, note)
    

if nargin < 4
    nbChannel = 70;
end

hopsize_sec = .01;
hopsize_k = hopsize_sec*sr_hz;

if ischar(note)
    f0 = Fnote2freq2(note);
    winsize_k = sr_hz*(4/f0);
    minwinsize = 2^(ceil(log2(hopsize_sec * sr_hz))+1);
    winsize_k = max(2^(ceil(log2(winsize_k))), minwinsize);
    winsize_k = min(winsize_k, 2^floor(log2(length(snd_v))));
else
    winsize_k = note;
end
%% Signal must be longer than window size

noverlap_k = winsize_k-hopsize_k;
fftsize_k = winsize_k;

fenetre_v = rectwin(winsize_k);
[y,f,t,p] = spectrogram(snd_v,fenetre_v,noverlap_k,fftsize_k, sr_hz);

amp_s.value = [abs(y)]./sum(fenetre_v)*2;
amp_s.unit = 'lin';
[ampbank_s, filtre_s] = Fmelband(amp_s, fftsize_k, sr_hz, [], nbChannel);
ampbank_s.time = t;
