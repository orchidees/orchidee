function write_xml_description_file(xmlexportdir,dbname,dbsource,description_struct)

% WRITE_XML_DESCRIPTION_FILE - Write a desciption structure output
% by 'analyze_db_samples.m' ('analysis' directory) into an XML
% file. A conversion is made between the descriptor names output by
% 'analyze_db_samples.m' (written by Damien Tardieu before
% Orchidee) and the descriptor names used by Orchidee for the sound
% description. The name mapping between Damien Tardieu's
% descriptors and Orchidee descriptors is given in
% DOC/descriptors_mapping.xls.
%
% Usage: write_xml_description_file(xmlexportdir,dbname,dbsource,description_struct)
%

%%%% WRITE INFO DESCRIPTORS %%%%%

% Get URI from file name (remove extension)
dot_idx = max(find(description_struct.file=='.'));
xml_content.info.uri = description_struct.file(1:dot_idx-1);

xml_content.info.file = description_struct.file;
xml_content.info.dir = [ description_struct.dir ];
xml_content.info.dbname = dbname;
xml_content.info.source = dbsource;
xml_content.info.pitchCheck = 'no'; % Yes, pitch is still to be
                                    % checked in all databases !!!
xml_content.info.loudnessFactor = description_struct.Lfacteur;


%%%% WRITE ATTRIBUTES %%%%%

xml_content.attributes.instrument = description_struct.instrument;

% Get instrument family from soundfile path
slash = min(find(description_struct.dir=='/'));
if slash == 1
    description_struct.dir = description_struct.dir(2:length(description_struct.dir));
    slash = min(find(description_struct.dir=='/'));
end
xml_content.attributes.family = description_struct.dir(1:slash-1);

xml_content.attributes.note = description_struct.note;
xml_content.attributes.pitchClass = '';
octave = regexp(xml_content.attributes.note,'\d','match');
octave = octave{1};
xml_content.attributes.octave = str2num(octave);
xml_content.attributes.pitchClass = strrep(xml_content.attributes.note,octave,'');
xml_content.attributes.dynamics = description_struct.dynamique;
xml_content.attributes.string = description_struct.cordes_v;
xml_content.attributes.playingStyle = description_struct.modeDeJeu;

% Separate mutes for brass and strings instruments
if ismember(xml_content.attributes.family,{'Trumpets','Trombones','Tubas','Horns'})
    xml_content.attributes.brassMute = description_struct.sourdine;
else
    xml_content.attributes.brassMute = 'NA';
end
if strcmp(xml_content.attributes.family,'Strings')
    xml_content.attributes.stringMute = description_struct.sourdine;
else
    xml_content.attributes.stringMute = 'NA';
end
    
%%%% WRITE FEATURES %%%%%

% Important note:
% Although noise-related features are implemented in Orchidee
% native sound description database, the methods for their
% automatic extraction from signal are still not available.

xml_content.features.partialsMeanAmplitude = description_struct.ampMean_v;
xml_content.features.spectralCentroid = description_struct.scPOW;
xml_content.features.spectralSpread = description_struct.ssPOW;
xml_content.features.logAttackTime = description_struct.LogAttackTime;
xml_content.features.noiseMeanEnvelope = ones(1,70)*NaN; % Noise feature -> NaN
xml_content.features.melMeanAmp = description_struct.melfMean_v;
xml_content.features.noiseCentroid = NaN; % Noise feature -> NaN
xml_content.features.noiseSpread = NaN; % Noise feature -> NaN
xml_content.features.melNoisiness = NaN; % Noise feature -> NaN
xml_content.features.energyModAmp = description_struct.EnergyModAmp2;
xml_content.features.partialsMeanEnergy = description_struct.ampMeanEner;
xml_content.features.loudnessLevel = Fdyn2loudnessLevel(description_struct.dynamique);
xml_content.features.noiseMeanEnergy = NaN; % Noise feature -> NaN
xml_content.features.melMeanEnergy = description_struct.melfMeanEner;

% If needed, create appopriate subdirectories to write the XML file
pat = '(?<family>\w+)/(?<instrument>\w+)/(?<playStyle>\w+)';
dir_struct = regexp(xml_content.info.dir,pat,'names');
% Create root dir if needed
rootdir = [ xmlexportdir '/' dbname ];
if ~exist(rootdir), mkdir(rootdir); end
% Create family dir if needed
famdir = [ rootdir '/' dir_struct.family ];
if ~exist(famdir), mkdir(famdir); end
% Create instrument dir if needed
instdir = [ famdir '/' dir_struct.instrument ];
if ~exist(instdir), mkdir(instdir); end
% Create playing style dir  if needed
psdir = [ rootdir '/' xml_content.info.dir ];
if ~exist(psdir), mkdir(psdir); end

% Remove eventual old XML file
D = dir([ psdir '/' xml_content.info.uri '*.xml']);
for k = 1:length(D)
   cmd = [ 'rm ' psdir '/' D(k).name];
   unix(cmd);
end

% Write XML file
xmlfilename = [ psdir '/' xml_content.info.uri '_' datestr(now,'yyyymmddHHMMSS') '.xml' ];
xml_save(xmlfilename,xml_content);

