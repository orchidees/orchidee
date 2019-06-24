function features = analyze_sound(soundfile,parameters,handles)

% ANALYZE_SOUND - Extract sound features from sound target.
%
% Usage: features = analyze_sound(soundfile,parameters,handles)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Get pm2 path
pm2path = find_pm2_pathes;
if isempty(pm2path)
    error('orchidee:analysis:analyze_sound:MissingComponent', ...
        'pm2 or AudioSculpt missing in your /Applications/ folder.');
end
pm2command = pm2path{1};

% Call Damien Tardieu's target analysis routine
target_features = FanalyseTarget(soundfile,parameters.fmin,parameters.npartials,parameters.t1,parameters.t2,pm2command,handles);

clear Fsdif_read_handler;

% Rename features from Damien Tardieu's terminology to Orchidee
% termiology (see DOC/descriptors_mapping.xls for the equivalence)
features.partialsMeanFrequency = target_features.freqMIPs_v;
features.partialsMeanAmplitude = target_features.ampMIPs_v;
features.spectralCentroid = target_features.scPOW;
features.spectralSpread = target_features.ssPOW;
features.logAttackTime = target_features.LogAttackTime;
features.melMeanAmp = target_features.melfMean_v;
features.energyModAmp = target_features.EnergyModAmp2;