function [] = FBpm2analyse(database_s, pos_v, doforce, pm2command, handles)
%function [] = FBpm2analyse(database_s, pos_v, doforce)

if nargin < 5
    handles = [];
end

fid=-1;
check_interruption();
server_says(handles,'Extracting partials',0);
if nargin<2 | isempty(pos_v)
    pos_v = 1:length(database_s.data_s);
end
if nargin < 3 | isempty(doforce)
    doforce = 0;
end
if nargin < 4
    pm2command='pm2';
end

for k = pos_v
    try
        if ~exist(FgetPartFileName(database_s,k), 'file') | doforce
            [s,w] = Fpm2analyse(FgetSoundFileName(database_s,k), ... 
                                FgetF0FileName(database_s,k), ... 
                                FgetPartFileName(database_s,k), ... 
                                database_s.data_s(k).note, ...
                                pm2command);
            if s
                error(w);
            end
        end
    catch
        if fid == -1
            [fid] = FOopenLogFile;
        end
        logMessage = [database_s.data_s(k).file, ' : ' lasterr];
        FOwriteLog(fid, logMessage);
    end
    
    check_interruption();
    server_says(handles,'Extracting partials',k/length(pos_v));
end
    
FOcloseLogFile(fid);