function [db_s] = FnewDB(soundfiledbroot,xmldbroot,handles)



if nargin < 3
    handles = [];
end


soundfiledbroot = ls('-d',soundfiledbroot);
soundfiledbroot = soundfiledbroot(1:length(soundfiledbroot)-1);
soundfiledbroot = [ soundfiledbroot '/' ];
soundfiledbroot = strrep(soundfiledbroot,'//','/');

xmldbroot = ls('-d',xmldbroot);
xmldbroot = xmldbroot(1:length(xmldbroot)-1);
xmldbroot = [ xmldbroot '/' ];
xmldbroot = strrep(xmldbroot,'//','/');






compute.mips = 1;
compute.mel = 1;
compute.scPOW = 1;
compute.ssPOW = 1;
compute.LogAttackTime = 1;
compute.envn = 0;
compute.Lfacteur = 1;
compute.loudnessLevel = 1;
compute.envnSCpow = 0;
compute.envnSSpow = 0;
compute.melNoisiness = 0;
compute.EnergyModAmp2 = 1;

pm2command = find_pm2_pathes;
pm2command = pm2command{1};



db_s = find_new_samples(soundfiledbroot,xmldbroot,handles);

if ~isempty(db_s.data_s)

    db_s.analyse = [soundfiledbroot, '/analyse/'];
    db_s.additive = [soundfiledbroot, '/analyse/additive/'];

    db_s = FBextractParamFromName(db_s, 'sol2.0',handles);

    if ~exist(db_s.analyse)
        mkdir(db_s.analyse);
    end

    if ~exist(db_s.additive)
        mkdir(db_s.additive);
    end


    [db_s] = FBanalyseDB(db_s,pm2command, compute, handles);

end
