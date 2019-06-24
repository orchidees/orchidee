function orchestra_instance = set_resolution(orchestra_instance,microtonic_resolution)

% SET_RESOLUTION - Modifier of slot 'microtonic_resolution' in an
% orchestra instance.
%
% Usage: orchestra_instance = set_resolution(orchestra_instance,microtonic_resolution)
%

% Check the validity of the new resolution value
if ~ismember(microtonic_resolution,orchestra_instance.allowed_resolutions)
    error('orchidee:orchestra:set_resolution:BadArgumentValue', ...
        [ 'Allowed values for microtonic resolution: ' mat2str(orchestra_instance.allowed_resolutions) ' (fractions of semitones).']);
end

% Assgin new value
orchestra_instance.microtonic_resolution = microtonic_resolution;