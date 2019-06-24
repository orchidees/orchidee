function [] = FBmelbandFromSoundFix(db_s, pos_v, doforce, handles)
%function [] = FBmelbandFromSound(db_s, pos_v, doforce)

if nargin < 4
    handles = [];
end
    
    
fid=-1;
check_interruption();
server_says(handles,'Mel envelope analysis',0);
if nargin < 2
    pos_v = 1:length(db_s.data_s);
end 

if nargin < 3
    doforce =0;
end

%% premier calcul pour obtenir la valeur des filtres
%% cela permet d'accélerer les calcul des sons suivants en évitant
%% de recalculer les filtres.

[snd_v, sr_hz] = FreadSoundFile(FgetSoundFileName(db_s, pos_v(1)));
[mel_s, filtre_m] = FmelbandFromSoundFix(snd_v, sr_hz);




for k = pos_v
    try
        if ~exist(FgetMelFixFileName(db_s,k), 'file') | doforce
            [snd_v, sr_hz] = FreadSoundFile(FgetSoundFileName(db_s, k));
	        [mel_s, filtre_m] = FmelbandFromSoundFix(snd_v, sr_hz, filtre_m);
            %%%[mel_s, filtre_m] = FmelbandFromSound(snd_v, sr_hz, db_s.data_s(k).note);
           
        
        save(FgetMelFixFileName(db_s,k), 'mel_s');
        end
    catch
        if fid == -1
            [fid] = FOopenLogFile;
        end
        logMessage = [db_s.data_s(k).file, ' : ' lasterr];
        FOwriteLog(fid, logMessage);
    end
    check_interruption();
    server_says(handles,'Mel envelope analysis',k/length(pos_v));
end
    
FOcloseLogFile(fid);