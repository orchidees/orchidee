function [] = FBircamdescriptor(database_s, pos_v, doforce, handles)
%function [] = FBircamdescriptor(database_s, pos_v, doforce)


if nargin < 4
    handles = [];
end
    
if nargin < 2
    pos_v = 1:length(database_s.data_s);
end


%current_dir = pwd;
%ircam_desc_dir = fileparts(which('ircamdescriptor'));
%cd(ircam_desc_dir);



if nargin < 3
    doforce = 0;
end
fid = -1;
try
    ircamdescriptor('-a', 'readlist');

    check_interruption();
    server_says(handles,'Ircamdescriptor analysis',0);
    for k=pos_v
        try
            if ~exist(FgetDescFileName(database_s,k)) | doforce
                
                succes = ircamdescriptor('-a', 'extraction', ... 
                                         '-i', FgetSoundFileName(database_s, k), ... 
                                         '-envfc', '60', ...
                                         '-omat', FgetDescFileName(database_s, k));
                if ~succes
                    error('Erreur dans ircamdescriptor')
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
        server_says(handles,'Ircamdescriptor analysis',k./length(pos_v));
    end 
    
    %cd(current_dir);
catch
    %cd(current_dir);
    if fid == -1
        [fid] = FOopenLogFile;
    end
    logMessage = [lasterr];
    FOwriteLog(fid, logMessage);
end
    
FOcloseLogFile(fid);
