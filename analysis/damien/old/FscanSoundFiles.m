function [db_s] = FscanSoundFiles(ROOTDIR)
    
%% Brutal: on scan type par type.
    
filetypes_c = {'aif', 'aiff', 'wav'};

db_s = FscanFiles(ROOTDIR, filetypes_c{1});
for k = 2:length(filetypes_c)
    dbTmp_s = FscanFiles(ROOTDIR, filetypes_c{k});
    db_s.data_s = [db_s.data_s, dbTmp_s.data_s];
end