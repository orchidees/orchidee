function session_instance = set_sound_file(session_instance,sound_file)

% SET_SOUND_FILE - Set a new sound target in current session.
%
% Usage: session_instance = set_sound_file(session_instance,sound_file)
%

% Set new sound target
session_instance.target = set_sound_file(session_instance.target,sound_file);

% Attribute domains, variable domains and feature matrices will
% need to be recomputed
session_instance.need_update.dom_attributes = 1;
session_instance.need_update.dom_variables = 1;
session_instance.need_update.mat_features = 1;

