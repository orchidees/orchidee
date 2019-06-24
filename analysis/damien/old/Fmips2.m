function [freqo_v,ampo_v,ampStdo_v,poso_v] = Fmips2(freqi_v,ampi_v,ampStdi_v,numpartialsin,fmin)

Freqtok = 0;
amptok = 0;
ampStdtok=0;
if size(freqi_v, 1) > size(freqi_v, 2),
  freqi_v = freqi_v';
  freqtok = 1;
end

if size(ampi_v, 1) > size(ampi_v, 2),
  ampi_v = ampi_v';
  amptok = 1;
end

if size(ampStdi_v, 1) > size(ampStdi_v, 2),
  ampStdi_v = ampStdi_v';
  ampStdtok = 1;
end

if nargin < 3
    numpartialsin = 10;
end
if nargin < 4
    fmin = 60;
end

if length(ampi_v) ~= length(freqi_v),
    warning(['Frequency and amplitude vectors are not the same ' ...
             'size']);
    L = min(length(ampi_v), length(freqi_v));
    ampi_v = ampi_v(1:L);
    ampStdi_v = ampStdi_v(1:L);
    freqi_v = freqi_v(1:L);
end

pos_v = find(freqi_v >= fmin);
freq_v = freqi_v(pos_v);
amp_v = ampi_v(pos_v);
ampStd_v = ampStdi_v(pos_v);

if length(freq_v) < numpartialsin
    [freqo_v,poso_v] = sort(freq_v);
    ampo_v = amp_v(poso_v);
    ampStdo_v = ampStd_v(poso_v);
    
    return
end

d_v = pdist(ERBfromhz(freq_v'));
Z = linkage(d_v, 'complete');
T = cluster(Z,'maxclust',numpartialsin);

for k=1:max(T)
    pos_v = find(T==k);
    [mv, mp] = max(amp_v(pos_v));
    freqo_v(k) = freq_v(pos_v(mp)); 
    ampo_v(k) = amp_v(pos_v(mp)); 
    ampStdo_v(k) = ampStd_v(pos_v(mp)); 
end
poso_v = 1;

[freqo_v, poso_v] = sort(freqo_v);
freqo_v = freqo_v';
ampo_v = ampo_v(poso_v)';
ampStdo_v = ampStdo_v(poso_v)';
