function [db_s] = FBanalyseDB(db_s,pm2command,compute,handles)
    
if nargin < 4
    handles = [];
end

if compute.mips
    FBpm2f0note(db_s, [],[],pm2command, handles);
    FBpm2analyse(db_s,[],[],pm2command, handles);
end

if compute.mel
    mkdir([db_s.analyse '/melfix']);
    FBmelbandFromSoundFix(db_s,1:length(db_s.data_s),0,handles);
end

if compute.scPOW | compute.ssPOW | compute.LogAttackTime
    mkdir([db_s.analyse '/descripteurs']);
    FBircamdescriptor(db_s,1:length(db_s.data_s),0,handles);
end

if compute.envnSCpow | compute.envnSSpow  | compute.melNoisiness
    mkdir([db_s.analyse '/nl']);
    FBextractPeaksNL(db_s,1:length(db_s.data_s),0,handles);
end
    

if compute.mips
    db_s = FputAmpMeanInDBstruct(db_s,1:length(db_s.data_s),handles);
end

if compute.scPOW | compute.ssPOW | compute.LogAttackTime
    [db_s] = FputDescInDBstruct2(db_s,1:length(db_s.data_s),handles);
end

if compute.mel
    [db_s] = FputMelFixInDBstruct(db_s,1:length(db_s.data_s),handles);
end

if compute.EnergyModAmp2
    db_s = FBmodulationMB(db_s,1:length(db_s.data_s),0,handles);
end

if compute.envnSCpow | compute.envnSSpow
    [db_s] = FBenvndesc(db_s,handles);
end

if compute.melNoisiness
    [db_s] = FBnoisiness2(db_s);
end
