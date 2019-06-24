function [s,w] = Fpm2analyse(soundfilei, f0filei, PARTsdiffile, note,pm2command)
%function [s] = Fpm2analyse(soundfilei, f0filei, PARTsdiffile, note)


global TMPDIR    

if ~ischar(soundfilei)
    soundfile = [TMPDIR '/tmp-FadditiveNote.wav'];
    wavwrite(soundfilei, sr_hz, soundfile);
else
    soundfile = soundfilei;
end

[tmp, sr_hz] = FreadSoundFile(soundfilei);

if nargin < 5
    pm2command = 'pm2';
end

f0 = Fnote2freq2(note);

hopsize_sec = .01; % en sec

%PARTsdiffile = './pouet.sdif';
F0sdiffile = f0filei; 

minwinsize = 2^(ceil(log2(hopsize_sec * 3 * 44100))) -1;
winsize = 4/f0 * sr_hz;
winsize = max(2^(ceil(log2(winsize))) - 1, minwinsize);
winsize_asc = num2str(winsize);
fftsize = 2^ (ceil(log2(winsize))+1);
fftsize_asc = num2str(fftsize);
hopsize_k = hopsize_sec * sr_hz;
hopsize_asc = num2str(hopsize_k);


command = [pm2command  ' -S' soundfile ' -Apar -N' fftsize_asc ... 
           ' -M'  winsize_asc ' -I' hopsize_asc  ' -Wblackman  -OS ' ... 
           ' -P' F0sdiffile  ' -c0.5 -a0 -r0 ' ...
           PARTsdiffile];


[s,w] = unix(command);

if s
    error(w)
end
% if nargout
%     filename = FrootDirFromAbsolute(soundfile);
%     pos_v = strfind(filename, '.');
%     filename = filename(1:pos_v(end)-1);
%     sdiffile = [analysedir '/ADD' filename '/' filename '.part.sdif'];
%     part_s = Floadsdif(sdiffile);
% end
