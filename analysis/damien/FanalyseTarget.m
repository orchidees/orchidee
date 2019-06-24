function [target_s] = FanalyseTarget(filename, minf0, nMIPs, t_begin, t_end, pm2command, handles)

if nargin < 7
    handles = [];
end

DIR = ['/tmp/' mfilename datestr(now, 'dd-mm-yyyy_HH-MM-SS') '/'];

unix('rm -rf /tmp/FanalyseTarget*');
unix('rm -f log_FputDescInDBstruct*');
unix('rm -f /tmp/orchidee_tmp_sound_file.wav');
    
    
compute.mips = 1;
compute.mel = 1;
compute.scPOW = 1;
compute.ssPOW = 1;
compute.LogAttackTime = 1;
compute.envn = 0;
compute.Lfacteur = 1;
compute.loudnessLevel = 1;
compute.envnSCpow = 0;
compute.envnSSpow = 0;
compute.melNoisiness = 0;
compute.EnergyModAmp2 = 1;



if ~exist(DIR)
    mkdir(DIR);
end

[data_v, sr_hz, nbits, format] = FreadSoundFile(filename);
if ~ismember(sr_hz,[11025 22050 44100])
    error('orchidee:analysis:damien:FanalyseTarget:InvalidFileFormat', ...
        'Target soundfile sampling rate must be 11025, 22050 or 44100 Hz.')
end


eof = size(data_v,1)/sr_hz;
if t_end > eof
    t_end = eof*0.99;
end
i_begin = max(floor(t_begin*sr_hz),1);
i_end = floor(t_end*sr_hz);
data_v = data_v(i_begin:i_end,1);
wavwrite(data_v,sr_hz,nbits,'/tmp/orchidee_tmp_sound_file.wav');
t_begin = 0;
t_end = (i_end-i_begin)/sr_hz;
filename = '/tmp/orchidee_tmp_sound_file.wav';

[A,B,C] = fileparts(filename);
tmptgt_s.racine = A;
tmptgt_s.data_s(1).file = [B,C];
tmptgt_s.data_s(1).dir = '/';
tmptgt_s.data_s(1).dynamique = 'mf';
tmptgt_s.analyse = DIR;

if compute.mips
    server_says(handles,'Main partials analysis',0);
    [F,A, Astd] = extractMIPs3(filename,DIR,minf0,nMIPs,t_begin,t_end,pm2command);
    server_says(handles,'Main partials analysis',1);
    target_s.freqMIPs_v = reshape(F,1,[]);
    target_s.ampMIPs_v = reshape(A,1,[]);
    ampMeanNorm = norm(A);
    target.freqMean_v = F(:);
    target.ampMean_v = A(:) ./ ampMeanNorm;
    target.ampMeanEner = ampMeanNorm^2;    
end
tmpcomputemips = compute.mips;
compute.mips = 0;
[tmptgt_s] = FBanalyseDB(tmptgt_s, pm2command, compute, handles);
compute.mips=tmpcomputemips;
fieldname_c = fieldnames(tmptgt_s.data_s);
for k=1:length(fieldname_c)
    if isnumeric(tmptgt_s.data_s(1).(fieldname_c{k}));
        target_s.(fieldname_c{k}) = tmptgt_s.data_s(1).(fieldname_c{k});
    end
end

command_v = ['rm -rf ' DIR];
unix(command_v);
unix('rm -f /tmp/log_FputDescInDBstruct*');
unix('rm -f /tmp/log_FputMelFixInDBstruct*');
unix('rm -f /tmp/orchidee_tmp_sound_file.wav');
