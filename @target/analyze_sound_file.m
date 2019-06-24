function target_instance = analyze_sound_file(target_instance,knowledge_instance,handles)

% ANALYZE_SOUND_FILE -
%
% Usage: target_instance = analyze_sound_file(target_instance,knowledge_instance,handles)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Check a soundfile is specified
if ~exist(target_instance.soundfile)
    error('orchidee:target:analyze_sound_file:CannotOpenFile', ...
        'Nothing to analyze.' );
end

% Call sound analysis method
target_instance.features = analyze_sound(target_instance.soundfile,target_instance.parameters,handles);

