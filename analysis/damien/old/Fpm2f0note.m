function [status, command_v] = Fpm2f0note(soundfile, note, outsdiffile, f0range,pm2command)
%function [status, command_v] = Fpm2f0note(soundfile, note, outsdiffile)
%
%  Calcul de la f0 avec pm2 en prenant en compte la note. La note
%  permet de déterminer les paramêtre de pm2
%  f0range est en ton
    


if nargin < 4 | isempty(f0range)
    f0range = 1;
end
clear datai_v;
[tmp, sr_hz] = FreadSoundFile(soundfile, 2);

if nargin < 5
    pm2command = 'pm2';
end

f0 = Fnote2freq2(note);


f0range_v = [f0*2^(-(1/6)*f0range), f0*2^((1/6)*f0range)]; % entre 4 et 5 demi ton au dessus
                                 % et en dessous


winsize_k = sr_hz*(4/f0range_v(1));
hopsize_k = floor(winsize_k/4);

fmin = num2str(f0range_v(1));
fmax = num2str(f0range_v(2));

%minwinsize = 2^(ceil(log2(hopsize_sec * 3 * sr_hz))) -1;

%winsize = num2str(2^ (ceil(log2(winsize_k))));
minwinsize_sec = .01;
minwinsize_k = 2^(nextpow2(minwinsize_sec*sr_hz)-1);
winsize = max(2^(ceil(log2(winsize_k))) - 1, minwinsize_k);
winsize_asc = num2str(winsize);
fftsize = num2str(2^ (ceil(log2(winsize))+1));
bwf0 = num2str(min(15*f0, sr_hz));
hopsize = num2str(hopsize_k);

command_v = [pm2command ' -Af0 -S' soundfile ... 
             ' --f0min=' fmin ' --f0max=' fmax ...
             ' -M' winsize_asc ...
             ' -N' fftsize ...
             ' --f0ana=' bwf0 ...
             ' -I' hopsize ...
             ' --f0use ' ...
             ' ' outsdiffile ';'];

status = unix(command_v);
