function target_instance = set_sound_file(target_instance,sound_file)

% SET_SOUND_FILE - Define a target sound file.
%
% Usage: target_instance = set_sound_file(target_instance,sound_file)
%

% Allowed formats
allowed_sound_formats = { '.aiff' '.aif' '.wav' };

% Check that soundfile exists
if ~exist(sound_file)
    error('orchidee:target:set_sound_file:CannotOpenFile', ...
        [ sound_file ': file does not exist.' ] );
end

% Check that soundfile is a file
if exist(sound_file) ~= 2
    error('orchidee:target:set_sound_file:BadArgumentValue', ...
        [ sound_file ' is not a valid sound file.' ] );
end

% Check file format (assume extension is meaningful)
[P,N,ext] = fileparts(sound_file);
ext = lower(ext);
if ~ismember(ext,allowed_sound_formats)
    error('orchidee:target:set_sound_file:BadArgumentValue', ...
        [ '''' sound_file ''' : invalid sound file format.' ] );
end

% Get soundfile absolute path
if sound_file(1) == '~'
    sound_file = [ home_directory sound_file(2:length(sound_file)) ];
end

% If new soundfile is different than actual soundfile, replace it
% and clear feature slot
if ~strcmp(target_instance.soundfile,sound_file)
    target_instance.soundfile = sound_file;
    target_instance.filetype = strrep(ext,'.','');
    target_instance.features = [];
end