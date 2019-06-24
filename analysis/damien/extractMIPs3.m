function [F_MIPs,A_MIPs,Astd_MIPs] = extractMIPs3(sf,ANAL_DIR,f0min,nMIPs,t_debut,t_fin,pm2command)

if nargin < 7
    pm2command = 'pm2';
end

if nargin < 6
    t_fin = 1.5;
end

if nargin < 5
    debut = 0.5;
end

if nargin < 4
    nMIPs = 15;
end

if nargin < 3
    f0min = 20;
end

[tmp_v, sr_hz] = FreadSoundFile(sf, 2);

%disp(' ... pm2 chordseq');

[freq_v,amp_v,ampStd_v] = FchordSeq(sf, ANAL_DIR, sr_hz, f0min, nMIPs*5, t_debut, t_fin,pm2command);

%disp(' ... auditory model filter');

[F_MIPs,A_MIPs,Astd_MIPs] = Fmips2(freq_v,amp_v,ampStd_v,nMIPs, f0min);

