function [] = FBextractPeaksNL(db_s, pos_v, doforce, handles)
%function [] = FBmelbandFromNoise(db_s, pos_v, doforce)

if nargin < 4
    handles = [];
end
    
check_interruption();
server_says(handles,'Noise envelope analysis',0);
if nargin < 2
    pos_v = 1:length(db_s.data_s);
end 
if nargin < 3
    doforce = 0;
end
fid = -1;
for k = pos_v
    try
        if ~exist(FgetNlFileName(db_s,k), 'file') | doforce
	    [fz,p]=FextractPeaksNL(['-smf 22050 -ssize 8100 -sfeed 4000 -on ' FgetNlFileName(db_s,k) ' -in ', FgetSoundFileName(db_s, k)]);
	end
    catch
        if fid == -1
            [fid] = FOopenLogFile;
        end
        logMessage = [db_s.data_s(k).file, ' : ' lasterr];
        FOwriteLog(fid, logMessage);
    end 
    check_interruption();
    server_says(handles,'Noise envelope analysis',k/length(db_s.data_s));
end

FOcloseLogFile(fid);