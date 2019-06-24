function [] = FBpm2f0note(database_s, pos_v, doforce, pm2command, handles)
%function [] = FBpm2f0note(database_s, pos_v, doforce)
%    
%   Batch de la fonction Fpm2f0note 
%

if nargin < 5
    handles = [];
end

    fid = -1;
    check_interruption();
    server_says(handles,'Computing f0',0);
    if nargin < 3 | isempty(doforce)
        doforce = 0;
    end
    if nargin < 2 | isempty(pos_v)
        pos_v = 1:length(database_s.data_s);
    end
    
    for k=pos_v
        
        
        
        if doforce
            docalc = 1;
        else
            if ~exist(FgetF0FileName(database_s,k), 'file')
                docalc = 1;
            else
                docalc = 0;
            end
        end
        if docalc
            
            [tmp,f0dir] = Ffiletodirroot(FgetF0FileName(database_s,k));
            if ~exist(f0dir)
                mkdir(f0dir);
            end
            
            try
                [status, command_v] = Fpm2f0note(FgetSoundFileName(database_s, k), ...
                                                 database_s.data_s(k).note, ...
                                                 FgetF0FileName(database_s,k), ...
                                                 [],...
                                                 pm2command);
                
                
                
            catch
                if fid == -1
                    [fid] = FOopenLogFile;
                end
                logMessage = [database_s.data_s(k).file, ' : ' lasterr];
                FOwriteLog(fid, logMessage);
            end
            check_interruption();
            server_says(handles,'Computing f0',k/length(pos_v));
        end
    end
    
    FOcloseLogFile(fid);