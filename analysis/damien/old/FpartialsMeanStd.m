function [mean_v, std_v, stdN_v] = FpartialsMeanStd(amp_m,ld_v,fs)
%function [mean_v, std_v, stdN_v] = FpartialsMeanStd(amp_m,ld_v,fs)
% ld_v, la loudness de chaque trame 
% fs la fréquence d'échantillonnage de ld_v et amp_m
    
    

    
freqBandHz_v = [3, 50];
fmax = freqBandHz_v(end);
fmin = freqBandHz_v(1);

%fs = 1/median(diff(amp_s.temps));
windowsize = ceil(2/fmin * fs);
hopsize = floor(1/4*windowsize);

ld2_v = sum(frames(ld_v, windowsize, hopsize), 1);

for k = 1:size(amp_m, 2)
    xframed = frames(amp_m(:,k), windowsize, hopsize);
    
    xMean_v = mean(xframed);
    
    L = min(length(xMean_v), length(ld2_v));
    mean_v(k) = Fmean(xMean_v(1:L), ld2_v(1:L));
    std_v(k) = Fv_wstd2(xMean_v(1:L)', ld2_v(1:L));
%     mean_v(k) = mean(xMean_v);
%     std_v(k) = std(xMean_v);
end
stdN_v = zeros(size(mean_v));
pos_v = find(mean_v);
stdN_v(pos_v) = std_v(pos_v)./mean_v(pos_v);
    