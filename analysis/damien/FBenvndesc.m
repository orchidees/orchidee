function [db_s] = FBenvndesc(db_s,handles)
    
if nargin < 2
    handles = [];
end
    
mel_s = Fload('./filtreMel.mat');
freq_v = mel_s.center;

check_interruption();
server_says(handles,'Computing noise moments',0);
for k=1:length(db_s.data_s)
    db_s.data_s(k).envnSClin = Fmean(freq_v, db_s.data_s(k).envnMean_v);
    db_s.data_s(k).envnSSlin = Fv_wstd2(freq_v, db_s.data_s(k).envnMean_v);
    db_s.data_s(k).envnSCpow = Fmean(freq_v, db_s.data_s(k).envnMean_v.^2);
    db_s.data_s(k).envnSSpow = Fv_wstd2(freq_v, db_s.data_s(k).envnMean_v.^2);
    
    check_interruption();
    server_says(handles,'Computing noise moments',k/length(db_s.data_s));
end