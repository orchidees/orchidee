function [database_s] = FBextractParamFromName(database_s, nomenclature, handles)


fid = -1;

check_interruption();
server_says(handles,'Extracting info from sound file name',0);

for k = 1:length(database_s.data_s),
    try
        param_s = FextractParamFromName(database_s.data_s(k).file, nomenclature);
        if isempty(param_s)
            fprintf(fid, '%s\n', database_s.data_s(k).file);
        else
            nom = fieldnames(param_s);
            
            for m = 1:length(nom)
                database_s.data_s(k).(nom{m}) = param_s.(nom{m});
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
    server_says(handles,'Extracting info from sound file name',k/length(database_s.data_s));
end

FOcloseLogFile(fid);