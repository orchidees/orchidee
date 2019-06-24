function feature_list = feature_knowledge()

% FEATURE_KNOWLEDGE - Output a lit of feature names for which
% associated neutral, transpo, compare and compute methods are
% implemented in the appropriate subdirectories of '/features/'.
%
% Usage: function feature_list = feature_knowledge()
%

% Get orchidee local path
orchidee_path = fileparts(which('orchidee.m'));

% This is for the compiled version
if strfind(orchidee_path,'orchidee_mcr/orchidee')
    orchidee_path = strrep(orchidee_path,'orchidee_mcr/orchidee','orchidee_mcr');
end

% Initialize outputs
neutral_knowledge = {};
compare_knowledge = {};
compute_knowledge = {};
transpo_knowledge = {};

% List neutral subdir methods
neutral_path = [ orchidee_path '/features/neutral/' ];
contents = what(neutral_path);
contents = contents.m;
for k = 1:length(contents)
    tmp = contents{k};
    tmp = strrep(tmp,'neutral_','');
    tmp = strrep(tmp,'.m','');
    neutral_knowledge{k,1} = tmp;
end

% List compute subdir methods
compute_path = [ orchidee_path '/features/compute/' ];
contents = what(compute_path);
contents = contents.m;
for k = 1:length(contents)
    tmp = contents{k};
    tmp = strrep(tmp,'compute_','');
    tmp = strrep(tmp,'.m','');
    compute_knowledge{k,1} = tmp;
end

% List compare subdir methods
compare_path = [ orchidee_path '/features/compare/' ];
contents = what(compare_path);
contents = contents.m;
for k = 1:length(contents)
    tmp = contents{k};
    tmp = strrep(tmp,'compare_','');
    tmp = strrep(tmp,'.m','');
    compare_knowledge{k,1} = tmp;
end

% List transpo subdir methods
transpo_path = [ orchidee_path '/features/transpo/' ];
contents = what(transpo_path);
contents = contents.m;
for k = 1:length(contents)
    tmp = contents{k};
    tmp = strrep(tmp,'transpo_','');
    tmp = strrep(tmp,'.m','');
    transpo_knowledge{k,1} = tmp;
end

% List methods implemented in all subdirs
feature_list = intersect(neutral_knowledge,compare_knowledge);
feature_list = intersect(feature_list,compute_knowledge);
feature_list = intersect(feature_list,transpo_knowledge);

% Never executed! These lines are juste here to make the Matlab compiler
% generate binaries for all compare, compute, neutral and transpo methods.
if false
    
    % Transpo
    transpo_partialsMeanAmplitude();
    transpo_spectralCentroid();
    transpo_spectralSpread();
    transpo_melMeanEnergy();
    transpo_partialsMeanEnergy();
    transpo_energyModAmp();
    transpo_logAttackTime();
    transpo_loudnessLevel();
    transpo_melMeanAmp();

    % Neutral
    neutral_partialsMeanAmplitude();
    neutral_spectralCentroid();
    neutral_spectralSpread();
    neutral_melMeanEnergy();
    neutral_partialsMeanEnergy();
    neutral_energyModAmp();
    neutral_logAttackTime();
    neutral_loudnessLevel();
    neutral_melMeanAmp();
    
    % Compare
    compare_partialsMeanAmplitude();
    compare_spectralCentroid()
    compare_spectralSpread();
    compare_energyModAmp();
    compare_logAttackTime();
    compare_melMeanAmp();
    
    % Compute
    compute_partialsMeanAmplitude();
    compute_spectralCentroid()
    compute_spectralSpread();
    compute_energyModAmp();
    compute_logAttackTime();
    compute_melMeanAmp();
    
end
