function [db_s] = FBmodulationMB(db_s, pos_v, doforce, handles)

if nargin < 4
    handles = [];
end
%function [db_s] = FBmodulationMB(db_s, pos_v, doforce)
    
    
fid=-1;

server_says(handles,'Computing modulations',0);

if nargin < 2
    pos_v = 1:length(db_s.data_s);
end 
if nargin < 3
    doforce = 0;
end
for k = pos_v
    try
	[snd_v, sr_hz] = FreadSoundFile(FgetSoundFileName(db_s, k));
	env_v =Fnrgfiltre(snd_v, sr_hz, 60);
	[f0_hz, f0_amp, f0_paramTemps, xMean_v, msqError_v] = FmodulationMB(env_v, sr_hz);
	db_s.data_s(k).EnergyModFreq2 = median(f0_hz);
	db_s.data_s(k).EnergyModAmp2 = median(f0_amp);
    catch
        if fid == -1
            [fid] = FOopenLogFile;
        end
        logMessage = [db_s.data_s(k).file, ' : ' lasterr];
        FOwriteLog(fid, logMessage);
    end 
    server_says(handles,'Computing modulations',k/length(pos_v));
   
end
FOcloseLogFile(fid);

