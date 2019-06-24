function [] = FBmelbandFromSound(db_s, pos_v, doforce, handles)
%function [] = FBmelbandFromSound(db_s, pos_v, doforce)
    
if nargin < 4
    handles = [];
end   
    
%LOGDIR = '.';

%filename = [LOGDIR '/' 'log_' mfilename '_' datestr(now, 'dd-mm-yyyy_HH-MM-SS') '.txt'];  
DEFAULTNOTE = 'C2';

check_interruption();
server_says(handles,'Mel envelope analysis',0);

%fid = fopen(filename, 'w');

%if fid == -1
%    error(['Can''t open log file', filename]) 
%end
%h = waitbar(0);
if nargin < 2
    pos_v = 1:length(db_s.data_s);
end 

if nargin < 3
    doforce =0;
end

for k = pos_v
    %try
        if ~exist(FgetMelFileName(db_s,k), 'file') | doforce
            [snd_v, sr_hz] = FreadSoundFile(FgetSoundFileName(db_s, k));
            if isfield(db_s.data_s(k), 'note')
		note = db_s.data_s(k).note;
	    else
		note = DEFAULTNOTE;
	    end
	    mel_s = FmelbandFromSound(snd_v, sr_hz, note);
            save(FgetMelFileName(db_s,k), 'mel_s');
        end
    %catch
    %%    fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
    %            lasterr);
    %    disp(['An error occured: ', lasterr])
    %end 
    
    check_interruption();
    server_says(handles,'Mel envelope analysis',k/length(pos_v));
end
    
%close(h)